#!/bin/bash

# QNewProjectTemplate - Setup Script
# Este script crea toda la estructura del monorepo

set -e

echo "🚀 Creando estructura QNewProjectTemplate..."

# Root files
mkdir -p .github/workflows
touch .github/workflows/.gitkeep

# Crear .gitignore
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
.pnpm-store/
pnpm-lock.yaml

# IDE
.vscode/
.idea/
*.swp
*.swo
*.sublime-workspace
*.sublime-project
.DS_Store

# Environment
.env
.env.local
.env.*.local

# Logs
logs/
*.log
npm-debug.log*
pnpm-debug.log*
yarn-debug.log*
yarn-error.log*

# Build outputs
dist/
build/
.angular/
.next/
out/

# OS
Thumbs.db
.DS_Store

# Database
*.sqlite
*.db

# Development
.cache/
.temp/
EOF

# Crear .prettierrc
cat > .prettierrc << 'EOF'
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false,
  "bracketSpacing": true,
  "arrowParens": "always",
  "endOfLine": "lf"
}
EOF

# Crear tsconfig.base.json
cat > tsconfig.base.json << 'EOF'
{
  "compileOnSave": false,
  "compilerOptions": {
    "baseUrl": ".",
    "outDir": "./dist/out-tsc",
    "forceConsistentCasingInFileNames": true,
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "strictPropertyInitialization": true,
    "noImplicitThis": true,
    "alwaysStrict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "sourceMap": true,
    "declaration": false,
    "downlevelIteration": true,
    "experimentalDecorators": true,
    "moduleResolution": "node",
    "importHelpers": true,
    "target": "ES2022",
    "module": "ES2022",
    "lib": ["ES2022", "dom"],
    "paths": {
      "@shared/common": ["shared/shared-common/src/public-api.ts"],
      "@shared/front": ["shared/shared-front/src/public-api.ts"],
      "@shared/back": ["shared/shared-back/src/public-api.ts"]
    }
  },
  "angularCompilerOptions": {
    "enableI18nLegacyMessageIdFormat": false,
    "strictInjectionParameters": true,
    "strictInputAccessModifiers": true,
    "strictTemplates": true
  }
}
EOF

# Crear pnpm-workspace.yaml
cat > pnpm-workspace.yaml << 'EOF'
packages:
  - 'frontend'
  - 'backend'
  - 'shared/shared-common'
  - 'shared/shared-front'
  - 'shared/shared-back'
EOF

# Crear README.md
cat > README.md << 'EOF'
# QNewProjectTemplate

**Angular + NestJS Monorepo Template with pnpm**

## 🎯 Características

### Frontend (Angular)
- ✅ Angular latest + TypeScript
- ✅ Angular Material 3 (Purple Theme + Dark/Light Toggle)
- ✅ i18n nativo (ES, EN)
- ✅ ESLint + Prettier
- ✅ Path aliases (@shared/...)

### Backend (NestJS)
- ✅ NestJS latest + TypeScript
- ✅ MariaDB + TypeORM
- ✅ Winston Logger (structured, con clase origen)
- ✅ HTTP Interceptor (logs de requests)
- ✅ ESLint + Prettier
- ✅ Migraciones TypeORM

### Shared Libraries
- `@shared/common` - DTOs, Interfaces, Utils
- `@shared/front` - Componentes Angular reutilizables
- `@shared/back` - Controllers, Servicios NestJS

## 📦 Setup Inicial

```bash
# Instalar dependencias
pnpm install

# Desarrollo Backend
cd backend && pnpm start:dev

# Desarrollo Frontend
cd frontend && pnpm start

# Base de datos
docker-compose up -d
```

## 📁 Estructura

```
.
├── frontend/
├── backend/
├── shared/
│   ├── shared-common/
│   ├── shared-front/
│   └── shared-back/
├── pnpm-workspace.yaml
├── tsconfig.base.json
└── .prettierrc
```

## 🛠️ Desarrollo

### Path Aliases
Ya configurados en `tsconfig.base.json` para usar en cualquier paquete:
```typescript
import { MyDTO } from '@shared/common';
import { MyComponent } from '@shared/front';
import { MyService } from '@shared/back';
```

### Logs
Winston configurado con:
- Nivel: `error`, `warn`, `info`, `debug`
- Contexto automático (clase origen)
- Stack traces en errors
- Logs HTTP (método, URL, status, tiempo)

## 📝 Próximos Pasos

- [ ] Autenticación JWT
- [ ] Módulos de features
- [ ] Tests (e2e, unit)
- [ ] CI/CD (GitHub Actions)
- [ ] Deploy
EOF

# ========================
# BACKEND - NESTJS
# ========================
echo "📦 Creando BACKEND (NestJS)..."
mkdir -p backend/src/{config,common/{logger,interceptors},database/migrations,modules/{auth,health}}

# Backend .eslintrc.js
cat > backend/.eslintrc.js << 'EOF'
module.exports = {
  parser: '@typescript-eslint/parser',
  parserOptions: {
    project: 'tsconfig.json',
    sourceType: 'module',
  },
  plugins: ['@typescript-eslint/eslint-plugin'],
  extends: [
    'plugin:@typescript-eslint/recommended',
    'plugin:prettier/recommended',
  ],
  root: true,
  env: {
    node: true,
    jest: true,
  },
  ignorePatterns: ['.eslintrc.js'],
  rules: {
    '@typescript-eslint/interface-name-prefix': 'off',
    '@typescript-eslint/explicit-function-return-type': 'off',
    '@typescript-eslint/explicit-module-boundary-types': 'off',
    '@typescript-eslint/no-explicit-any': 'warn',
    '@typescript-eslint/no-unused-vars': [
      'error',
      { argsIgnorePattern: '^_' },
    ],
  },
};
EOF

# Backend .prettierrc
cp .prettierrc backend/.prettierrc

# Backend .env.example
cat > backend/.env.example << 'EOF'
# Server
NODE_ENV=development
PORT=3000
API_PREFIX=api

# Database
DB_TYPE=mariadb
DB_HOST=localhost
DB_PORT=3306
DB_USERNAME=root
DB_PASSWORD=password
DB_DATABASE=qnewproject

# Logger
LOG_LEVEL=debug
EOF

# Backend nest-cli.json
cat > backend/nest-cli.json << 'EOF'
{
  "$schema": "https://json.schemastore.org/nest-cli",
  "collection": "@nestjs/schematics",
  "sourceRoot": "src",
  "compilerOptions": {
    "webpack": true,
    "tsConfigPath": "tsconfig.json"
  }
}
EOF

# Backend tsconfig.json
cat > backend/tsconfig.json << 'EOF'
{
  "extends": "../tsconfig.base.json",
  "compilerOptions": {
    "module": "commonjs",
    "target": "ES2021",
    "lib": ["ES2021"],
    "outDir": "./dist",
    "rootDir": "./src",
    "baseUrl": "./src",
    "paths": {
      "@shared/common": ["../../shared/shared-common/src/public-api.ts"],
      "@shared/back": ["../../shared/shared-back/src/public-api.ts"]
    }
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

# Backend package.json
cat > backend/package.json << 'EOF'
{
  "name": "@qnewproject/backend",
  "version": "1.0.0",
  "description": "QNewProject Backend - NestJS + MariaDB + TypeORM",
  "author": "TestCosas",
  "private": true,
  "license": "MIT",
  "scripts": {
    "build": "nest build",
    "start": "node dist/main",
    "start:dev": "nest start --watch",
    "start:debug": "nest start --debug --watch",
    "lint": "eslint \"{src,libs}/**/*.ts\" --fix",
    "format": "prettier --write \"src/**/*.ts\" \"libs/**/*.ts\"",
    "typeorm": "typeorm",
    "migration:create": "npm run typeorm migration:create",
    "migration:generate": "npm run typeorm migration:generate",
    "migration:run": "npm run typeorm migration:run",
    "migration:revert": "npm run typeorm migration:revert"
  },
  "dependencies": {
    "@nestjs/common": "^10.3.0",
    "@nestjs/core": "^10.3.0",
    "@nestjs/platform-express": "^10.3.0",
    "@nestjs/typeorm": "^9.0.1",
    "reflect-metadata": "^0.1.13",
    "rxjs": "^7.8.1",
    "typeorm": "^0.3.17",
    "mysql2": "^3.6.5",
    "winston": "^3.11.0",
    "lodash-es": "^4.17.21",
    "class-validator": "^0.14.0",
    "class-transformer": "^0.5.1"
  },
  "devDependencies": {
    "@nestjs/cli": "^10.3.0",
    "@nestjs/schematics": "^10.0.3",
    "@types/express": "^4.17.21",
    "@types/node": "^20.10.6",
    "@typescript-eslint/eslint-plugin": "^6.17.0",
    "@typescript-eslint/parser": "^6.17.0",
    "eslint": "^8.56.0",
    "eslint-config-prettier": "^9.1.0",
    "eslint-plugin-prettier": "^5.1.2",
    "prettier": "^3.1.1",
    "ts-loader": "^9.5.1",
    "ts-node": "^10.9.2",
    "tsconfig-paths": "^4.2.0",
    "typescript": "^5.3.3"
  }
}
EOF

# Backend main.ts
cat > backend/src/main.ts << 'EOF'
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { LoggerService } from './common/logger/logger.service';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const logger = app.get(LoggerService);

  const port = process.env.PORT || 3000;
  const apiPrefix = process.env.API_PREFIX || 'api';

  app.setGlobalPrefix(apiPrefix);
  app.enableCors();

  await app.listen(port);
  logger.log(`🚀 Server running on http://localhost:${port}/${apiPrefix}`, 'Bootstrap');
}

bootstrap().catch((err) => console.error(err));
EOF

# Backend app.module.ts
cat > backend/src/app.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { DatabaseModule } from './database/database.module';
import { LoggerModule } from './common/logger/logger.module';
import { HealthModule } from './modules/health/health.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.env.local', '.env'],
    }),
    LoggerModule,
    DatabaseModule,
    HealthModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
EOF

# Backend app.controller.ts
cat > backend/src/app.controller.ts << 'EOF'
import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): { message: string; version: string } {
    return this.appService.getHello();
  }
}
EOF

# Backend app.service.ts
cat > backend/src/app.service.ts << 'EOF'
import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(): { message: string; version: string } {
    return {
      message: 'Welcome to QNewProject API',
      version: '1.0.0',
    };
  }
}
EOF

# Backend logger.service.ts
cat > backend/src/common/logger/logger.service.ts << 'EOF'
import { Injectable, LoggerService as NestLoggerService } from '@nestjs/common';
import * as winston from 'winston';

@Injectable()
export class LoggerService implements NestLoggerService {
  private logger: winston.Logger;

  constructor() {
    this.logger = winston.createLogger({
      level: process.env.LOG_LEVEL || 'debug',
      format: winston.format.combine(
        winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
        winston.format.errors({ stack: true }),
        winston.format.splat(),
        winston.format.printf(({ timestamp, level, message, context, stack }) => {
          const ctx = context ? `[${context}]` : '[System]';
          const errorMsg = stack ? `\n${stack}` : '';
          return `${timestamp} [${level.toUpperCase()}] ${ctx} ${message}${errorMsg}`;
        })
      ),
      defaultMeta: { service: 'qnewproject-api' },
      transports: [
        new winston.transports.Console(),
        new winston.transports.File({
          filename: 'logs/error.log',
          level: 'error',
        }),
        new winston.transports.File({
          filename: 'logs/combined.log',
        }),
      ],
    });
  }

  log(message: string, context?: string) {
    this.logger.info(message, { context });
  }

  error(message: string, trace?: string, context?: string) {
    this.logger.error(message, { context, stack: trace });
  }

  warn(message: string, context?: string) {
    this.logger.warn(message, { context });
  }

  debug(message: string, context?: string) {
    this.logger.debug(message, { context });
  }

  verbose(message: string, context?: string) {
    this.logger.debug(message, { context });
  }
}
EOF

# Backend logger.module.ts
cat > backend/src/common/logger/logger.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { LoggerService } from './logger.service';

@Module({
  providers: [LoggerService],
  exports: [LoggerService],
})
export class LoggerModule {}
EOF

# Backend logging.interceptor.ts
cat > backend/src/common/interceptors/logging.interceptor.ts << 'EOF'
import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { LoggerService } from '../logger/logger.service';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  constructor(private readonly logger: LoggerService) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const { method, url, headers } = request;
    const start = Date.now();

    return next.handle().pipe(
      tap((res) => {
        const response = context.switchToHttp().getResponse();
        const duration = Date.now() - start;
        const { statusCode } = response;

        this.logger.log(
          `HTTP ${method} ${url} - Status: ${statusCode} - Duration: ${duration}ms`,
          'HttpRequest'
        );
      })
    );
  }
}
EOF

# Backend error.interceptor.ts
cat > backend/src/common/interceptors/error.interceptor.ts << 'EOF'
import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  HttpException,
} from '@nestjs/common';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { LoggerService } from '../logger/logger.service';

@Injectable()
export class ErrorInterceptor implements NestInterceptor {
  constructor(private readonly logger: LoggerService) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();

    return next.handle().pipe(
      catchError((error) => {
        const { method, url } = request;

        if (error instanceof HttpException) {
          this.logger.warn(
            `HTTP ${method} ${url} - ${error.getStatus()} - ${error.message}`,
            'HttpError'
          );
        } else {
          this.logger.error(
            `HTTP ${method} ${url} - ${error.message}`,
            error.stack,
            'HttpError'
          );
        }

        return throwError(() => error);
      })
    );
  }
}
EOF

# Backend database.module.ts
cat > backend/src/database/database.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { getDataSourceConfig } from './datasource';

@Module({
  imports: [
    TypeOrmModule.forRoot(getDataSourceConfig()),
  ],
})
export class DatabaseModule {}
EOF

# Backend datasource.ts
cat > backend/src/database/datasource.ts << 'EOF'
import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import { DataSource, DataSourceOptions } from 'typeorm';
import * as path from 'path';

export const getDataSourceConfig = (): TypeOrmModuleOptions => ({
  type: 'mariadb',
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '3306'),
  username: process.env.DB_USERNAME || 'root',
  password: process.env.DB_PASSWORD || 'password',
  database: process.env.DB_DATABASE || 'qnewproject',
  entities: [path.join(__dirname, '../**/*.entity.{ts,js}')],
  synchronize: false,
  logging: process.env.LOG_LEVEL === 'debug',
  migrationsRun: true,
  migrations: [path.join(__dirname, './migrations/*.{ts,js}')],
});

const dataSourceOptions: DataSourceOptions = {
  type: 'mariadb',
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '3306'),
  username: process.env.DB_USERNAME || 'root',
  password: process.env.DB_PASSWORD || 'password',
  database: process.env.DB_DATABASE || 'qnewproject',
  entities: [path.join(__dirname, '../**/*.entity.{ts,js}')],
  synchronize: false,
  logging: false,
  migrations: [path.join(__dirname, './migrations/*.{ts,js}')],
};

export const AppDataSource = new DataSource(dataSourceOptions);
EOF

# Backend health controller
cat > backend/src/modules/health/health.controller.ts << 'EOF'
import { Controller, Get } from '@nestjs/common';
import { HealthService } from './health.service';

@Controller('health')
export class HealthController {
  constructor(private readonly healthService: HealthService) {}

  @Get()
  check() {
    return this.healthService.check();
  }
}
EOF

# Backend health service
cat > backend/src/modules/health/health.service.ts << 'EOF'
import { Injectable } from '@nestjs/common';

@Injectable()
export class HealthService {
  check() {
    return {
      status: 'ok',
      timestamp: new Date().toISOString(),
    };
  }
}
EOF

# Backend health module
cat > backend/src/modules/health/health.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { HealthController } from './health.controller';
import { HealthService } from './health.service';

@Module({
  controllers: [HealthController],
  providers: [HealthService],
})
export class HealthModule {}
EOF

# Backend docker-compose.yml
cat > backend/docker-compose.yml << 'EOF'
version: '3.8'

services:
  mariadb:
    image: mariadb:11
    container_name: qnewproject-mariadb
    environment:
      MARIADB_ROOT_PASSWORD: password
      MARIADB_DATABASE: qnewproject
    ports:
      - '3306:3306'
    volumes:
      - mariadb_data:/var/lib/mysql
    networks:
      - qnewproject

volumes:
  mariadb_data:

networks:
  qnewproject:
    driver: bridge
EOF

touch backend/src/database/migrations/.gitkeep

# ========================
# FRONTEND - ANGULAR
# ========================
echo "🎨 Creando FRONTEND (Angular)..."
mkdir -p frontend/src/app/{core/services,shared/{components,pipes,directives,services},layout/main-layout,modules}
mkdir -p frontend/src/{assets,styles}

# Frontend .eslintrc.json
cat > frontend/.eslintrc.json << 'EOF'
{
  "$schema": "./node_modules/@angular-eslint/eslint-plugin/src/schemas/eslintrc.json",
  "extends": [
    "plugin:@angular-eslint/recommended",
    "plugin:@angular-eslint/template/recommended",
    "plugin:prettier/recommended"
  ],
  "overrides": [
    {
      "files": ["*.ts"],
      "parserOptions": {
        "project": ["tsconfig.json"],
        "createDefaultProgram": true
      },
      "extends": [
        "plugin:@angular-eslint/recommended",
        "plugin:@angular-eslint/template/recommended",
        "plugin:prettier/recommended"
      ],
      "rules": {
        "@angular-eslint/directive-selector": [
          "error",
          {
            "type": "attribute",
            "prefix": "app",
            "style": "camelCase"
          }
        ],
        "@angular-eslint/component-selector": [
          "error",
          {
            "type": "element",
            "prefix": "app",
            "style": "kebab-case"
          }
        ]
      }
    },
    {
      "files": ["*.html"],
      "extends": [
        "plugin:@angular-eslint/template/recommended",
        "plugin:prettier/recommended"
      ]
    }
  ]
}
EOF

# Frontend .prettierrc
cp .prettierrc frontend/.prettierrc

# Frontend tsconfig.json
cat > frontend/tsconfig.json << 'EOF'
{
  "extends": "../tsconfig.base.json",
  "compilerOptions": {
    "outDir": "./out-tsc/prod",
    "types": [],
    "baseUrl": "./",
    "paths": {
      "@shared/common": ["../shared/shared-common/src/public-api.ts"],
      "@shared/front": ["../shared/shared-front/src/public-api.ts"],
      "@core/*": ["src/app/core/*"],
      "@shared/*": ["src/app/shared/*"],
      "@layout/*": ["src/app/layout/*"],
      "@modules/*": ["src/app/modules/*"]
    }
  },
  "files": ["src/main.ts"],
  "include": ["src/**/*.d.ts"]
}
EOF

# Frontend tsconfig.app.json
cat > frontend/tsconfig.app.json << 'EOF'
{
  "extends": "./tsconfig.json",
  "compilerOptions": {
    "outDir": "./out-tsc/app",
    "types": []
  },
  "files": ["src/main.ts"],
  "include": ["src/**/*.d.ts"]
}
EOF

# Frontend angular.json
cat > frontend/angular.json << 'EOF'
{
  "$schema": "./node_modules/@angular/cli/lib/config/schema.json",
  "version": 1,
  "newProjectRoot": "projects",
  "projects": {
    "frontend": {
      "projectType": "application",
      "schematics": {
        "@schematics/angular:component": {
          "style": "scss"
        }
      },
      "root": "",
      "sourceRoot": "src",
      "prefix": "app",
      "architect": {
        "build": {
          "builder": "@angular-devkit/build-angular:browser",
          "options": {
            "outputPath": "dist/frontend",
            "index": "src/index.html",
            "main": "src/main.ts",
            "polyfills": ["zone.js"],
            "tsConfig": "tsconfig.app.json",
            "assets": ["src/favicon.ico", "src/assets"],
            "styles": [
              "src/styles/styles.scss",
              "src/styles/material-theme.scss"
            ],
            "scripts": [],
            "localize": true
          },
          "configurations": {
            "production": {
              "budgets": [
                {
                  "type": "initial",
                  "maximumWarning": "500kb",
                  "maximumError": "1mb"
                },
                {
                  "type": "anyComponentStyle",
                  "maximumWarning": "2kb",
                  "maximumError": "4kb"
                }
              ],
              "outputHashing": "all"
            },
            "development": {
              "buildOptimizer": false,
              "optimization": false,
              "vendorChunk": true,
              "extractLicenses": false,
              "sourceMap": true,
              "namedChunks": true
            }
          },
          "defaultConfiguration": "production"
        },
        "serve": {
          "builder": "@angular-devkit/build-angular:dev-server",
          "configurations": {
            "production": {
              "buildTarget": "frontend:build:production"
            },
            "development": {
              "buildTarget": "frontend:build:development"
            }
          },
          "defaultConfiguration": "development"
        },
        "extract-i18n": {
          "builder": "@angular-devkit/build-angular:extract-i18n",
          "options": {
            "buildTarget": "frontend:build"
          }
        },
        "lint": {
          "builder": "@angular-eslint/builder:lint",
          "options": {
            "lintFilePatterns": [
              "src/**/*.ts",
              "src/**/*.html"
            ]
          }
        }
      }
    }
  },
  "cli": {
    "analytics": false,
    "defaultCollection": "@angular-eslint/schematics",
    "strict": true
  }
}
EOF

# Frontend package.json
cat > frontend/package.json << 'EOF'
{
  "name": "@qnewproject/frontend",
  "version": "1.0.0",
  "description": "QNewProject Frontend - Angular + Material 3",
  "scripts": {
    "ng": "ng",
    "start": "ng serve",
    "build": "ng build",
    "build:prod": "ng build --configuration production",
    "build:i18n-es": "ng build --configuration=es",
    "build:i18n-en": "ng build --configuration=en",
    "lint": "ng lint --fix",
    "format": "prettier --write \"src/**/*.{ts,html,scss}\"",
    "extract-i18n": "ng extract-i18n"
  },
  "private": true,
  "dependencies": {
    "@angular/animations": "^17.0.0",
    "@angular/common": "^17.0.0",
    "@angular/compiler": "^17.0.0",
    "@angular/core": "^17.0.0",
    "@angular/forms": "^17.0.0",
    "@angular/material": "^17.0.0",
    "@angular/platform-browser": "^17.0.0",
    "@angular/platform-browser-dynamic": "^17.0.0",
    "@angular/router": "^17.0.0",
    "rxjs": "^7.8.0",
    "tslib": "^2.6.0",
    "zone.js": "^0.14.0",
    "lodash-es": "^4.17.21"
  },
  "devDependencies": {
    "@angular-devkit/build-angular": "^17.0.0",
    "@angular-eslint/builder": "^17.0.0",
    "@angular-eslint/eslint-plugin": "^17.0.0",
    "@angular-eslint/eslint-plugin-template": "^17.0.0",
    "@angular-eslint/schematics": "^17.0.0",
    "@angular-eslint/template-parser": "^17.0.0",
    "@angular/cli": "^17.0.0",
    "@angular/compiler-cli": "^17.0.0",
    "@types/lodash-es": "^4.17.12",
    "@types/node": "^20.10.0",
    "@typescript-eslint/eslint-plugin": "^6.13.0",
    "@typescript-eslint/parser": "^6.13.0",
    "eslint": "^8.54.0",
    "eslint-config-prettier": "^9.0.0",
    "eslint-plugin-prettier": "^5.0.0",
    "prettier": "^3.1.0",
    "typescript": "^5.3.0"
  }
}
EOF

# Frontend main.ts
cat > frontend/src/main.ts << 'EOF'
import { bootstrapApplication } from '@angular/platform-browser';
import { AppComponent } from './app/app.component';
import { appConfig } from './app/app.config';

bootstrapApplication(AppComponent, appConfig).catch((err) =>
  console.error(err)
);
EOF

# Frontend app.config.ts
cat > frontend/src/app/app.config.ts << 'EOF'
import { ApplicationConfig, importProvidersFrom } from '@angular/core';
import { provideRouter } from '@angular/router';
import { provideAnimations } from '@angular/platform-browser/animations';
import { HttpClientModule } from '@angular/common/http';
import { routes } from './app.routes';

export const appConfig: ApplicationConfig = {
  providers: [
    provideRouter(routes),
    provideAnimations(),
    importProvidersFrom(HttpClientModule),
  ],
};
EOF

# Frontend app.routes.ts
cat > frontend/src/app/app.routes.ts << 'EOF'
import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    loadComponent: () =>
      import('./layout/main-layout/main-layout.component').then(
        (m) => m.MainLayoutComponent
      ),
    children: [],
  },
];
EOF

# Frontend app.component.ts
cat > frontend/src/app/app.component.ts << 'EOF'
import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
})
export class AppComponent {}
EOF

# Frontend app.component.html
cat > frontend/src/app/app.component.html << 'EOF'
<router-outlet></router-outlet>
EOF

# Frontend app.component.scss
touch frontend/src/app/app.component.scss

# Frontend main-layout.component.ts
cat > frontend/src/app/layout/main-layout/main-layout.component.ts << 'EOF'
import { Component, inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';
import { ThemeService } from '@core/services/theme.service';
import { RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-main-layout',
  standalone: true,
  imports: [
    CommonModule,
    MatToolbarModule,
    MatIconModule,
    MatButtonModule,
    MatSlideToggleModule,
    RouterOutlet,
  ],
  templateUrl: './main-layout.component.html',
  styleUrls: ['./main-layout.component.scss'],
})
export class MainLayoutComponent implements OnInit {
  private themeService = inject(ThemeService);

  isDarkMode$ = this.themeService.isDarkMode$;

  ngOnInit() {
    this.themeService.init();
  }

  toggleTheme() {
    this.themeService.toggleTheme();
  }
}
EOF

# Frontend main-layout.component.html
cat > frontend/src/app/layout/main-layout/main-layout.component.html << 'EOF'
<mat-toolbar color="primary" class="app-toolbar">
  <div class="toolbar-content">
    <span class="logo">QNewProject</span>
    <div class="spacer"></div>
    <button mat-icon-button (click)="toggleTheme()" class="theme-toggle">
      <mat-icon>{{ (isDarkMode$ | async) ? 'light_mode' : 'dark_mode' }}</mat-icon>
    </button>
  </div>
</mat-toolbar>

<div class="content">
  <router-outlet></router-outlet>
</div>
EOF

# Frontend main-layout.component.scss
cat > frontend/src/app/layout/main-layout/main-layout.component.scss << 'EOF'
.app-toolbar {
  position: sticky;
  top: 0;
  z-index: 100;
}

.toolbar-content {
  display: flex;
  align-items: center;
  width: 100%;
  padding: 0 1rem;
}

.logo {
  font-size: 1.25rem;
  font-weight: 600;
}

.spacer {
  flex: 1 1 auto;
}

.theme-toggle {
  margin-left: 1rem;
}

.content {
  padding: 2rem;
}
EOF

# Frontend theme.service.ts
cat > frontend/src/app/core/services/theme.service.ts << 'EOF'
import { Injectable, inject } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { DOCUMENT } from '@angular/common';

@Injectable({
  providedIn: 'root',
})
export class ThemeService {
  private document = inject(DOCUMENT);

  private darkModeSubject = new BehaviorSubject<boolean>(false);
  public isDarkMode$: Observable<boolean> = this.darkModeSubject.asObservable();

  init() {
    const isDarkMode = localStorage.getItem('darkMode') === 'true';
    this.setTheme(isDarkMode);
  }

  toggleTheme() {
    this.setTheme(!this.darkModeSubject.value);
  }

  private setTheme(isDarkMode: boolean) {
    const htmlElement = this.document.documentElement;

    if (isDarkMode) {
      htmlElement.classList.add('dark-theme');
    } else {
      htmlElement.classList.remove('dark-theme');
    }

    localStorage.setItem('darkMode', isDarkMode.toString());
    this.darkModeSubject.next(isDarkMode);
  }
}
EOF

# Frontend styles.scss
cat > frontend/src/styles/styles.scss << 'EOF'
@use '@angular/material' as mat;

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html,
body {
  width: 100%;
  height: 100%;
  font-family: Roboto, 'Helvetica Neue', sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

html {
  @include mat.core();
}

code {
  font-family: source-code-pro, Menlo, Monaco, Consolas, 'Courier New',
    monospace;
}

.spacer {
  flex: 1 1 auto;
}
EOF

# Frontend material-theme.scss
cat > frontend/src/styles/material-theme.scss << 'EOF'
@use '@angular/material' as mat;
@use '@angular/material/prebuilt-themes/indigo-pink.css';

$primary: mat.define-palette(mat.$purple-palette);
$accent: mat.define-palette(mat.$pink-palette, A200, A100, A400);
$warn: mat.define-palette(mat.$red-palette);

$light-theme: mat.define-light-theme(
  (
    color: (
      primary: $primary,
      accent: $accent,
      warn: $warn,
    ),
  )
);

$dark-theme: mat.define-dark-theme(
  (
    color: (
      primary: $primary,
      accent: $accent,
      warn: $warn,
    ),
  )
);

@include mat.all-component-colors($light-theme);

.dark-theme {
  @include mat.all-component-colors($dark-theme);
}
EOF

# Frontend index.html
cat > frontend/src/index.html << 'EOF'
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>QNewProject</title>
  <base href="/">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="icon" type="image/x-icon" href="favicon.ico">
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
</head>
<body>
  <app-root></app-root>
</body>
</html>
EOF

touch frontend/src/assets/.gitkeep

# ========================
# SHARED LIBRARIES
# ========================
echo "📚 Creando SHARED Libraries..."

# shared-common
mkdir -p shared/shared-common/src/{dto,interfaces,types,utils,constants}

cat > shared/shared-common/package.json << 'EOF'
{
  "name": "@qnewproject/shared-common",
  "version": "1.0.0",
  "description": "Shared common types, DTOs, and utilities",
  "private": true,
  "main": "dist/public-api.js",
  "types": "dist/public-api.d.ts",
  "scripts": {
    "build": "tsc"
  },
  "devDependencies": {
    "typescript": "^5.3.3"
  },
  "dependencies": {
    "lodash-es": "^4.17.21"
  }
}
EOF

cat > shared/shared-common/tsconfig.json << 'EOF'
{
  "extends": "../../tsconfig.base.json",
  "compilerOptions": {
    "outDir": "./dist",
    "rootDir": "./src",
    "baseUrl": "./src",
    "module": "ES2022",
    "target": "ES2022",
    "lib": ["ES2022"]
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

cat > shared/shared-common/src/public-api.ts << 'EOF'
// DTOs
export * from './dto/index';

// Interfaces
export * from './interfaces/index';

// Types
export * from './types/index';

// Utils
export * from './utils/index';

// Constants
export * from './constants/index';
EOF

cat > shared/shared-common/src/dto/index.ts << 'EOF'
// Export DTOs here
// export { CreateUserDto } from './create-user.dto';
EOF

cat > shared/shared-common/src/interfaces/index.ts << 'EOF'
// Export Interfaces here
// export { IUser } from './user.interface';
EOF

cat > shared/shared-common/src/types/index.ts << 'EOF'
// Export Types here
// export type TUser = { id: number; name: string };
EOF

cat > shared/shared-common/src/utils/index.ts << 'EOF'
// Export Utilities here
// export { formatDate } from './date.util';
EOF

cat > shared/shared-common/src/constants/index.ts << 'EOF'
// Export Constants here
// export const API_TIMEOUT = 30000;
EOF

# shared-front
mkdir -p shared/shared-front/src/{components,pipes,directives,services}

cat > shared/shared-front/package.json << 'EOF'
{
  "name": "@qnewproject/shared-front",
  "version": "1.0.0",
  "description": "Shared Angular components and services",
  "private": true,
  "scripts": {
    "build": "echo 'Build script needed'"
  },
  "devDependencies": {
    "@angular/core": "^17.0.0",
    "@angular/material": "^17.0.0",
    "typescript": "^5.3.3"
  }
}
EOF

cat > shared/shared-front/src/public-api.ts << 'EOF'
// Components
export * from './components/index';

// Pipes
export * from './pipes/index';

// Directives
export * from './directives/index';

// Services
export * from './services/index';
EOF

cat > shared/shared-front/src/components/index.ts << 'EOF'
// Export Angular components here
// export { MyComponent } from './my-component/my-component.component';
EOF

cat > shared/shared-front/src/pipes/index.ts << 'EOF'
// Export custom pipes here
// export { MyPipe } from './my-pipe.pipe';
EOF

cat > shared/shared-front/src/directives/index.ts << 'EOF'
// Export directives here
// export { MyDirective } from './my-directive.directive';
EOF

cat > shared/shared-front/src/services/index.ts << 'EOF'
// Export services here
// export { MyService } from './my-service.service';
EOF

# shared-back
mkdir -p shared/shared-back/src/{controllers,services,decorators}

cat > shared/shared-back/package.json << 'EOF'
{
  "name": "@qnewproject/shared-back",
  "version": "1.0.0",
  "description": "Shared NestJS controllers, services, and decorators",
  "private": true,
  "main": "dist/public-api.js",
  "types": "dist/public-api.d.ts",
  "scripts": {
    "build": "tsc"
  },
  "devDependencies": {
    "@nestjs/common": "^10.3.0",
    "typescript": "^5.3.3"
  }
}
EOF

cat > shared/shared-back/tsconfig.json << 'EOF'
{
  "extends": "../../tsconfig.base.json",
  "compilerOptions": {
    "outDir": "./dist",
    "rootDir": "./src",
    "baseUrl": "./src",
    "module": "commonjs",
    "target": "ES2021",
    "lib": ["ES2021"]
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

cat > shared/shared-back/src/public-api.ts << 'EOF'
// Controllers
export * from './controllers/index';

// Services
export * from './services/index';

// Decorators
export * from './decorators/index';
EOF

cat > shared/shared-back/src/controllers/index.ts << 'EOF'
// Export controllers here
// export { MyController } from './my-controller';
EOF

cat > shared/shared-back/src/services/index.ts << 'EOF'
// Export services here
// export { MyService } from './my-service';
EOF

cat > shared/shared-back/src/decorators/index.ts << 'EOF'
// Export decorators here
// export { MyDecorator } from './my-decorator';
EOF

echo ""
echo "✅ ¡Estructura completada!"
echo ""
echo "📁 Carpetas creadas:"
ls -la | grep '^d' | awk '{print "   " $NF}'
echo ""
echo "🎯 Próximos pasos:"
echo "   1. cd backend && pnpm install"
echo "   2. cd frontend && pnpm install"
echo "   3. pnpm install (desde root para workspace)"
echo ""
echo "🚀 Para desarrollar:"
echo "   Backend:  cd backend && pnpm start:dev"
echo "   Frontend: cd frontend && pnpm start"
echo "   Database: docker-compose -f backend/docker-compose.yml up -d"
echo ""
