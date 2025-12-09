# Execute React + Supabase PRP

Implement a PRP phase by phase with validation. **The AI handles all scaffolding and setup.**

## Input: $ARGUMENTS

Path to PRP file (e.g., `PRPs/my-feature.md`)

## Process

### Phase 0: Project Scaffolding (if new project)

**Prerequisites:** User must have Supabase running (hosted or `supabase start`) and `.env.local` configured.

If this is a fresh project (no `package.json` or no React dependencies), run scaffolding:

```bash
# 1. Create Vite + React project
pnpm create vite@latest . --template react-swc-ts

# 2. Install all dependencies
pnpm add @tanstack/react-router @tanstack/react-query @supabase/supabase-js @supabase/ssr
pnpm add react-hook-form @hookform/resolvers zod
pnpm add -D @tanstack/router-plugin vitest @testing-library/react @testing-library/user-event jsdom @biomejs/biome

# 3. Initialize shadcn/ui (auto-accept defaults)
pnpm dlx shadcn@latest init -y

# 4. Add common shadcn components
pnpm dlx shadcn@latest add button input form card skeleton toast -y
```

Then configure:
- Update `vite.config.ts` with TanStack Router plugin
- Create `src/shared/utils/supabase.ts` client
- Set up TanStack Query provider in `src/main.tsx`
- Create base route structure

**Validation:** `pnpm dev` starts without errors

### Phase 1+: Feature Implementation

1. **Load PRP** - Read completely, understand all phases

2. **Phase Execution**
   - Announce phase and files to create
   - Implement following vertical slice architecture
   - Validate phase completion

3. **Per-Phase Testing (CRITICAL)**

   | Phase | Run Tests? | Command |
   |-------|------------|---------|
   | Database | No | `supabase db reset` |
   | Schemas | No | - |
   | Hooks | **YES** | `pnpm test src/features/[feature]/__tests__/use-*` |
   | Components | **YES** | `pnpm test src/features/[feature]/__tests__/` |
   | Routes | **YES** | `pnpm test --run` (full suite) |

   **Do NOT proceed if tests fail.**

4. **Final Validation**
   ```bash
   pnpm build
   pnpm tsc --noEmit
   pnpm biome check .
   pnpm test --run
   ```

## Architecture

```
src/
├── routes/              # TanStack Router (thin)
├── features/[name]/     # Vertical slices
│   ├── __tests__/
│   ├── components/
│   ├── hooks/
│   ├── schemas/
│   ├── types/
│   └── index.ts         # Public API
└── shared/              # UI, utils (NO business logic)
    ├── components/
    ├── utils/
    └── types/
```

**Import Rules:**
- Routes import from `@/features/[name]`
- Features import from `@/shared/*`
- Shared NEVER imports from features

## Scaffolding Files Reference

### vite.config.ts
```typescript
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react-swc'
import { TanStackRouterVite } from '@tanstack/router-plugin/vite'
import path from 'path'

export default defineConfig({
  plugins: [react(), TanStackRouterVite()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
})
```

### src/shared/utils/supabase.ts
```typescript
import { createBrowserClient } from '@supabase/ssr';

export const supabase = createBrowserClient(
  import.meta.env.VITE_SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY
);
```

### src/main.tsx
```typescript
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { RouterProvider, createRouter } from '@tanstack/react-router'
import { routeTree } from './routeTree.gen'
import './index.css'

const queryClient = new QueryClient()
const router = createRouter({ routeTree })

declare module '@tanstack/react-router' {
  interface Register {
    router: typeof router
  }
}

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <QueryClientProvider client={queryClient}>
      <RouterProvider router={router} />
    </QueryClientProvider>
  </StrictMode>,
)
```

### src/routes/__root.tsx
```typescript
import { createRootRoute, Outlet } from '@tanstack/react-router'

export const Route = createRootRoute({
  component: () => <Outlet />,
})
```

### src/routes/index.tsx
```typescript
import { createFileRoute } from '@tanstack/react-router'

export const Route = createFileRoute('/')({
  component: () => <div>Home</div>,
})
```
