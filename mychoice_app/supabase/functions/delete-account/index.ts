import { createClient } from "@supabase/supabase-js";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function jsonResponse(
  body: Record<string, string | number>,
  status: number,
): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

Deno.serve(async (request: Request) => {
  // Handle CORS preflight request
  if (request.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  // Only POST method is allowed
  if (request.method !== "POST") {
    return jsonResponse({ error: "Method not allowed." }, 405);
  }

  // Extract Bearer token from Authorization header
  const authorization = request.headers.get("Authorization");
  const accessToken = authorization?.match(/^Bearer\s+(.+)$/i)?.[1];
  if (!accessToken) {
    return jsonResponse({ error: "Authentication is required." }, 401);
  }

  // Load environment variables
  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!supabaseUrl || !serviceRoleKey) {
    return jsonResponse({ error: "Account deletion is not configured." }, 500);
  }

  // Initialize Supabase admin client with service role key
  const supabaseAdmin = createClient(supabaseUrl, serviceRoleKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  });

  // Verify the access token and get the user
  const { data, error: userError } = await supabaseAdmin.auth.getUser(
    accessToken,
  );
  if (userError || !data.user) {
    return jsonResponse(
      { error: "The login session is invalid or expired." },
      401,
    );
  }

  // Delete the user account using admin API
  const { error: deleteError } = await supabaseAdmin.auth.admin.deleteUser(
    data.user.id,
  );
  if (deleteError) {
    return jsonResponse({ error: "The account could not be deleted." }, 500);
  }

  return jsonResponse({ message: "Account deleted." }, 200);
});
