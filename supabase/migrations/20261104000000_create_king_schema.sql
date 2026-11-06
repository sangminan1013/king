create extension if not exists pgcrypto;

create table public.rooms (
  id uuid primary key default gen_random_uuid(),
  invite_code text not null unique
    check (invite_code = upper(invite_code) and char_length(invite_code) between 6 and 12),
  owner_id uuid not null references auth.users(id) on delete cascade,
  group_name text not null check (char_length(group_name) between 1 and 24),
  topic text not null check (char_length(topic) between 1 and 120),
  member_limit integer not null check (member_limit between 2 and 12),
  status text not null default 'collecting'
    check (status in ('collecting', 'finalized')),
  created_at timestamptz not null default now(),
  finalized_at timestamptz,
  check (
    (status = 'collecting' and finalized_at is null)
    or (status = 'finalized' and finalized_at is not null)
  )
);

create table public.room_members (
  room_id uuid not null references public.rooms(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null default 'member' check (role in ('owner', 'member')),
  joined_at timestamptz not null default now(),
  primary key (room_id, user_id)
);

create table public.opinions (
  id uuid primary key default gen_random_uuid(),
  room_id uuid not null references public.rooms(id) on delete cascade,
  author_id uuid not null references auth.users(id) on delete cascade,
  content text not null check (char_length(content) between 10 and 300),
  submitted_at timestamptz not null default now(),
  unique (room_id, author_id)
);

create table public.verdicts (
  room_id uuid primary key references public.rooms(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 120),
  summary text not null check (char_length(summary) between 1 and 300),
  fit_score integer not null check (fit_score between 0 and 100),
  reasons jsonb not null
    check (jsonb_typeof(reasons) = 'array' and jsonb_array_length(reasons) = 3),
  created_at timestamptz not null default now()
);

create index room_members_user_id_idx on public.room_members(user_id);
create index opinions_room_id_idx on public.opinions(room_id);
create index rooms_owner_id_idx on public.rooms(owner_id);
create index rooms_status_idx on public.rooms(status);

alter table public.rooms enable row level security;
alter table public.room_members enable row level security;
alter table public.opinions enable row level security;
alter table public.verdicts enable row level security;

create or replace function public.is_room_member(target_room_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.room_members
    where room_id = target_room_id
      and user_id = auth.uid()
  );
$$;

revoke all on function public.is_room_member(uuid) from public;
grant execute on function public.is_room_member(uuid) to authenticated;

create or replace function public.add_room_owner_membership()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.room_members (room_id, user_id, role)
  values (new.id, new.owner_id, 'owner');
  return new;
end;
$$;

create trigger add_room_owner_after_insert
after insert on public.rooms
for each row execute function public.add_room_owner_membership();

create or replace function public.join_room_by_code(requested_code text)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  target_room public.rooms;
  current_members integer;
begin
  if auth.uid() is null then
    raise exception 'Authentication required' using errcode = '42501';
  end if;

  select *
  into target_room
  from public.rooms
  where invite_code = upper(trim(requested_code))
  for update;

  if target_room.id is null then
    raise exception 'Room not found' using errcode = 'P0002';
  end if;

  if target_room.status <> 'collecting' then
    raise exception 'Room is closed' using errcode = 'P0001';
  end if;

  if exists (
    select 1
    from public.room_members
    where room_id = target_room.id
      and user_id = auth.uid()
  ) then
    return target_room.id;
  end if;

  select count(*)
  into current_members
  from public.room_members
  where room_id = target_room.id;

  if current_members >= target_room.member_limit then
    raise exception 'Room is full' using errcode = 'P0001';
  end if;

  insert into public.room_members (room_id, user_id, role)
  values (target_room.id, auth.uid(), 'member');

  return target_room.id;
end;
$$;

revoke all on function public.join_room_by_code(text) from public;
grant execute on function public.join_room_by_code(text) to authenticated;

grant select, insert, update on public.rooms to authenticated;
grant select on public.room_members to authenticated;
grant select, insert on public.opinions to authenticated;
grant select on public.verdicts to authenticated;

create policy rooms_select_for_members
on public.rooms
for select
to authenticated
using (public.is_room_member(id));

create policy rooms_insert_for_owner
on public.rooms
for insert
to authenticated
with check (owner_id = auth.uid());

create policy rooms_update_for_owner
on public.rooms
for update
to authenticated
using (owner_id = auth.uid())
with check (owner_id = auth.uid());

create policy room_members_select_for_members
on public.room_members
for select
to authenticated
using (public.is_room_member(room_id));

create policy opinions_select_after_verdict
on public.opinions
for select
to authenticated
using (
  public.is_room_member(room_id)
  and exists (
    select 1
    from public.verdicts
    where verdicts.room_id = opinions.room_id
  )
);

create policy opinions_insert_once_for_self
on public.opinions
for insert
to authenticated
with check (
  author_id = auth.uid()
  and public.is_room_member(room_id)
  and exists (
    select 1
    from public.rooms
    where rooms.id = opinions.room_id
      and rooms.status = 'collecting'
  )
);

create policy verdicts_select_for_members
on public.verdicts
for select
to authenticated
using (public.is_room_member(room_id));
