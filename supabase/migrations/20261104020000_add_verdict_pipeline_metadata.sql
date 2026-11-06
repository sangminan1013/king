alter table public.verdicts
add column model text not null default 'openai/gpt-4o-mini',
add column prompt_version text not null default 'king-verdict-v2';
