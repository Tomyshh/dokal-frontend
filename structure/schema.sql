-- Supabase schema for Dokal (mobile patient + CRM praticien)
-- Target: Postgres (Supabase) - public schema + auth.users
--
-- Notes:
-- - This file is intended to be executed in a fresh Supabase project.
-- - If you already have tables, review before applying.
-- - Some extensions may already exist on Supabase; IF NOT EXISTS keeps it safe.

begin;

-- ---------------------------------------------------------------------------
-- Extensions
-- ---------------------------------------------------------------------------
create extension if not exists pgcrypto;
create extension if not exists "uuid-ossp";
-- Optional (recommended for geo search). Enable if you want PostGIS.
-- create extension if not exists postgis;

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- ---------------------------------------------------------------------------
-- ENUM types (idempotent)
-- ---------------------------------------------------------------------------
do $$
begin
  if not exists (select 1 from pg_type t join pg_namespace n on n.oid=t.typnamespace where n.nspname='public' and t.typname='user_role') then
    create type public.user_role as enum ('patient','practitioner','admin');
  end if;
  if not exists (select 1 from pg_type t join pg_namespace n on n.oid=t.typnamespace where n.nspname='public' and t.typname='sex_type') then
    create type public.sex_type as enum ('male','female','other');
  end if;
  if not exists (select 1 from pg_type t join pg_namespace n on n.oid=t.typnamespace where n.nspname='public' and t.typname='relation_type') then
    create type public.relation_type as enum ('child','parent','spouse','sibling','other');
  end if;
  if not exists (select 1 from pg_type t join pg_namespace n on n.oid=t.typnamespace where n.nspname='public' and t.typname='appointment_status') then
    create type public.appointment_status as enum (
      'pending',
      'confirmed',
      'cancelled_by_patient',
      'cancelled_by_practitioner',
      'completed',
      'no_show'
    );
  end if;
  if not exists (select 1 from pg_type t join pg_namespace n on n.oid=t.typnamespace where n.nspname='public' and t.typname='message_type') then
    create type public.message_type as enum ('text','image','file','system');
  end if;
  if not exists (select 1 from pg_type t join pg_namespace n on n.oid=t.typnamespace where n.nspname='public' and t.typname='notification_type') then
    create type public.notification_type as enum (
      'appointment_request',
      'appointment_confirmed',
      'appointment_cancelled',
      'appointment_reminder',
      'new_message',
      'review_received'
    );
  end if;
end $$;

-- ---------------------------------------------------------------------------
-- Core tables
-- ---------------------------------------------------------------------------

-- Profiles: extension of auth.users
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  first_name text,
  last_name text,
  email text,
  phone text,
  date_of_birth date,
  sex public.sex_type,
  city text,
  avatar_url text,
  role public.user_role not null default 'patient',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists profiles_role_idx on public.profiles(role);

create trigger profiles_set_updated_at
before update on public.profiles
for each row execute function public.set_updated_at();

-- Default settings per user
create table if not exists public.user_settings (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  notifications_enabled boolean not null default true,
  reminders_enabled boolean not null default true,
  locale text not null default 'fr',
  updated_at timestamptz not null default now()
);

create trigger user_settings_set_updated_at
before update on public.user_settings
for each row execute function public.set_updated_at();

-- Specialties catalog
create table if not exists public.specialties (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  name_he text,
  name_fr text,
  icon_url text,
  created_at timestamptz not null default now()
);

create unique index if not exists specialties_name_unique on public.specialties(lower(name));

-- Practitioners (doctors)
create table if not exists public.practitioners (
  id uuid primary key references public.profiles(id) on delete cascade,
  specialty_id uuid references public.specialties(id) on delete set null,
  address_line text,
  zip_code text,
  city text,
  latitude double precision,
  longitude double precision,
  about text,
  sector text, -- Kupat Holim: Clalit/Maccabi/Meuhedet/Leumit (enforced by CHECK)
  phone text,
  email text,
  languages text[],
  education text,
  years_of_experience integer,
  consultation_duration_minutes integer not null default 30,
  is_accepting_new_patients boolean not null default true,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint practitioners_sector_check
    check (sector is null or sector in ('Clalit','Maccabi','Meuhedet','Leumit'))
);

create index if not exists practitioners_specialty_active_city_idx
  on public.practitioners(specialty_id, is_active, city);
create index if not exists practitioners_active_idx
  on public.practitioners(is_active);
create index if not exists practitioners_city_idx
  on public.practitioners(city);

create trigger practitioners_set_updated_at
before update on public.practitioners
for each row execute function public.set_updated_at();

-- Weekly schedule (recurring)
create table if not exists public.practitioner_weekly_schedule (
  id uuid primary key default gen_random_uuid(),
  practitioner_id uuid not null references public.practitioners(id) on delete cascade,
  day_of_week integer not null,
  start_time time not null,
  end_time time not null,
  slot_duration_minutes integer not null default 30,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint weekly_schedule_day_check check (day_of_week between 0 and 6),
  constraint weekly_schedule_time_check check (start_time < end_time),
  constraint weekly_schedule_slot_check check (slot_duration_minutes between 5 and 240)
);

create index if not exists practitioner_weekly_schedule_practitioner_day_idx
  on public.practitioner_weekly_schedule(practitioner_id, day_of_week)
  where is_active;

create trigger practitioner_weekly_schedule_set_updated_at
before update on public.practitioner_weekly_schedule
for each row execute function public.set_updated_at();

-- Schedule overrides (exceptions)
create table if not exists public.practitioner_schedule_overrides (
  id uuid primary key default gen_random_uuid(),
  practitioner_id uuid not null references public.practitioners(id) on delete cascade,
  date date not null,
  is_available boolean not null default false,
  start_time time,
  end_time time,
  reason text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint schedule_overrides_time_check check (
    (is_available = false and start_time is null and end_time is null)
    or
    (is_available = true and start_time is not null and end_time is not null and start_time < end_time)
  )
);

create unique index if not exists practitioner_schedule_overrides_unique
  on public.practitioner_schedule_overrides(practitioner_id, date);

create trigger practitioner_schedule_overrides_set_updated_at
before update on public.practitioner_schedule_overrides
for each row execute function public.set_updated_at();

-- Appointment reasons (global or per practitioner)
create table if not exists public.appointment_reasons (
  id uuid primary key default gen_random_uuid(),
  practitioner_id uuid references public.practitioners(id) on delete cascade,
  label text not null,
  label_he text,
  label_fr text,
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create index if not exists appointment_reasons_practitioner_idx
  on public.appointment_reasons(practitioner_id, sort_order)
  where is_active;

-- Relatives (family members)
create table if not exists public.relatives (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  first_name text not null,
  last_name text not null,
  relation public.relation_type not null,
  date_of_birth date,
  created_at timestamptz not null default now()
);

create index if not exists relatives_user_idx on public.relatives(user_id);

-- Health profile
create table if not exists public.health_profiles (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  teudat_zehut_encrypted bytea,
  date_of_birth date,
  sex public.sex_type,
  blood_type text,
  kupat_holim text,
  kupat_member_id text,
  family_doctor_name text,
  emergency_contact_name text,
  emergency_contact_phone text,
  updated_at timestamptz not null default now()
);

create trigger health_profiles_set_updated_at
before update on public.health_profiles
for each row execute function public.set_updated_at();

-- Health lists (separate tables for filtering + future fields)
create table if not exists public.health_conditions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  name text not null,
  severity text,
  diagnosed_on date,
  notes text,
  created_at timestamptz not null default now()
);
create index if not exists health_conditions_user_idx on public.health_conditions(user_id);

create table if not exists public.health_medications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  name text not null,
  dosage text,
  frequency text,
  started_on date,
  ended_on date,
  notes text,
  created_at timestamptz not null default now()
);
create index if not exists health_medications_user_idx on public.health_medications(user_id);

create table if not exists public.health_allergies (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  name text not null,
  reaction text,
  severity text,
  notes text,
  created_at timestamptz not null default now()
);
create index if not exists health_allergies_user_idx on public.health_allergies(user_id);

create table if not exists public.health_vaccinations (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  name text not null,
  vaccinated_on date,
  dose text,
  notes text,
  created_at timestamptz not null default now()
);
create index if not exists health_vaccinations_user_idx on public.health_vaccinations(user_id);

-- Appointment instructions per practitioner
create table if not exists public.appointment_instructions (
  id uuid primary key default gen_random_uuid(),
  practitioner_id uuid not null references public.practitioners(id) on delete cascade,
  title text not null,
  content text not null,
  is_active boolean not null default true,
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);

create index if not exists appointment_instructions_practitioner_idx
  on public.appointment_instructions(practitioner_id, sort_order)
  where is_active;

-- Appointments (core)
create table if not exists public.appointments (
  id uuid primary key default gen_random_uuid(),
  patient_id uuid not null references public.profiles(id) on delete restrict,
  practitioner_id uuid not null references public.practitioners(id) on delete restrict,
  relative_id uuid references public.relatives(id) on delete set null,
  reason_id uuid references public.appointment_reasons(id) on delete set null,
  appointment_date date not null,
  start_time time not null,
  end_time time not null,
  status public.appointment_status not null default 'pending',
  patient_address_line text,
  patient_zip_code text,
  patient_city text,
  visited_before boolean not null default false,
  practitioner_notes text,
  cancellation_reason text,
  confirmed_at timestamptz,
  cancelled_at timestamptz,
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint appointments_time_check check (start_time < end_time)
);

create index if not exists appointments_practitioner_date_status_idx
  on public.appointments(practitioner_id, appointment_date, status);
create index if not exists appointments_patient_status_idx
  on public.appointments(patient_id, status);
create index if not exists appointments_patient_date_idx
  on public.appointments(patient_id, appointment_date);

create trigger appointments_set_updated_at
before update on public.appointments
for each row execute function public.set_updated_at();

-- Questionnaire linked to appointment
create table if not exists public.appointment_questionnaires (
  id uuid primary key default gen_random_uuid(),
  appointment_id uuid not null references public.appointments(id) on delete cascade,
  questions jsonb not null default '{}'::jsonb,
  answers jsonb,
  completed_at timestamptz,
  created_at timestamptz not null default now()
);

create unique index if not exists appointment_questionnaires_appointment_unique
  on public.appointment_questionnaires(appointment_id);

-- Conversations between patient and practitioner (optionally tied to appointment)
create table if not exists public.conversations (
  id uuid primary key default gen_random_uuid(),
  patient_id uuid not null references public.profiles(id) on delete cascade,
  practitioner_id uuid not null references public.practitioners(id) on delete cascade,
  appointment_id uuid references public.appointments(id) on delete set null,
  last_message_at timestamptz,
  created_at timestamptz not null default now()
);

create index if not exists conversations_patient_idx on public.conversations(patient_id, last_message_at desc nulls last);
create index if not exists conversations_practitioner_idx on public.conversations(practitioner_id, last_message_at desc nulls last);

-- One “general” conversation per pair (appointment_id is null)
create unique index if not exists conversations_unique_general
  on public.conversations(patient_id, practitioner_id)
  where appointment_id is null;

-- At most one conversation per appointment
create unique index if not exists conversations_unique_per_appointment
  on public.conversations(appointment_id)
  where appointment_id is not null;

-- Messages
create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.conversations(id) on delete cascade,
  sender_id uuid not null references public.profiles(id) on delete cascade,
  recipient_id uuid not null references public.profiles(id) on delete cascade,
  content text not null,
  message_type public.message_type not null default 'text',
  is_read boolean not null default false,
  read_at timestamptz,
  created_at timestamptz not null default now(),
  constraint messages_sender_recipient_check check (sender_id <> recipient_id)
);

create index if not exists messages_conversation_created_idx on public.messages(conversation_id, created_at);
create index if not exists messages_recipient_unread_idx on public.messages(recipient_id, is_read, created_at) where is_read = false;

-- Payment methods (cards - tokenized by provider)
create table if not exists public.payment_methods (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  brand text not null,
  last4 text not null,
  expiry_month integer not null,
  expiry_year integer not null,
  is_default boolean not null default false,
  stripe_payment_method_id text,
  created_at timestamptz not null default now(),
  constraint payment_methods_last4_check check (char_length(last4)=4),
  constraint payment_methods_expiry_month_check check (expiry_month between 1 and 12),
  constraint payment_methods_expiry_year_check check (expiry_year between 2000 and 2100)
);

create index if not exists payment_methods_user_idx on public.payment_methods(user_id);
create unique index if not exists payment_methods_default_unique on public.payment_methods(user_id) where is_default;

-- Reviews (one per appointment)
create table if not exists public.reviews (
  id uuid primary key default gen_random_uuid(),
  appointment_id uuid not null unique references public.appointments(id) on delete cascade,
  patient_id uuid not null references public.profiles(id) on delete cascade,
  practitioner_id uuid not null references public.practitioners(id) on delete cascade,
  rating integer not null,
  comment text,
  practitioner_reply text,
  created_at timestamptz not null default now(),
  constraint reviews_rating_check check (rating between 1 and 5)
);

create index if not exists reviews_practitioner_idx on public.reviews(practitioner_id, created_at desc);

-- Notifications
create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  type public.notification_type not null,
  title text not null,
  body text not null,
  data jsonb not null default '{}'::jsonb,
  is_read boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists notifications_user_read_created_idx
  on public.notifications(user_id, is_read, created_at desc);

-- Audit log (CRM actions)
create table if not exists public.audit_log (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid not null references public.profiles(id) on delete set null,
  action text not null,
  entity_type text not null,
  entity_id uuid,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index if not exists audit_log_actor_created_idx on public.audit_log(actor_id, created_at desc);
create index if not exists audit_log_entity_idx on public.audit_log(entity_type, entity_id);

-- ---------------------------------------------------------------------------
-- Triggers: keep conversation last_message_at, create notifications on events
-- ---------------------------------------------------------------------------

create or replace function public.tg_messages_after_insert()
returns trigger
language plpgsql
as $$
begin
  update public.conversations
  set last_message_at = new.created_at
  where id = new.conversation_id;

  insert into public.notifications(user_id, type, title, body, data)
  values (
    new.recipient_id,
    'new_message'::public.notification_type,
    'Nouveau message',
    left(new.content, 140),
    jsonb_build_object('conversation_id', new.conversation_id, 'message_id', new.id)
  );

  return new;
end;
$$;

drop trigger if exists messages_after_insert on public.messages;
create trigger messages_after_insert
after insert on public.messages
for each row execute function public.tg_messages_after_insert();

create or replace function public.tg_appointments_after_insert()
returns trigger
language plpgsql
as $$
begin
  -- Notify practitioner: new request
  insert into public.notifications(user_id, type, title, body, data)
  values (
    new.practitioner_id,
    'appointment_request'::public.notification_type,
    'Nouvelle demande de rendez-vous',
    'Vous avez une nouvelle demande de rendez-vous.',
    jsonb_build_object('appointment_id', new.id)
  );

  -- Ensure a general conversation exists for this patient/practitioner pair
  insert into public.conversations(patient_id, practitioner_id, appointment_id, last_message_at)
  values (new.patient_id, new.practitioner_id, null, null)
  on conflict do nothing;

  return new;
end;
$$;

drop trigger if exists appointments_after_insert on public.appointments;
create trigger appointments_after_insert
after insert on public.appointments
for each row execute function public.tg_appointments_after_insert();

create or replace function public.tg_appointments_after_update()
returns trigger
language plpgsql
as $$
declare
  notif_type public.notification_type;
  notif_title text;
  notif_body text;
begin
  if new.status is distinct from old.status then
    if new.status = 'confirmed'::public.appointment_status then
      notif_type := 'appointment_confirmed'::public.notification_type;
      notif_title := 'Rendez-vous confirmé';
      notif_body := 'Votre rendez-vous a été confirmé.';
      new.confirmed_at := coalesce(new.confirmed_at, now());
    elsif new.status in ('cancelled_by_patient'::public.appointment_status, 'cancelled_by_practitioner'::public.appointment_status) then
      notif_type := 'appointment_cancelled'::public.notification_type;
      notif_title := 'Rendez-vous annulé';
      notif_body := 'Votre rendez-vous a été annulé.';
      new.cancelled_at := coalesce(new.cancelled_at, now());
    elsif new.status = 'completed'::public.appointment_status then
      new.completed_at := coalesce(new.completed_at, now());
    end if;

    if notif_type is not null then
      -- notify both sides
      insert into public.notifications(user_id, type, title, body, data)
      values
        (new.patient_id, notif_type, notif_title, notif_body, jsonb_build_object('appointment_id', new.id)),
        (new.practitioner_id, notif_type, notif_title, notif_body, jsonb_build_object('appointment_id', new.id));
    end if;
  end if;

  return new;
end;
$$;

drop trigger if exists appointments_after_update on public.appointments;
create trigger appointments_after_update
before update on public.appointments
for each row execute function public.tg_appointments_after_update();

-- ---------------------------------------------------------------------------
-- Auth integration: create profile + settings on sign-up
-- ---------------------------------------------------------------------------

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, first_name, last_name, email, role)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'first_name', null),
    coalesce(new.raw_user_meta_data->>'last_name', null),
    new.email,
    'patient'::public.user_role
  )
  on conflict (id) do nothing;

  insert into public.user_settings (user_id)
  values (new.id)
  on conflict (user_id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

-- ---------------------------------------------------------------------------
-- Authorization helper functions (used in RLS)
-- ---------------------------------------------------------------------------
create or replace function public.is_admin()
returns boolean
language sql
stable
as $$
  select exists(
    select 1
    from public.profiles p
    where p.id = auth.uid()
      and p.role = 'admin'::public.user_role
  );
$$;

create or replace function public.is_practitioner()
returns boolean
language sql
stable
as $$
  select exists(
    select 1
    from public.profiles p
    where p.id = auth.uid()
      and p.role = 'practitioner'::public.user_role
  );
$$;

create or replace function public.can_practitioner_access_patient(patient uuid)
returns boolean
language sql
stable
as $$
  select exists(
    select 1
    from public.appointments a
    where a.practitioner_id = auth.uid()
      and a.patient_id = patient
  );
$$;

-- ---------------------------------------------------------------------------
-- RLS (Row Level Security)
-- ---------------------------------------------------------------------------

-- profiles
alter table public.profiles enable row level security;
drop policy if exists "profiles_select_own_or_admin" on public.profiles;
create policy "profiles_select_own_or_admin"
on public.profiles
for select
to authenticated
using (id = auth.uid() or public.is_admin());

drop policy if exists "profiles_update_own_or_admin" on public.profiles;
create policy "profiles_update_own_or_admin"
on public.profiles
for update
to authenticated
using (id = auth.uid() or public.is_admin())
with check (id = auth.uid() or public.is_admin());

-- user_settings
alter table public.user_settings enable row level security;
drop policy if exists "user_settings_select_own" on public.user_settings;
create policy "user_settings_select_own"
on public.user_settings
for select
to authenticated
using (user_id = auth.uid() or public.is_admin());

drop policy if exists "user_settings_upsert_own" on public.user_settings;
create policy "user_settings_upsert_own"
on public.user_settings
for all
to authenticated
using (user_id = auth.uid() or public.is_admin())
with check (user_id = auth.uid() or public.is_admin());

-- specialties (readable by everyone)
alter table public.specialties enable row level security;
drop policy if exists "specialties_select_all" on public.specialties;
create policy "specialties_select_all"
on public.specialties
for select
to anon, authenticated
using (true);

-- practitioners (read public, write own practitioner)
alter table public.practitioners enable row level security;
drop policy if exists "practitioners_select_active" on public.practitioners;
create policy "practitioners_select_active"
on public.practitioners
for select
to anon, authenticated
using (is_active = true or id = auth.uid() or public.is_admin());

drop policy if exists "practitioners_upsert_own" on public.practitioners;
create policy "practitioners_upsert_own"
on public.practitioners
for all
to authenticated
using ((id = auth.uid() and public.is_practitioner()) or public.is_admin())
with check ((id = auth.uid() and public.is_practitioner()) or public.is_admin());

-- schedules (read for active practitioners, write own)
alter table public.practitioner_weekly_schedule enable row level security;
drop policy if exists "weekly_schedule_select_active" on public.practitioner_weekly_schedule;
create policy "weekly_schedule_select_active"
on public.practitioner_weekly_schedule
for select
to anon, authenticated
using (
  exists(select 1 from public.practitioners pr where pr.id = practitioner_id and pr.is_active = true)
  or practitioner_id = auth.uid()
  or public.is_admin()
);

drop policy if exists "weekly_schedule_write_own" on public.practitioner_weekly_schedule;
create policy "weekly_schedule_write_own"
on public.practitioner_weekly_schedule
for all
to authenticated
using ((practitioner_id = auth.uid() and public.is_practitioner()) or public.is_admin())
with check ((practitioner_id = auth.uid() and public.is_practitioner()) or public.is_admin());

alter table public.practitioner_schedule_overrides enable row level security;
drop policy if exists "schedule_overrides_select_active" on public.practitioner_schedule_overrides;
create policy "schedule_overrides_select_active"
on public.practitioner_schedule_overrides
for select
to anon, authenticated
using (
  exists(select 1 from public.practitioners pr where pr.id = practitioner_id and pr.is_active = true)
  or practitioner_id = auth.uid()
  or public.is_admin()
);

drop policy if exists "schedule_overrides_write_own" on public.practitioner_schedule_overrides;
create policy "schedule_overrides_write_own"
on public.practitioner_schedule_overrides
for all
to authenticated
using ((practitioner_id = auth.uid() and public.is_practitioner()) or public.is_admin())
with check ((practitioner_id = auth.uid() and public.is_practitioner()) or public.is_admin());

-- appointment reasons / instructions (read for everyone, write by owning practitioner)
alter table public.appointment_reasons enable row level security;
drop policy if exists "appointment_reasons_select_active" on public.appointment_reasons;
create policy "appointment_reasons_select_active"
on public.appointment_reasons
for select
to anon, authenticated
using (is_active = true);

drop policy if exists "appointment_reasons_write_own" on public.appointment_reasons;
create policy "appointment_reasons_write_own"
on public.appointment_reasons
for all
to authenticated
using ((practitioner_id = auth.uid() and public.is_practitioner()) or public.is_admin())
with check ((practitioner_id = auth.uid() and public.is_practitioner()) or public.is_admin());

alter table public.appointment_instructions enable row level security;
drop policy if exists "appointment_instructions_select_active" on public.appointment_instructions;
create policy "appointment_instructions_select_active"
on public.appointment_instructions
for select
to anon, authenticated
using (is_active = true);

drop policy if exists "appointment_instructions_write_own" on public.appointment_instructions;
create policy "appointment_instructions_write_own"
on public.appointment_instructions
for all
to authenticated
using ((practitioner_id = auth.uid() and public.is_practitioner()) or public.is_admin())
with check ((practitioner_id = auth.uid() and public.is_practitioner()) or public.is_admin());

-- relatives
alter table public.relatives enable row level security;
drop policy if exists "relatives_crud_own" on public.relatives;
create policy "relatives_crud_own"
on public.relatives
for all
to authenticated
using (user_id = auth.uid() or public.is_admin())
with check (user_id = auth.uid() or public.is_admin());

-- health profile + lists
alter table public.health_profiles enable row level security;
drop policy if exists "health_profiles_select_own_or_practitioner_with_appointment" on public.health_profiles;
create policy "health_profiles_select_own_or_practitioner_with_appointment"
on public.health_profiles
for select
to authenticated
using (
  user_id = auth.uid()
  or public.is_admin()
  or public.can_practitioner_access_patient(user_id)
);

drop policy if exists "health_profiles_upsert_own" on public.health_profiles;
create policy "health_profiles_upsert_own"
on public.health_profiles
for all
to authenticated
using (user_id = auth.uid() or public.is_admin())
with check (user_id = auth.uid() or public.is_admin());

alter table public.health_conditions enable row level security;
drop policy if exists "health_conditions_select_own_or_practitioner_with_appointment" on public.health_conditions;
create policy "health_conditions_select_own_or_practitioner_with_appointment"
on public.health_conditions
for select
to authenticated
using (user_id = auth.uid() or public.is_admin() or public.can_practitioner_access_patient(user_id));

drop policy if exists "health_conditions_crud_own" on public.health_conditions;
create policy "health_conditions_crud_own"
on public.health_conditions
for all
to authenticated
using (user_id = auth.uid() or public.is_admin())
with check (user_id = auth.uid() or public.is_admin());

alter table public.health_medications enable row level security;
drop policy if exists "health_medications_select_own_or_practitioner_with_appointment" on public.health_medications;
create policy "health_medications_select_own_or_practitioner_with_appointment"
on public.health_medications
for select
to authenticated
using (user_id = auth.uid() or public.is_admin() or public.can_practitioner_access_patient(user_id));

drop policy if exists "health_medications_crud_own" on public.health_medications;
create policy "health_medications_crud_own"
on public.health_medications
for all
to authenticated
using (user_id = auth.uid() or public.is_admin())
with check (user_id = auth.uid() or public.is_admin());

alter table public.health_allergies enable row level security;
drop policy if exists "health_allergies_select_own_or_practitioner_with_appointment" on public.health_allergies;
create policy "health_allergies_select_own_or_practitioner_with_appointment"
on public.health_allergies
for select
to authenticated
using (user_id = auth.uid() or public.is_admin() or public.can_practitioner_access_patient(user_id));

drop policy if exists "health_allergies_crud_own" on public.health_allergies;
create policy "health_allergies_crud_own"
on public.health_allergies
for all
to authenticated
using (user_id = auth.uid() or public.is_admin())
with check (user_id = auth.uid() or public.is_admin());

alter table public.health_vaccinations enable row level security;
drop policy if exists "health_vaccinations_select_own_or_practitioner_with_appointment" on public.health_vaccinations;
create policy "health_vaccinations_select_own_or_practitioner_with_appointment"
on public.health_vaccinations
for select
to authenticated
using (user_id = auth.uid() or public.is_admin() or public.can_practitioner_access_patient(user_id));

drop policy if exists "health_vaccinations_crud_own" on public.health_vaccinations;
create policy "health_vaccinations_crud_own"
on public.health_vaccinations
for all
to authenticated
using (user_id = auth.uid() or public.is_admin())
with check (user_id = auth.uid() or public.is_admin());

-- appointments
alter table public.appointments enable row level security;
drop policy if exists "appointments_select_participants" on public.appointments;
create policy "appointments_select_participants"
on public.appointments
for select
to authenticated
using (
  patient_id = auth.uid()
  or practitioner_id = auth.uid()
  or public.is_admin()
);

drop policy if exists "appointments_insert_patient" on public.appointments;
create policy "appointments_insert_patient"
on public.appointments
for insert
to authenticated
with check (
  patient_id = auth.uid()
  or public.is_admin()
);

drop policy if exists "appointments_update_participants" on public.appointments;
create policy "appointments_update_participants"
on public.appointments
for update
to authenticated
using (
  patient_id = auth.uid()
  or practitioner_id = auth.uid()
  or public.is_admin()
)
with check (
  patient_id = auth.uid()
  or practitioner_id = auth.uid()
  or public.is_admin()
);

-- appointment questionnaires
alter table public.appointment_questionnaires enable row level security;
drop policy if exists "appointment_questionnaires_select_participants" on public.appointment_questionnaires;
create policy "appointment_questionnaires_select_participants"
on public.appointment_questionnaires
for select
to authenticated
using (
  exists(
    select 1
    from public.appointments a
    where a.id = appointment_id
      and (a.patient_id = auth.uid() or a.practitioner_id = auth.uid() or public.is_admin())
  )
);

drop policy if exists "appointment_questionnaires_write_patient_or_practitioner" on public.appointment_questionnaires;
create policy "appointment_questionnaires_write_patient_or_practitioner"
on public.appointment_questionnaires
for all
to authenticated
using (
  exists(
    select 1
    from public.appointments a
    where a.id = appointment_id
      and (a.patient_id = auth.uid() or a.practitioner_id = auth.uid() or public.is_admin())
  )
)
with check (
  exists(
    select 1
    from public.appointments a
    where a.id = appointment_id
      and (a.patient_id = auth.uid() or a.practitioner_id = auth.uid() or public.is_admin())
  )
);

-- conversations
alter table public.conversations enable row level security;
drop policy if exists "conversations_select_participants" on public.conversations;
create policy "conversations_select_participants"
on public.conversations
for select
to authenticated
using (
  patient_id = auth.uid()
  or practitioner_id = auth.uid()
  or public.is_admin()
);

drop policy if exists "conversations_insert_participants" on public.conversations;
create policy "conversations_insert_participants"
on public.conversations
for insert
to authenticated
with check (
  patient_id = auth.uid()
  or practitioner_id = auth.uid()
  or public.is_admin()
);

drop policy if exists "conversations_update_participants" on public.conversations;
create policy "conversations_update_participants"
on public.conversations
for update
to authenticated
using (
  patient_id = auth.uid()
  or practitioner_id = auth.uid()
  or public.is_admin()
)
with check (
  patient_id = auth.uid()
  or practitioner_id = auth.uid()
  or public.is_admin()
);

-- messages
alter table public.messages enable row level security;
drop policy if exists "messages_select_participants" on public.messages;
create policy "messages_select_participants"
on public.messages
for select
to authenticated
using (
  exists(
    select 1
    from public.conversations c
    where c.id = conversation_id
      and (c.patient_id = auth.uid() or c.practitioner_id = auth.uid() or public.is_admin())
  )
);

drop policy if exists "messages_insert_sender_participant" on public.messages;
create policy "messages_insert_sender_participant"
on public.messages
for insert
to authenticated
with check (
  sender_id = auth.uid()
  and exists(
    select 1
    from public.conversations c
    where c.id = conversation_id
      and (
        (c.patient_id = sender_id and c.practitioner_id = recipient_id)
        or
        (c.practitioner_id = sender_id and c.patient_id = recipient_id)
        or public.is_admin()
      )
  )
);

drop policy if exists "messages_update_recipient_read" on public.messages;
create policy "messages_update_recipient_read"
on public.messages
for update
to authenticated
using (recipient_id = auth.uid() or public.is_admin())
with check (recipient_id = auth.uid() or public.is_admin());

-- payment methods
alter table public.payment_methods enable row level security;
drop policy if exists "payment_methods_crud_own" on public.payment_methods;
create policy "payment_methods_crud_own"
on public.payment_methods
for all
to authenticated
using (user_id = auth.uid() or public.is_admin())
with check (user_id = auth.uid() or public.is_admin());

-- reviews
alter table public.reviews enable row level security;
drop policy if exists "reviews_select_public" on public.reviews;
create policy "reviews_select_public"
on public.reviews
for select
to anon, authenticated
using (true);

drop policy if exists "reviews_insert_patient_for_completed_appointment" on public.reviews;
create policy "reviews_insert_patient_for_completed_appointment"
on public.reviews
for insert
to authenticated
with check (
  patient_id = auth.uid()
  and exists(
    select 1 from public.appointments a
    where a.id = appointment_id
      and a.patient_id = auth.uid()
      and a.practitioner_id = practitioner_id
      and a.status in ('completed'::public.appointment_status, 'no_show'::public.appointment_status)
  )
);

drop policy if exists "reviews_update_practitioner_reply" on public.reviews;
create policy "reviews_update_practitioner_reply"
on public.reviews
for update
to authenticated
using (practitioner_id = auth.uid() or public.is_admin())
with check (practitioner_id = auth.uid() or public.is_admin());

-- notifications
alter table public.notifications enable row level security;
drop policy if exists "notifications_select_own" on public.notifications;
create policy "notifications_select_own"
on public.notifications
for select
to authenticated
using (user_id = auth.uid() or public.is_admin());

drop policy if exists "notifications_update_own" on public.notifications;
create policy "notifications_update_own"
on public.notifications
for update
to authenticated
using (user_id = auth.uid() or public.is_admin())
with check (user_id = auth.uid() or public.is_admin());

-- audit log
alter table public.audit_log enable row level security;
drop policy if exists "audit_log_select_admin_or_actor" on public.audit_log;
create policy "audit_log_select_admin_or_actor"
on public.audit_log
for select
to authenticated
using (public.is_admin() or actor_id = auth.uid());

drop policy if exists "audit_log_insert_actor" on public.audit_log;
create policy "audit_log_insert_actor"
on public.audit_log
for insert
to authenticated
with check (actor_id = auth.uid() or public.is_admin());

-- ---------------------------------------------------------------------------
-- Utility functions (RPC-friendly)
-- ---------------------------------------------------------------------------

-- Simple practitioner appointment stats for CRM dashboards
create or replace function public.get_practitioner_appointment_stats(practitioner uuid, from_date date, to_date date)
returns table(
  pending bigint,
  confirmed bigint,
  cancelled bigint,
  completed bigint,
  no_show bigint
)
language sql
stable
as $$
  select
    count(*) filter (where a.status = 'pending'::public.appointment_status) as pending,
    count(*) filter (where a.status = 'confirmed'::public.appointment_status) as confirmed,
    count(*) filter (where a.status in ('cancelled_by_patient'::public.appointment_status, 'cancelled_by_practitioner'::public.appointment_status)) as cancelled,
    count(*) filter (where a.status = 'completed'::public.appointment_status) as completed,
    count(*) filter (where a.status = 'no_show'::public.appointment_status) as no_show
  from public.appointments a
  where a.practitioner_id = practitioner
    and a.appointment_date between from_date and to_date;
$$;

-- Basic availability generator (weekly schedule + overrides - booked slots)
create or replace function public.get_practitioner_available_slots(practitioner uuid, from_date date, to_date date)
returns table(
  slot_date date,
  slot_start time,
  slot_end time
)
language sql
stable
as $$
  with days as (
    select d::date as day
    from generate_series(from_date, to_date, interval '1 day') d
  ),
  base as (
    select
      days.day,
      ws.start_time as base_start,
      ws.end_time as base_end,
      ws.slot_duration_minutes as dur
    from days
    join public.practitioner_weekly_schedule ws
      on ws.practitioner_id = practitioner
     and ws.is_active = true
     and ws.day_of_week = extract(dow from days.day)::int
  ),
  ov as (
    select o.date, o.is_available, o.start_time, o.end_time
    from public.practitioner_schedule_overrides o
    where o.practitioner_id = practitioner
      and o.date between from_date and to_date
  ),
  windowed as (
    select
      b.day,
      case
        when ov.date is not null and ov.is_available = false then null::time
        when ov.date is not null and ov.is_available = true then ov.start_time
        else b.base_start
      end as start_time,
      case
        when ov.date is not null and ov.is_available = false then null::time
        when ov.date is not null and ov.is_available = true then ov.end_time
        else b.base_end
      end as end_time,
      b.dur
    from base b
    left join ov on ov.date = b.day
  ),
  slots as (
    select
      w.day as slot_date,
      (gs)::time as slot_start,
      (gs + make_interval(mins => w.dur))::time as slot_end
    from windowed w
    join lateral generate_series(
      w.day::timestamp + w.start_time,
      w.day::timestamp + w.end_time - make_interval(mins => w.dur),
      make_interval(mins => w.dur)
    ) gs
      on w.start_time is not null
     and w.end_time is not null
  ),
  free as (
    select s.*
    from slots s
    left join public.appointments a
      on a.practitioner_id = practitioner
     and a.appointment_date = s.slot_date
     and a.status in ('pending'::public.appointment_status, 'confirmed'::public.appointment_status)
     and not (a.end_time <= s.slot_start or a.start_time >= s.slot_end)
    where a.id is null
  )
  select * from free
  order by slot_date, slot_start;
$$;

-- Grant execute for RPC usage (RLS still applies to table reads)
grant execute on function public.get_practitioner_appointment_stats(uuid, date, date) to authenticated;
grant execute on function public.get_practitioner_available_slots(uuid, date, date) to anon, authenticated;

commit;

