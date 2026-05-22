#!/bin/bash

# Frontend - ESLint 9 + Prettier + Angular 22 Setup
# Instala todas las devDependencies necesarias

echo "🚀 Instalando devDependencies para Angular 22 + ESLint 9..."
echo ""

cd frontend

# ESLint 9 + TypeScript ESLint v8 + @eslint/js
echo "📦 Instalando ESLint 9 y TypeScript ESLint..."
pnpm add -D \
  eslint@^9.0.0 \
  @eslint/js@^9.0.0 \
  typescript-eslint@^8.0.0

# Angular ESLint (última versión compatible con Angular 22)
echo "📦 Instalando @angular-eslint..."
pnpm add -D \
  @angular-eslint/builder@^18.0.0 \
  @angular-eslint/eslint-plugin@^18.0.0 \
  @angular-eslint/eslint-plugin-template@^18.0.0 \
  @angular-eslint/schematics@^18.0.0 \
  @angular-eslint/template-parser@^18.0.0

# Prettier + ESLint integration
echo "📦 Instalando Prettier..."
pnpm add -D \
  prettier@^3.3.0 \
  eslint-config-prettier@^9.1.0 \
  eslint-plugin-prettier@^5.2.0

# TypeScript & Types
echo "📦 Instalando TypeScript y tipos..."
pnpm add -D \
  typescript@^5.6.0 \
  @types/node@^22.0.0

echo ""
echo "✅ ¡Todas las devDependencies instaladas!"
echo ""
echo "📝 Resumen de instalación:"
echo "   ✓ ESLint 9.0+"
echo "   ✓ TypeScript ESLint v8"
echo "   ✓ @eslint/js"
echo "   ✓ @angular-eslint"
echo "   ✓ Prettier"
echo "   ✓ TypeScript 5.6"
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
echo "   pnpm type-check     - TypeScript verification"
echo ""
