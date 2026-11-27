-- Preserve existing rooms/codes. New codes are four lowercase letters/digits.
-- Apply before deploying the updated server function.
alter table public.rooms drop constraint if exists rooms_invite_code_check;
alter table public.rooms add constraint rooms_invite_code_check check (
  invite_code ~ '^[a-z0-9]{4}$'
  or invite_code ~ '^[A-Za-z0-9]{6}$'
  or (invite_code = upper(invite_code) and char_length(invite_code) between 6 and 12)
);

create or replace function public.join_room_by_code(requested_code text)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  target_room public.rooms;
  current_members integer;
  normalized_code text := trim(requested_code);
begin
  if auth.uid() is null then
    raise exception 'Authentication required' using errcode = '42501';
  end if;

  if normalized_code ~* '^KING-[A-Z0-9]{3}$' then
    normalized_code := upper(normalized_code);
  elsif normalized_code ~* '^[a-z0-9]{4}$' then
    normalized_code := lower(normalized_code);
  end if;

  select *
  into target_room
  from public.rooms
  where invite_code = normalized_code
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

