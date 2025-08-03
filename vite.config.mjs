import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import tailwindcss from '@tailwindcss/vite'
import ui from '@nuxt/ui/vite'

export default defineConfig({
  publicDir: false,
  build: {
    outDir: './priv/static',
    emptyOutDir: false,
    manifest: true,
    rollupOptions: {
      input: {
        app: './assets/js/app.js'
      },
      output: {
        entryFileNames: 'assets/[name].js',
        chunkFileNames: 'assets/[name].js',
        assetFileNames: 'assets/[name][extname]'
      }
    }
  },
  plugins: [
    vue(),
    tailwindcss(),
    ui()
  ],
  resolve: {
    alias: {
      '@': '/assets/js'
    }
  },
  server: {
    port: 5173,
    strictPort: true, // Fail if port is in use
    cors: {
      origin: true,
      credentials: true
    },
    hmr: {
      host: 'localhost'
    }
  }
})