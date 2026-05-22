# ESLint 9 + Prettier para NestJS Backend

## ✅ Configuración Completa

### Archivos creados
```
backend/
├── eslint.config.js              ← Flat Config (ESLint 9+) 
├── .prettierrc                   ← Prettier tabWidth: 2
├── .editorconfig                 ← Editor consistency
├── tsconfig.json                 ← TypeScript strict mode
├── package.json                  ← Scripts actualizados
└── INSTALL_DEVDEPS.sh            ← Script instalación
```

## 📦 Instalación rápida

### Opción 1: Script automático
```bash
cd backend
chmod +x INSTALL_DEVDEPS.sh
./INSTALL_DEVDEPS.sh
```

### Opción 2: Comando manual
```bash
cd backend && pnpm add -D \
  eslint@^9.0.0 \
  @eslint/js@^9.0.0 \
  typescript-eslint@^8.0.0 \
  prettier@^3.1.1 \
  eslint-config-prettier@^9.1.0 \
  eslint-plugin-prettier@^5.1.2 \
  typescript@^5.3.3 \
  @types/node@^20.10.6 \
  @types/express@^4.17.21
```

## 🚀 Uso - Scripts disponibles

```bash
# Lint con auto-fix
pnpm lint

# Solo verificar (sin fix)
pnpm lint:check

# Format con Prettier
pnpm format

# Verificar formato
pnpm format:check

# Type checking TypeScript
pnpm type-check

# Iniciar desarrollo
pnpm start:dev
```

## 🎨 Configuración

### ESLint Config (eslint.config.js)
**Flat Config** - ESLint 9+ moderno:
```javascript
import tseslint from 'typescript-eslint';
import prettier from 'eslint-config-prettier';

export default tseslint.config({
  extends: [
    ...tseslint.configs.recommended,
    ...tseslint.configs.recommendedTypeChecked,
    prettier,
  ],
  rules: {
    '@typescript-eslint/explicit-function-return-type': 'warn',
    '@typescript-eslint/no-floating-promises': 'error',
    '@typescript-eslint/no-misused-promises': 'error',
    'prettier/prettier': 'warn',
  }
});
```

### Prettier Config (.prettierrc)
```json
{
  "printWidth": 100,
  "tabWidth": 2,              ← 2 ESPACIOS
  "useTabs": false,
  "semi": true,
  "singleQuote": true,
  "trailingComma": "es5",
  "bracketSpacing": true,
  "arrowParens": "always",
  "endOfLine": "lf"
}
```

### TypeScript Config (tsconfig.json)
```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true,
    "skipLibCheck": true
  }
}
```

## 📝 Reglas ESLint principales

| Regla | Nivel | Qué hace |
|-------|-------|----------|
| `explicit-function-return-type` | warn | Obliga type hints en funciones |
| `no-floating-promises` | error | Detecta promesas sin await/catch |
| `no-misused-promises` | error | Evita errores con async/await |
| `no-unused-vars` | error | Detecta variables sin usar |
| `strict-boolean-expressions` | warn | Evita truthy/falsy implícito |
| `prettier/prettier` | warn | Conflictos de formato |

## ✅ Verificación rápida

```bash
cd backend

# Test 1: Lint (debe ser < 3s)
pnpm lint:check

# Test 2: Format check
pnpm format:check

# Test 3: Type check
pnpm type-check

# Si todo < 5s ✓ está bien configurado
```

## 🔧 Integración VSCode

Ya configurado en `.vscode/settings.json`:

```json
{
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.fixAll.eslint": "explicit"
    },
    "editor.tabSize": 2
  },
  "prettier.tabWidth": 2,
  "typescript.tsdk": "backend/node_modules/typescript/lib"
}
```

## 🎯 Flujo de desarrollo

1. **Escribe código**
2. **Guarda archivo** → Auto-format con Prettier
3. **Auto-fix** con ESLint (si hay problemas)
4. **Type checking** automático

## 📚 Referencias

- [ESLint 9 Docs](https://eslint.org/docs/latest/)
- [TypeScript ESLint](https://typescript-eslint.io/)
- [Prettier Docs](https://prettier.io/)
- [NestJS Docs](https://docs.nestjs.com/)

## 🚨 Troubleshooting

### ESLint no está funcionando
```bash
# Verifica que el archivo existe
ls -la backend/eslint.config.js

# Reinstala
pnpm add -D eslint@^9.0.0 @eslint/js@^9.0.0
```

### VSCode se congela
```json
// Agrega a .vscode/settings.json:
{
  "typescript.tsdk": "backend/node_modules/typescript/lib",
  "typescript.enablePromptUseWorkspaceTsdk": true
}
```

### Prettier conflicta con ESLint
→ Ya resuelto: `eslint-config-prettier` al final

---

✅ **¡Backend listo para desarrollo!** 🚀
