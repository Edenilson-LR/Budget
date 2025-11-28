# SmartBudget

Aplicación de presupuesto personal desarrollada en React (web) y React Native (móvil).

## Características

- ✅ Gestión completa de transacciones (ingresos y gastos)
- ✅ Gestión de cuentas (efectivo, banco, tarjeta, cripto)
- ✅ Gestión de categorías personalizables
- ✅ Gestión de monedas múltiples
- ✅ Gráficos interactivos (pie, barras, área)
- ✅ Modo oscuro
- ✅ Exportación a CSV
- ✅ Almacenamiento local persistente

## Requisitos

- Node.js >= 18.0.0
- npm o yarn

## Instalación

1. Instala las dependencias:
```bash
npm install
```

## Ejecutar la aplicación

### Web (React)
```bash
npm run web
```

### Android (React Native)
```bash
npm run android
```

### iOS (React Native)
```bash
npm run ios
```

## Estructura del Proyecto

```
src/
├── models/              # Modelos de datos TypeScript
├── services/            # Servicios (almacenamiento, etc)
├── context/             # React Context (state management)
├── components/          # Componentes reutilizables
├── screens/             # Pantallas principales
├── utils/               # Utilidades
└── App.tsx              # Componente principal
```

## Tecnologías Utilizadas

- React (Web)
- React Native (Móvil)
- TypeScript
- React Navigation
- AsyncStorage (Almacenamiento local)
- React Native Chart Kit (Gráficos)
- date-fns (Formateo de fechas)

## Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.
