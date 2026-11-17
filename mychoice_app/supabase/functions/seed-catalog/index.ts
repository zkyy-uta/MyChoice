import { createClient } from "@supabase/supabase-js";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function jsonResponse(body: unknown, status: number): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

type KatalogPayload = {
  kategori?: Array<{ nama_kategori: string; deskripsi?: string }>;
  sub_kategori?: Array<{ nama_kategori: string; nama_sub_kategori: string }>;
  pilihan_katalog?: Array<{
    nama_kategori: string;
    nama_sub_kategori: string;
    nama_pilihan: string;
    harga?: number | null;
    spesifikasi?: string | null;
    atribut?: Record<string, string | number | boolean | null>;
    mata_uang?: string | null;
    sumber_url?: string | null;
    lisensi_data?: string | null;
  }>;
  reseed?: boolean;
};

async function requireAdmin(
  admin: ReturnType<typeof createClient>,
  accessToken: string,
): Promise<{ userId: string } | Response> {
  const { data: userData, error: userError } =
    await admin.auth.getUser(accessToken);
  if (userError || !userData?.user) {
    return { userId: "", response: jsonResponse({ error: "Sesi login tidak valid atau kedaluwarsa." }, 401) };
  }
  const userId = userData.user.id;

  const { data: pengguna, error: pgError } = await admin
    .from("pengguna")
    .select("role")
    .eq("id_pengguna", userId)
    .maybeSingle();
  if (pgError || !pengguna || (pengguna as any).role !== "admin") {
    return { userId, response: jsonResponse({ error: "Akses ditolak. Hanya admin yang boleh seeding katalog." }, 403) };
  }
  return { userId, response: null };
}

Deno.serve(async (request: Request) => {
  // CORS preflight
  if (request.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (request.method !== "POST") {
    return jsonResponse({ error: "Method not allowed." }, 405);
  }

  // --- Env ---
  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!supabaseUrl || !serviceRoleKey) {
    return jsonResponse({ error: "Fungsi tidak dikonfigurasi di server." }, 500);
  }

  // --- Auth ---
  const authorization = request.headers.get("Authorization");
  const accessToken = authorization?.match(/^Bearer\s+(.+)$/i)?.[1];
  if (!accessToken) {
    return jsonResponse({ error: "Autentikasi diperlukan." }, 401);
  }

  const supabaseAdmin = createClient(supabaseUrl, serviceRoleKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  });

  const adminCheck = await requireAdmin(supabaseAdmin, accessToken);
  if (adminCheck.response) return adminCheck.response;

  // --- Body ---
  let payload: KatalogPayload;
  try {
    payload = (await request.json()) as KatalogPayload;
  } catch {
    return jsonResponse({ error: "Body JSON tidak valid." }, 400);
  }

  const result: Record<string, number> = {};

  try {
    // 1. Kategori
    if (Array.isArray(payload.kategori) && payload.kategori.length > 0) {
      const rows = payload.kategori.map((k) => ({
        nama_kategori: k.nama_kategori,
        deskripsi: k.deskripsi ?? null,
      }));
      const { error } = await supabaseAdmin
        .from("kategori")
        .upsert(rows, { onConflict: "nama_kategori" });
      if (error) throw error;
      result.kategori = rows.length;
    }

    // 2. Sub Kategori (butuh id_kategori dari nama_kategori)
    if (Array.isArray(payload.sub_kategori) && payload.sub_kategori.length > 0) {
      let inserted = 0;
      for (const s of payload.sub_kategori) {
        const { data: kat } = await supabaseAdmin
          .from("kategori")
          .select("id_kategori")
          .eq("nama_kategori", s.nama_kategori)
          .maybeSingle();
        if (!kat) continue;
        const { error } = await supabaseAdmin
          .from("sub_kategori")
          .upsert(
            {
              id_kategori: (kat as any).id_kategori,
              nama_sub_kategori: s.nama_sub_kategori,
            },
            { onConflict: "id_kategori,nama_sub_kategori" },
          );
        if (error) throw error;
        inserted++;
      }
      result.sub_kategori = inserted;
    }

    // 3. Pilihan Katalog / Barang (butuh id_sub_kategori)
    if (
      Array.isArray(payload.pilihan_katalog) &&
      payload.pilihan_katalog.length > 0
    ) {
      let inserted = 0;
      for (const p of payload.pilihan_katalog) {
        const { data: kategori, error: kategoriError } = await supabaseAdmin
          .from("kategori")
          .select("id_kategori")
          .eq("nama_kategori", p.nama_kategori)
          .maybeSingle();
        if (kategoriError) throw kategoriError;
        if (!kategori) {
          throw new Error(`Kategori tidak ditemukan: ${p.nama_kategori}`);
        }

        const { data: sub, error: subError } = await supabaseAdmin
          .from("sub_kategori")
          .select("id_sub_kategori")
          .eq("id_kategori", kategori.id_kategori)
          .eq("nama_sub_kategori", p.nama_sub_kategori)
          .maybeSingle();
        if (subError) throw subError;
        if (!sub) {
          throw new Error(
            `Subkategori tidak ditemukan: ${p.nama_kategori} / ${p.nama_sub_kategori}`,
          );
        }
        const { error } = await supabaseAdmin
          .from("pilihan_katalog")
          .upsert(
            {
              id_sub_kategori: (sub as any).id_sub_kategori,
              nama_pilihan: p.nama_pilihan,
              harga: p.harga ?? null,
              spesifikasi: p.spesifikasi ?? null,
              atribut: p.atribut ?? {},
              mata_uang: p.mata_uang ?? null,
              sumber_url: p.sumber_url ?? null,
              lisensi_data: p.lisensi_data ?? null,
            },
            { onConflict: "id_sub_kategori,nama_pilihan" },
          );
        if (error) throw error;
        inserted++;
      }
      result.pilihan_katalog = inserted;
    }

    return jsonResponse(
      {
        message: "Seeding katalog selesai.",
        detail: result,
        reseed: !!payload.reseed,
      },
      200,
    );
  } catch (err: any) {
    return jsonResponse(
      { error: "Gagal seeding katalog: " + (err?.message ?? String(err)) },
      500,
    );
  }
});
