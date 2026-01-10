-- Supabase Row-Level Security (RLS) policies for `profiles` table
-- Run these in the Supabase SQL editor for your project's database.

-- 1) Enable RLS on the table (if not already enabled)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 2) Allow authenticated users to SELECT only their own profile
CREATE POLICY allow_authenticated_select_own_profile
  ON public.profiles
  FOR SELECT
  USING (auth.uid() = id);

-- 3) Allow authenticated users to INSERT a profile only if the
-- inserted id matches their auth UID. This supports creating the
-- profile row immediately after signup (when the auth user exists).
CREATE POLICY allow_authenticated_insert_own_profile
  ON public.profiles
  FOR INSERT
  WITH CHECK (auth.uid() = id);

-- 4) Allow authenticated users to UPDATE only their own profile
CREATE POLICY allow_authenticated_update_own_profile
  ON public.profiles
  FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- 5) (Optional) Disallow DELETE for normal users. You may provide a
-- separate policy for admins/service_role if you need deletes.
-- CREATE POLICY allow_admin_delete_profiles
--   ON public.profiles
--   FOR DELETE
--   USING (auth.role() = 'service_role');

-- NOTES:
-- - These policies assume your application uses Supabase Auth and that
--   profile.id equals the auth user's id (UUID).
-- - If you previously added an "anon INSERT" policy for testing, remove
--   it when moving to production to avoid unauthorized profile creation.
-- - Server-side/admin tasks should use the service_role key; never embed
--   the service_role key in client apps.
