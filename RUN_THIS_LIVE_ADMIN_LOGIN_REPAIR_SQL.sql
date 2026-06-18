
-- LIVE ADMIN LOGIN REPAIR
-- Run in LIVE Supabase SQL Editor only.

update public.app_users
set role='admin',
    approval_status='approved',
    is_approved=true,
    is_active=true,
    updated_at=now(),
    last_seen_at=coalesce(last_seen_at, now())
where lower(email)=lower('afinch2678@gmail.com');

insert into public.app_users
  (email, role, approval_status, is_approved, is_active, created_at, updated_at, last_seen_at)
select
  'afinch2678@gmail.com', 'admin', 'approved', true, true, now(), now(), now()
where not exists (
  select 1 from public.app_users where lower(email)=lower('afinch2678@gmail.com')
);

notify pgrst, 'reload schema';
