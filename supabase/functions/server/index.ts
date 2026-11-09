// Supabase CLI expects index.ts as the function entry point.
// Figma Make keeps the generated server implementation in index.tsx.
import { app } from './index.tsx'

Deno.serve(app.fetch)
