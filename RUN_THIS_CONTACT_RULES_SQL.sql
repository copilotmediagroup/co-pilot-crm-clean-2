
-- CONTACT RULES + CALL LIMITS
-- Adds account-level contact restrictions and internal call warning limits.

alter table public.accounts add column if not exists do_not_call boolean default false;
alter table public.accounts add column if not exists cease_contact boolean default false;
alter table public.accounts add column if not exists attorney_represented boolean default false;
alter table public.accounts add column if not exists wrong_number boolean default false;
alter table public.accounts add column if not exists preferred_contact_method text default 'Phone';
alter table public.accounts add column if not exists best_time_to_call text;
alter table public.accounts add column if not exists contact_timezone text;
alter table public.accounts add column if not exists contact_notes text;
alter table public.accounts add column if not exists call_limit_daily integer default 3;
alter table public.accounts add column if not exists call_limit_weekly integer default 7;

create index if not exists idx_accounts_do_not_call on public.accounts(do_not_call);
create index if not exists idx_accounts_cease_contact on public.accounts(cease_contact);
create index if not exists idx_accounts_attorney_represented on public.accounts(attorney_represented);
create index if not exists idx_accounts_wrong_number on public.accounts(wrong_number);
create index if not exists idx_call_results_account_created on public.call_results(account_id, created_at desc);
