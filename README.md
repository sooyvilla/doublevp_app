# DoubleVP App
### Descripción

App para crear usuarios con múltiples direcciones. Permite listar, crear, editar y eliminar usuarios. Cada usuario tiene nombre, apellido, fecha de nacimiento y una lista de direcciones (país, departamento, municipio).

### Arquitectura

La aplicación sigue una arquitectura en capas inspirada en Clean Architecture:

- `core`: proveedores y configuraciones
- `data`: implementación de repositorios y mappers
- `domain`: modelos, interfaces y casos de uso 
- `presentation`: notifiers (Riverpod), páginas (UI) y widgets reutilizables. La UI usa Material 3.

### Patrones y prácticas aplicadas

- Repository Pattern
- Use-cases / Interactors
- State management
- Widgets reutilizables

### Requisitos

- Flutter y Dart instalados. Versión usada para desarrollar y probar este proyecto:

	Flutter 3.35.3 • channel stable
	Framework • revision a402d9a437 (2025-09-03)
	Engine • hash 672c59cfa87c... (2025-09-03)
	Tools • Dart 3.9.2 • DevTools 2.48.0

### Cómo ejecutar

1. Instala dependencias:

```bash
flutter pub get
```

2. Corre la app en un emulador o dispositivo:

```bash
flutter run
```

### Contribuidores
Sebastian Villa 
 - [Linkedin](https://www.linkedin.com/in/sebasvillalo/)

## Agradecimientos
Gracias a la comunidad de Flutter y a los autores de los paquetes utilizados por sus contribuciones y documentación.
