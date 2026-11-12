// Type declarations for @supabase/supabase-js (Deno import via esm.sh)
// This file silences "Cannot find module" warnings in editors that do not
// read Deno import maps. The actual runtime import is resolved by deno.json.

declare module "@supabase/supabase-js" {
  export interface SupabaseClient {
    auth: {
      getUser: (
        accessToken: string,
      ) => Promise<{
        data: { user: { id: string } | null } | null;
        error: { message: string } | null;
      }>;
      admin: {
        deleteUser: (
          uid: string,
        ) => Promise<{ error: { message: string } | null }>;
      };
    };
  }

  export function createClient(
    supabaseUrl: string,
    supabaseKey: string,
    options?: {
      auth?: {
        autoRefreshToken?: boolean;
        persistSession?: boolean;
      };
    },
  ): SupabaseClient;
}
