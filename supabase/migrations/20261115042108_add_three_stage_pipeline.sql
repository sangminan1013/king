-- Original opinions remain immutable in opinions.content. Each successful
-- preprocessing attempt has its own snapshot, including failed later stages.
create table public.decision_runs (
  id uuid primary key default gen_random_uuid(),
  room_id uuid not null references public.rooms(id) on delete cascade,
  original_topic text not null,
  source_opinions jsonb not null check (jsonb_typeof(source_opinions) = 'array'),
  normalized_input jsonb not null check (jsonb_typeof(normalized_input) = 'object'),
  decision jsonb check (decision is null or jsonb_typeof(decision) = 'object'),
  preprocessing_model text not null,
  decision_model text not null,
  narration_model text not null,
  prompt_version text not null,
  created_at timestamptz not null default now(),
  unique (room_id, id)
);
create index decision_runs_room_idx on public.decision_runs(room_id);
alter table public.decision_runs enable row level security;
-- Internal audit records: readable/writable only by the server/service role.
revoke all on public.decision_runs from public, anon, authenticated;
grant select, insert, update on public.decision_runs to service_role;

alter table public.verdicts
  add column pipeline_run_id uuid,
  add column selected_participant integer check (selected_participant between 1 and 12),
  add column selected_opinion text,
  add constraint verdict_pipeline_room_fk foreign key (room_id, pipeline_run_id)
    references public.decision_runs(room_id, id),
  add constraint verdict_selection_complete check (
    (pipeline_run_id is null and selected_participant is null and selected_opinion is null)
    or (pipeline_run_id is not null and selected_participant is not null
      and selected_opinion is not null and length(trim(selected_opinion)) > 0)
  );
