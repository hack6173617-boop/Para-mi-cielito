-- =====================================================
--  Mi Wey · Supabase Storage
--  Pégalo en: Supabase → SQL Editor → New query → Run
-- =====================================================

-- 1) Bucket PÚBLICO "mi-wey" (aquí van las fotos y la canción)
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'mi-wey',
  'mi-wey',
  true,
  52428800,  -- 50 MB por archivo
  array[
    'image/jpeg','image/png','image/webp',
    'audio/mpeg','audio/mp4','audio/x-m4a','audio/wav','audio/ogg'
  ]
)
on conflict (id) do update
  set public = true,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

-- 2) Cualquiera con el enlace puede VER los archivos (solo lectura)
drop policy if exists "mi-wey lectura publica" on storage.objects;
create policy "mi-wey lectura publica"
  on storage.objects
  for select
  to public
  using (bucket_id = 'mi-wey');

-- Nota: no hay políticas de subir/borrar para el público.
-- Los archivos los subes tú desde el panel: Storage → mi-wey → Upload.