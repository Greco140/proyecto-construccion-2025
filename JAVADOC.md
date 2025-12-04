# Documentación JavaDoc - DynaDocs

## 📚 Generación de JavaDoc

La documentación JavaDoc del proyecto se genera automáticamente durante el proceso de compilación y se copia a la carpeta `static` para que esté disponible cuando la aplicación esté en ejecución.

### Generar la documentación

Para generar la documentación JavaDoc, ejecuta uno de los siguientes comandos:

```bash
# Generar solo JavaDoc
mvn javadoc:javadoc

# Generar JavaDoc y compilar el proyecto
mvn clean package

# Generar JavaDoc sin ejecutar tests
mvn clean package -DskipTests
```

### Acceder a la documentación

#### En desarrollo local

1. Ejecuta la aplicación:
   ```bash
   mvn spring-boot:run
   ```

2. abrir en el navegador:
   ```
   http://localhost:8080/javadoc/index.html
   ```

#### En servidor de producción

con la aplicacion hosteada en un servidor:
```
https://tu-dominio.com/javadoc/index.html
```

### Ubicación de los archivos

- **Código fuente**: `src/main/java/`
- **JavaDoc generado**: `target/generated-docs/javadoc/`
- **JavaDoc en el JAR**: `target/classes/static/javadoc/`

### Configuración

La configuración de JavaDoc se encuentra en el archivo `pom.xml`:

- **Plugin**: `maven-javadoc-plugin` versión 3.6.3
- **Nivel de visibilidad**: `public`
- **Codificación**: UTF-8
- **Versión de Java**: 21

### Estructura de la documentación

La documentación incluye:

- **Controladores** (`controllers/`): Endpoints REST de la API
- **Servicios** (`services/`): Lógica de negocio
- **Repositorios** (`repositories/`): Acceso a datos
- **Modelos** (`models/`): Entidades JPA
- **Seguridad** (`security/`): Autenticación JWT
- **Configuración** (`config/`): Configuración de Spring

### Notas importantes

- La documentación se regenera automáticamente con cada compilación
- No es necesario commitear los archivos generados en `target/`
- La documentación está disponible sin autenticación cuando la aplicación está corriendo
- Para personalizar la documentación, edita los comentarios JavaDoc en el código fuente
