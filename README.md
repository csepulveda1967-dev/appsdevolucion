# Devoluciones · App de registro para choferes

App web progresiva (PWA) para registrar devoluciones de despachos diarios en empresas de logística. Funciona en línea y sin conexión.

## Aplicaciones

| App | Archivo | Quién la usa |
|---|---|---|
| Chofer | `index.html` | Cada repartidor desde su celular — es la raíz del sitio |
| Oficina | `oficina.html` | Equipo administrativo desde el escritorio |

## Funcionalidades

### App Chofer (`index.html`)
- Login con correo y contraseña (Supabase Auth)
- Registro de devoluciones: N° factura, monto y motivo
- Detección de facturas duplicadas
- Historial del día con totales
- **Funciona sin conexión**: guarda en cola local y reenvía automáticamente al recuperar señal
- Instalable como PWA (Android e iOS)

### App Oficina (`oficina.html`)
- Login con correo y contraseña (Supabase Auth)
- Recepción en tiempo real (Supabase Realtime)
- KPIs del día: total devuelto, cantidad, choferes activos, por revisar
- Filtros por fecha, chofer y estado
- Buscador por factura o motivo
- Marcar devoluciones "por revisar" / "recibida"
- Exportar a Excel (CSV con BOM, abre directo en Excel)

## Stack

- **Frontend**: HTML + CSS + JavaScript vanilla (sin frameworks)
- **Backend**: [Supabase](https://supabase.com) (base de datos, autenticación, tiempo real)
- **PWA**: Service Worker + Web App Manifest
- **Fuente**: [Archivo](https://fonts.google.com/specimen/Archivo) vía Google Fonts

## Estructura del repositorio

```
devoluciones/
├── index.html           # App chofer (PWA)
├── oficina.html         # App oficina
├── manifest.json        # Manifiesto PWA
├── sw.js                # Service Worker
├── icon-192.png         # Ícono app
├── icon-512.png         # Ícono app
├── icon-512-maskable.png
└── README.md
```

## Configuración

### 1. Supabase — crear proyecto

1. Crea un proyecto en [supabase.com](https://supabase.com)
2. Ve a **Project Settings → API**
3. Copia la **URL** y la **anon key**
4. Reemplaza en `index.html` y `oficina.html`:

```js
const SB = supabase.createClient('TU_URL', 'TU_ANON_KEY');
```

### 2. Supabase — crear tabla y políticas

Ejecuta el SQL del archivo `supabase/schema.sql` en el **SQL Editor** de Supabase.

### 3. Supabase — crear usuarios

1. Ve a **Authentication → Users**
2. Crea un usuario para cada chofer y uno para oficina
3. Los choferes ingresan con su correo y contraseña en `index.html`

### 4. Despliegue

Sube todos los archivos a cualquier hosting estático:

- [GitHub Pages](https://pages.github.com) (gratis, directo desde este repo)
- [Netlify](https://netlify.com) (gratis, drag & drop)
- [Vercel](https://vercel.com) (gratis)

Para GitHub Pages: ve a **Settings → Pages → Branch: main → / (root)**.

## Despliegue en GitHub Pages

```bash
git clone https://github.com/TU_USUARIO/devoluciones.git
cd devoluciones
# Agrega tus credenciales de Supabase en index.html y oficina.html
git add .
git commit -m "Configurar Supabase"
git push
```

La app quedará disponible en `https://TU_USUARIO.github.io/devoluciones/`

## Proyecto relacionado

Este repositorio es el módulo de **devoluciones**. El módulo de **recaudación de pagos** vive en un repositorio separado con la misma arquitectura.
