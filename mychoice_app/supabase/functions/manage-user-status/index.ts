import { createClient } from "@supabase/supabase-js";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function jsonResponse(
  body: Record<string, string>,
  status: number,
): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

Deno.serve(async (request: Request) => {
  if (request.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (request.method !== "POST") {
    return jsonResponse({ error: "Method not allowed." }, 405);
  }

  const accessToken = request.headers
    .get("Authorization")
    ?.match(/^Bearer\s+(.+)$/i)?.[1];
  if (!accessToken) {
    return jsonResponse({ error: "Authentication is required." }, 401);
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!supabaseUrl || !serviceRoleKey) {
    return jsonResponse({ error: "User management is not configured." }, 500);
  }

  let payload: { targetUserId?: unknown; active?: unknown };
  try {
    payload = await request.json();
  } catch {
    return jsonResponse({ error: "Invalid request body." }, 400);
  }
  if (
    typeof payload.targetUserId !== "string" ||
    !/^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i
      .test(payload.targetUserId) ||
    typeof payload.active !== "boolean"
  ) {
    return jsonResponse({ error: "A valid user ID and status are required." }, 400);
  }

  const admin = createClient(supabaseUrl, serviceRoleKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  });
  const { data: authData, error: authError } = await admin.auth.getUser(
    accessToken,
  );
  if (authError || !authData.user) {
    return jsonResponse({ error: "The login session is invalid or expired." }, 401);
  }

  const { data: actor, error: actorError } = await admin
    .from("users")
    .select("role,status_akun")
    .eq("id_pengguna", authData.user.id)
    .maybeSingle();
  if (actorError) {
    return jsonResponse({ error: "Could not verify administrator access." }, 500);
  }
  if (!actor || actor.role !== "admin" || actor.status_akun !== "aktif") {
    return jsonResponse({ error: "Administrator access is required." }, 403);
  }
  if (payload.targetUserId === authData.user.id) {
    return jsonResponse({ error: "You cannot deactivate your own account." }, 400);
  }

  const { data: target, error: targetError } = await admin
    .from("users")
    .select("role,status_akun")
    .eq("id_pengguna", payload.targetUserId)
    .maybeSingle();
  if (targetError) {
    return jsonResponse({ error: "Could not load the target account." }, 500);
  }
  if (!target) {
    return jsonResponse({ error: "The target account was not found." }, 404);
  }
  if (target.role === "admin") {
    return jsonResponse({ error: "Administrator accounts cannot be deactivated here." }, 400);
  }

  const desiredStatus = payload.active ? "aktif" : "nonaktif";
  const { error: updateError } = await admin
    .from("users")
    .update({ status_akun: desiredStatus })
    .eq("id_pengguna", payload.targetUserId);
  if (updateError) {
    return jsonResponse({ error: "Could not update the account status." }, 500);
  }

  const { error: banError } = await admin.auth.admin.updateUserById(
    payload.targetUserId,
    { ban_duration: payload.active ? "none" : "876000h" },
  );
  if (banError) {
    const { error: rollbackError } = await admin
      .from("users")
      .update({ status_akun: target.status_akun })
      .eq("id_pengguna", payload.targetUserId);
    if (rollbackError) {
      console.error("Could not roll back account status:", rollbackError);
      return jsonResponse(
        { error: "Could not update sign-in status or restore the account status." },
        500,
      );
    }
    return jsonResponse({ error: "Could not update the sign-in status." }, 500);
  }

  return jsonResponse({ status: desiredStatus }, 200);
});
