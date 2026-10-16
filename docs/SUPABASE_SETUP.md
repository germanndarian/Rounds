# Supabase setup

## 1. Create the project
1. Sign in at <https://supabase.com/dashboard> (use GitHub sign-in with `germanndarian`).
2. **New project** → name `rounds`, pick a region close to your users (e.g. Frankfurt `eu-central-1`),
   generate and save a strong database password in your password manager.
3. Free tier is fine to start (note: free projects pause after a week of inactivity).

## 2. Connect the app
1. Dashboard → **Project Settings → API**: copy the **Project URL** and the **anon / publishable key**.
2. `cp Config/Secrets.example.xcconfig Config/Secrets.xcconfig` and paste both values in.
   This file is gitignored. Never put the `service_role` key in the app.
3. `xcodegen generate` and run — `Backend.client` is now non-nil.

## 3. Install the CLI and link the repo
```sh
brew install supabase/tap/supabase
supabase login
supabase init                         # creates supabase/config.toml
supabase link --project-ref <ref>     # ref = the subdomain of your project URL
```
Schema changes live in `supabase/migrations/` and are committed:
```sh
supabase migration new create_crews   # write SQL in the new file
supabase db push                      # apply to the hosted project
```
Optional local stack (needs Docker): `supabase start`.

## 4. Sign in with Apple
1. Apple Developer → Identifiers → enable **Sign in with Apple** on `com.dariangermann.rounds`.
2. In Xcode add the *Sign in with Apple* capability.
3. Supabase → **Authentication → Providers → Apple**: enable it and add `com.dariangermann.rounds`
   as a client ID. For native iOS (ID-token flow via `signInWithIdToken`) no secret key is required.

## 5. Storage & Realtime
- **Storage** → create a private bucket `photos` (paths like `crews/<crew_id>/nights/<night_id>/…`).
- **Realtime** → enable it for the `drinks` table once it exists (live feed).

## 6. Security — Row Level Security
Enable RLS on **every** table. Rule of thumb: a user can read/write rows only for crews they belong to.
Sketch of the first migration:

```sql
create table crews (id uuid primary key default gen_random_uuid(), name text not null,
  created_by uuid references auth.users not null, created_at timestamptz default now());
create table crew_members (crew_id uuid references crews on delete cascade,
  user_id uuid references auth.users on delete cascade, primary key (crew_id, user_id));
create table nights (id uuid primary key default gen_random_uuid(),
  crew_id uuid references crews on delete cascade, started_at timestamptz default now(), ended_at timestamptz);
create table drinks (id uuid primary key default gen_random_uuid(),
  night_id uuid references nights on delete cascade, user_id uuid references auth.users,
  kind text not null, photo_path text, lat double precision, lng double precision,
  comment text, logged_at timestamptz default now());

alter table crews enable row level security;
alter table crew_members enable row level security;
alter table nights enable row level security;
alter table drinks enable row level security;
-- then add policies, e.g. "members can read their crew's nights"
```
