-- Co Pilot Collections Manager - Bolt Database Schema
-- Run this in Bolt Database -> Tables -> Query.
-- This creates real database tables for accounts, notes, activity logs, and roles.

create extension if not exists pgcrypto;

create table if not exists app_profiles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid unique,
  email text unique not null,
  role text not null default 'employee' check (role in ('admin', 'employee')),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists accounts (
  id uuid primary key default gen_random_uuid(),

  portfolio text,
  account_description text,
  client_account_number text,
  source_account_id text,
  account_number text,

  first_name text,
  middle_name text,
  last_name text,
  full_name text,

  ssn text,
  dob text,

  address text,
  address2 text,
  city text,
  state text,
  zip text,

  employer text,
  email text,

  original_creditor text,
  type_of_debt text,

  original_balance numeric,
  principal numeric,
  current_balance numeric,

  open_date text,
  date_account_opened text,
  delinquency_date text,
  charge_off_date text,
  orig_last_pmt_date text,
  last_payment_date text,
  last_payment_amount numeric,

  bank_routing_number text,
  bank_account_number text,

  phone1 text,
  phone2 text,
  phone3 text,
  phone4 text,
  phone5 text,
  phone6 text,

  status text default 'New',
  disposition text,
  last_contact_number text,

  assigned_to uuid,
  created_by_email text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create index if not exists idx_accounts_status on accounts(status);
create index if not exists idx_accounts_portfolio on accounts(portfolio);
create index if not exists idx_accounts_account_number on accounts(account_number);
create index if not exists idx_accounts_full_name on accounts(full_name);

create table if not exists account_notes (
  id uuid primary key default gen_random_uuid(),
  account_id uuid references accounts(id) on delete cascade,
  note text not null,
  created_by uuid,
  created_by_email text,
  created_at timestamptz default now()
);

create index if not exists idx_account_notes_account on account_notes(account_id);

create table if not exists activity_logs (
  id uuid primary key default gen_random_uuid(),
  account_id uuid references accounts(id) on delete cascade,
  action_type text not null,
  action_text text,
  phone_number text,
  old_status text,
  new_status text,
  created_by uuid,
  created_by_email text,
  created_at timestamptz default now()
);

create index if not exists idx_activity_logs_account on activity_logs(account_id);

-- Optional: seed admin profile. The app will also auto-create this when the admin logs in.
insert into app_profiles (email, role)
values ('afinch2678@gmail.com', 'admin')
on conflict (email) do update set role = 'admin', updated_at = now();
