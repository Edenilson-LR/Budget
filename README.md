# SmartBudget

Aplicación de presupuesto personal desarrollada en Flutter.

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

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0

## Instalación

1. Clona el repositorio
2. Instala las dependencias:
```bash
flutter pub get
```

3. Ejecuta la aplicación:
```bash
flutter run
```

## Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada
├── models/                   # Modelos de datos
│   ├── app_data.dart
│   ├── transaction.dart
│   ├── account.dart
│   ├── category.dart
│   └── currency.dart
├── screens/                  # Pantallas principales
│   ├── home_screen.dart
│   ├── home_view.dart
│   ├── transactions_view.dart
│   ├── budget_view.dart
│   ├── settings_view.dart
│   ├── add_transaction_modal.dart
│   └── edit_item_modal.dart
├── widgets/                  # Widgets reutilizables
│   ├── custom_card.dart
│   ├── custom_button.dart
│   └── custom_input.dart
├── services/                # Servicios
│   └── storage_service.dart
├── providers/               # State management
│   └── app_data_provider.dart
└── utils/                   # Utilidades
    └── formatters.dart
```

## Uso

### Agregar Transacciones
- Toca el botón flotante (+) en cualquier pantalla principal
- Selecciona tipo (Ingreso/Gasto)
- Completa los campos requeridos
- Guarda la transacción

### Gestionar Categorías
- Ve a Configuración > Categorías
- Toca "Agregar Nueva" para crear una categoría
- Toca el ícono de editar para modificar
- Toca el ícono de eliminar para borrar (si no tiene transacciones asociadas)

### Gestionar Cuentas
- Ve a Configuración > Cuentas
- Toca "Agregar Nueva" para crear una cuenta
- Edita o elimina cuentas existentes

### Gestionar Monedas
- Ve a Configuración > Monedas
- Agrega nuevas monedas o edita las existentes

### Ver Gráficos
- Ve a la pestaña "Presupuesto"
- Cambia entre gráficos de pie, barras y área
- Visualiza el progreso de tus presupuestos por categoría

## Tecnologías Utilizadas

- Flutter
- Provider (State Management)
- SharedPreferences (Almacenamiento local)
- fl_chart (Gráficos)
- intl (Formateo de fechas y monedas)
- csv (Exportación)

## Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.
