alter table public.rooms
  add column king_personality text not null default 'wise'
  check (king_personality in ('wise', 'iron', 'festive', 'sentimental', 'tyrant'));

alter table public.decision_runs
  add column king_personality text not null default 'wise'
  check (king_personality in ('wise', 'iron', 'festive', 'sentimental', 'tyrant'));

-- Preserve the exact criteria and voice used even if a later app version changes them.
alter table public.decision_runs add column personality_snapshot jsonb;
