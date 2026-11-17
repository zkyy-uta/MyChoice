-- Normalize existing catalog prices to Indonesian Rupiah.
-- Illustrative fixed rate: USD 1 = IDR 16,000 (not a live exchange rate).
-- Apply after 20261113000003_structured_catalog_attributes.sql.

create or replace function public.convert_catalog_usd_prices_to_idr(specifications text)
returns text
language plpgsql
immutable
parallel safe
set search_path = ''
as $$
declare
  result text := specifications;
  token text;
  amount numeric;
  formatted_amount text;
begin
  if result is null then
    return null;
  end if;

  loop
    token := (regexp_match(result, '\$[0-9][0-9,.]*'))[1];
    exit when token is null;

    amount := replace(substr(token, 2), ',', '')::numeric;
    formatted_amount := replace(
      to_char(round(amount * 16000), 'FM999,999,999,999,999,990'),
      ',',
      '.'
    );
    result := replace(result, token, 'Rp ' || formatted_amount);
  end loop;

  return result;
end;
$$;

-- Convert numeric USD prices before changing their text labels.
update public.pilihan_katalog
set harga = round(harga * 16000),
    mata_uang = 'IDR'
where harga is not null
  and spesifikasi like '%$%';

-- Where the seed already states a Rupiah price, use that stated amount.
update public.pilihan_katalog
set harga = replace(
      replace((regexp_match(spesifikasi, 'Price:\s*Rp\s*([0-9.,]+)'))[1], '.', ''),
      ',',
      ''
    )::numeric,
    mata_uang = 'IDR'
where spesifikasi ~* 'Price:\s*Rp\s*[0-9.,]+';

update public.pilihan_katalog
set spesifikasi = public.convert_catalog_usd_prices_to_idr(spesifikasi)
where spesifikasi like '%$%';

update public.pilihan_katalog as pk
set atribut = converted.atribut
from (
  select
    item.id_pilihan_katalog,
    jsonb_object_agg(
      spec.key,
      case
        when jsonb_typeof(spec.value) = 'string'
          and (spec.value #>> '{}') like '%$%'
          then to_jsonb(public.convert_catalog_usd_prices_to_idr(spec.value #>> '{}'))
        else spec.value
      end
    ) as atribut
  from public.pilihan_katalog as item
  cross join lateral jsonb_each(item.atribut) as spec(key, value)
  group by item.id_pilihan_katalog
) as converted
where pk.id_pilihan_katalog = converted.id_pilihan_katalog
  and exists (
    select 1
    from jsonb_each(pk.atribut) as spec(key, value)
    where jsonb_typeof(spec.value) = 'string'
      and (spec.value #>> '{}') like '%$%'
  );

drop function public.convert_catalog_usd_prices_to_idr(text);
