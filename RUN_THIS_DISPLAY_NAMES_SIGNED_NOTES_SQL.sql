-- DISPLAY NAMES + SIGNED NOTES + ADMIN NOTE DELETE
-- Run this in the LIVE Supabase SQL Editor.

alter table public.app_users
  add column if not exists display_name text,
  add column if not exists full_name text;

alter table public.account_notes
  add column if not exists created_by_name text,
  add column if not exists digital_signature text;

create index if not exists idx_app_users_display_name on public.app_users(lower(coalesce(display_name, full_name, email)));
create index if not exists idx_account_notes_created_by_name on public.account_notes(lower(coalesce(created_by_name, created_by_email)));

drop policy if exists app_users_update_own_display_name on public.app_users;
create policy app_users_update_own_display_name
on public.app_users
for update
to authenticated
using (lower(email)=lower(coalesce(auth.jwt()->>'email','')))
with check (lower(email)=lower(coalesce(auth.jwt()->>'email','')));

drop policy if exists account_notes_delete_admin_signed_notes on public.account_notes;
create policy account_notes_delete_admin_signed_notes
on public.account_notes
for delete
to authenticated
using (
  lower(coalesce(auth.jwt()->>'email','')) = lower('afinch2678@gmail.com')
  or exists (
    select 1 from public.app_users u
    where lower(u.email)=lower(coalesce(auth.jwt()->>'email',''))
      and lower(coalesce(u.role,''))='admin'
      and coalesce(u.is_active,true)=true
      and (coalesce(u.is_approved,true)=true or lower(coalesce(u.approval_status,''))='approved')
  )
);

drop policy if exists app_users_update_admin_display_names on public.app_users;
create policy app_users_update_admin_display_names
on public.app_users
for update
to authenticated
using (
  lower(coalesce(auth.jwt()->>'email','')) = lower('afinch2678@gmail.com')
  or exists (
    select 1 from public.app_users u
    where lower(u.email)=lower(coalesce(auth.jwt()->>'email',''))
      and lower(coalesce(u.role,''))='admin'
      and coalesce(u.is_active,true)=true
      and (coalesce(u.is_approved,true)=true or lower(coalesce(u.approval_status,''))='approved')
  )
)
with check (true);

notify pgrst, 'reload schema';

select email, role, display_name, full_name, approval_status, is_approved, is_active
from public.app_users
order by email;
