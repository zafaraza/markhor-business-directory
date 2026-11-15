-- Markhor Business Directory: Supabase schema
-- Run this entire script in Supabase > SQL Editor.
create extension if not exists pgcrypto;

create table if not exists public.businesses (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 2 and 100),
  category text not null,
  city text not null,
  phone text not null,
  website text,
  email text,
  address text,
  description text not null check (char_length(description) <= 500),
  requested_sponsorship boolean not null default false,
  featured boolean not null default false,
  sponsored boolean not null default false,
  status text not null default 'pending' check (status in ('pending','approved','rejected')),
  created_at timestamptz not null default now()
);

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.businesses enable row level security;
alter table public.admin_users enable row level security;

-- Public can see approved listings only.
drop policy if exists "Public can view approved businesses" on public.businesses;
create policy "Public can view approved businesses"
on public.businesses for select to anon, authenticated
using (status = 'approved');

-- Anyone can submit a business for review. Submissions remain pending.
drop policy if exists "Public can submit businesses" on public.businesses;
create policy "Public can submit businesses"
on public.businesses for insert to anon, authenticated
with check (status = 'pending' and featured = false and sponsored = false);

-- Admin membership is checked against the signed-in Supabase user.
create or replace function public.is_markhor_admin()
returns boolean language sql stable security definer
set search_path = public
as $$
  select exists (
    select 1 from public.admin_users
    where user_id = auth.uid()
  );
$$;

drop policy if exists "Admins can view all businesses" on public.businesses;
create policy "Admins can view all businesses"
on public.businesses for select to authenticated
using (public.is_markhor_admin());

drop policy if exists "Admins can update businesses" on public.businesses;
create policy "Admins can update businesses"
on public.businesses for update to authenticated
using (public.is_markhor_admin())
with check (public.is_markhor_admin());

drop policy if exists "Admins can manage admin list" on public.admin_users;
create policy "Admins can manage admin list"
on public.admin_users for select to authenticated
using (user_id = auth.uid());

grant select, insert on public.businesses to anon, authenticated;
grant update, select on public.businesses to authenticated;
grant select on public.admin_users to authenticated;
grant execute on function public.is_markhor_admin() to authenticated;

-- ADMIN SETUP:
-- 1) In Supabase Authentication > Users, create your admin user.
-- 2) Copy that user's UUID.
-- 3) Run this statement after replacing the UUID:
-- insert into public.admin_users (user_id) values ('YOUR-AUTH-USER-UUID');
--
-- Keep public signups disabled if you only want manually-created admin accounts.
