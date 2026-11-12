---
name: supabase-migration
description: Use when adding or changing a Supabase table, column, RLS policy, storage bucket or policy, realtime publication, or when running supabase migration new / db push, or touching photo unlock (10:00 next morning) or the drinks feed.
---

# Supabase migration

The hosted project is linked. Context and setup notes: vault `Rounds Supabase setup.md` (read only if needed).

## Steps
1. `supabase migration new <short_snake_name>` creates `supabase/migrations/<timestamp>_<name>.sql`. Write all SQL there.
2. Never edit or delete `20261016162943_create_crews.sql`. It is empty but already applied remotely; editing it breaks migration history.
3. Every table gets RLS in the same migration. Pattern (crew membership):
```sql
alter table public.drinks enable row level security;

create policy "crew members read drinks" on public.drinks
  for select to authenticated
  using (exists (
    select 1 from public.crew_members m
    where m.crew_id = drinks.crew_id and m.user_id = auth.uid()
  ));
```
   Add matching `insert`/`update`/`delete` policies (`with check` on insert/update). Adjust column names to the real schema.
4. Realtime on `drinks`: `alter publication supabase_realtime add table public.drinks;`
5. Review the diff, then `supabase db push --dry-run` and read the list.
6. `supabase db push` hits the **hosted** project and cannot be undone by deleting a file. Run it only when the task says to apply it.
   Afterwards `supabase migration list` should show local and remote in sync (needs `supabase login`).

## Storage and photos
- Bucket `photos`, private. Object path: `crews/<crew_id>/nights/<night_id>/<file>`.
- Storage policies parse the path (`storage.foldername(name)`) to check crew membership.
- The sealed-until-10:00 rule is enforced server-side: the select policy on the photos objects (or rows) must also check
  that now() is past 10:00 on the morning after the night (night time zone). A hidden UI is not enough. Test it with a
  query as a non-owner before 10:00.

## Gotchas
- Table in `public` without RLS is readable by anyone with the anon key. Always enable it.
- Never use or ship the `service_role` key in the app or the repo.
- New migrations only. Fix mistakes with a follow-up migration, not by rewriting applied ones.
- Do not run `supabase db reset` against anything but a local stack.

## Worked when
`--dry-run` lists only your new file, the SQL has `enable row level security` for each new table, and the app still builds.
