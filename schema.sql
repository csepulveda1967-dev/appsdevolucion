-- =============================================================
--  DEVOLUCIONES · Schema Supabase
--  Ejecutar en: Supabase → SQL Editor → New query
-- =============================================================


-- -------------------------------------------------------------
-- 1. TABLA PRINCIPAL
-- -------------------------------------------------------------

create table if not exists public.devoluciones (
  id            bigint generated always as identity primary key,
  chofer        text        not null,
  numero_factura text       not null,
  monto         numeric     not null check (monto > 0),
  motivo        text        null,
  revisar       boolean     not null default false,
  creado_en     timestamptz not null default now()
);

-- Índices para las consultas frecuentes (por fecha y por chofer)
create index if not exists devoluciones_creado_en_idx on public.devoluciones (creado_en desc);
create index if not exists devoluciones_chofer_idx    on public.devoluciones (chofer);


-- -------------------------------------------------------------
-- 2. ROW LEVEL SECURITY (RLS)
-- -------------------------------------------------------------

alter table public.devoluciones enable row level security;

-- Los choferes solo pueden INSERT y SELECT sus propios registros.
-- La oficina (rol service_role o usuario autenticado) puede leerlo todo.

-- Política: cualquier usuario autenticado puede insertar
create policy "Choferes pueden insertar devoluciones"
  on public.devoluciones
  for insert
  to authenticated
  with check (true);

-- Política: cualquier usuario autenticado puede leer todos los registros
-- (oficina y choferes ven el mismo dato; si quieres restringir por chofer
--  cambia 'true' por: auth.jwt() ->> 'email' = chofer  o usa una columna user_id)
create policy "Usuarios autenticados pueden leer devoluciones"
  on public.devoluciones
  for select
  to authenticated
  using (true);

-- Política: solo usuarios autenticados pueden actualizar (ej: marcar revisar)
create policy "Usuarios autenticados pueden actualizar devoluciones"
  on public.devoluciones
  for update
  to authenticated
  using (true)
  with check (true);


-- -------------------------------------------------------------
-- 3. REALTIME
--    Habilita la publicación de cambios para la app de oficina
-- -------------------------------------------------------------

-- Agrega la tabla al canal de realtime
alter publication supabase_realtime add table public.devoluciones;


-- -------------------------------------------------------------
-- 4. DATOS DE PRUEBA (opcional — borrar antes de producción)
-- -------------------------------------------------------------

/*
insert into public.devoluciones (chofer, numero_factura, monto, motivo) values
  ('Juan Pérez',   '48001', 12500,  'Cliente ausente'),
  ('Juan Pérez',   '48002', 8900,   'Dirección incorrecta'),
  ('Carlos Rojas', '48015', 34000,  null),
  ('María Silva',  '48031', 5500,   'Producto dañado');
*/
