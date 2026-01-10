-- Create a helper function and trigger that automatically creates a
-- profiles row when a new auth user is created. Run this in the Supabase
-- SQL editor (you must be an admin/service role to create these).

-- Function: create profile when auth.user inserted
create or replace function public.handle_new_auth_user()
returns trigger
language plpgsql
security definer
as $$
begin
  -- Only create profile if it does not already exist
  if not exists(select 1 from public.profiles where id = new.id) then
    insert into public.profiles (id, username, name, created_at, total_score, is_premium)
    values (new.id, (new.email::text)::text, (new.email::text)::text, now(), 0, false);
  end if;
  return new;
end;
$$;

-- Trigger on auth.users after insert
create trigger create_profile_after_user_insert
  after insert on auth.users
  for each row
  execute function public.handle_new_auth_user();

-- NOTES:
-- - This trigger runs with the database service role (security definer),
--   so it can insert into `profiles` without requiring the client to be
--   authenticated. Do NOT expose the service_role key in client apps.
-- - If you prefer client-only flow, ensure signUp returns a session (no
--   email confirmation) or create a temporary anon INSERT policy during
--   signup (not recommended for production).
