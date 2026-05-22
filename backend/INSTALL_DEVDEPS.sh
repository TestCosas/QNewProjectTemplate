#!/bin/bash

# Backend - ESLint 9 + Prettier + NestJS Setup
# Instala todas las devDependencies necesarias

echo "🚀 Instalando devDependencies para NestJS + ESLint 9..."
echo ""

cd backend

# ESLint 9 + TypeScript ESLint v8 + @eslint/js
echo "📦 Instalando ESLint 9 y TypeScript ESLint..."
pnpm add -D \
  eslint@^9.0.0 \
  @eslint/js@^9.0.0 \
  typescript-eslint@^8.0.0

# Prettier + ESLint integration
echo "📦 Instalando Prettier..."
pnpm add -D \
  prettier@^3.1.1 \
  eslint-config-prettier@^9.1.0 \
  eslint-plugin-prettier@^5.1.2

# TypeScript & Types
echo "📦 Instalando TypeScript y tipos..."
pnpm add -D \
  typescript@^5.3.3 \
  @types/node@^20.10.6 \
  @types/express@^4.17.21

echo ""
echo "✅ ¡Todas las devDependencies instaladas!"
echo ""
echo "📝 Resumen de instalación:"
echo "   ✓ ESLint 9.0+"
echo "   ✓ TypeScript ESLint v8"
echo "   ✓ @eslint/js"
echo "   ✓ Prettier"
echo "   ✓ TypeScript 5.3"
echo ""
echo "🧪 Verificando instalación..."
eslint --version
prettier --version
echo ""
echo "✅ ¡Listo para usar!"
echo ""
echo "Comandos disponibles:"
echo "   pnpm lint           - Lint con auto-fix"
echo "   pnpm lint:check     - Solo verificar"
echo "   pnpm format         - Prettier formatting"
echo "   pnpm format:check   - Verificar formato"
echo "   pnpm type-check     - TypeScript verification"
echo "   pnpm start:dev      - Iniciar desarrollo"
echo ""
