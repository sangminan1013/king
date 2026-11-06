create table public.room_owner_recovery (
  room_id uuid primary key references public.rooms(id) on delete cascade,
  token_hash text not null check (token_hash ~ '^[0-9a-f]{64}$'),
  created_at timestamptz not null default now()
);

alter table public.room_owner_recovery enable row level security;

revoke all on public.room_owner_recovery from public, anon, authenticated;

create or replace function public.reclaim_room_ownership(
  target_room_id uuid,
  new_owner_id uuid,
  supplied_hash text
)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  current_owner_id uuid;
begin
  if not exists (
    select 1
    from public.room_owner_recovery
    where room_id = target_room_id
      and token_hash = supplied_hash
  ) then
    return false;
  end if;

  select owner_id
  into current_owner_id
  from public.rooms
  where id = target_room_id
  for update;

  if current_owner_id is null then
    return false;
  end if;

  update public.room_members
  set role = 'member'
  where room_id = target_room_id
    and role = 'owner';

  insert into public.room_members (room_id, user_id, role)
  values (target_room_id, new_owner_id, 'owner')
  on conflict (room_id, user_id)
  do update set role = excluded.role;

  update public.rooms
  set owner_id = new_owner_id
  where id = target_room_id;

  return true;
end;
$$;

revoke all on function public.reclaim_room_ownership(uuid, uuid, text)
from public, anon, authenticated;
grant execute on function public.reclaim_room_ownership(uuid, uuid, text)
to service_role;
