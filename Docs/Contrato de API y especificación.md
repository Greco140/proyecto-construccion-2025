# 📝 Documento de Especificación de Clases y Funciones (DynaDocs)

Este documento detalla el contrato de cada componente de la arquitectura final C-S-R (Controller-Service-Repository) para la aplicación DynaDocs.

---

## 1. 📦 Paquete `model` (Estructura de Datos)

Define las clases que transportan y persisten los datos.

### 1.1. `GenerationRequest` (DTO - Request Body)

Propósito: Recibir el JSON del Frontend para la generación de PDF.

| Atrib | Tipo | Propósito |
| :--- | :--- | :--- |
| **`templateType`** | `String` | **RF-02**: Identificador de la plantilla a utilizar (Ej: "Factura", "Perfil"). |
| **`data`** | `Map<String, Object>` | **RF-03, RF-04**: Pares clave-valor con la información dinámica. <br><br> **Manejo de Imágenes**: Si una plantilla requiere una imagen (ej. `{{foto_usuario}}`), el cliente (Flutter) debe convertir la imagen seleccionada a **Base64** y enviarla como un `String` dentro de este mapa. (Ej: `"foto_usuario": "data:image/jpeg;base64,iVBOR..."`). |

### 1.2. `User` (Entidad JPA: `@Entity`)

Propósito: Representar los usuarios persistidos en la base de datos.

| Atributo | Tipo | Propósito |
| :--- | :--- | :--- |
| **`username`** | `String` | Identificador único del usuario (usado para login). |
| **`password`** | `String` | Contraseña (almacenada encriptada). |
| **`role`** | `Role` | Relación con el Enum de permisos. |

### 1.3. `Template` (Entidad JPA: `@Entity`)

Propósito: Almacenar el contenido HTML/CSS de las plantillas.

| Atributo | Tipo | Propósito |
| :--- | :--- | :--- |
| **`name`** | `String` | Nombre de la plantilla para el catálogo (Ej: "Factura", "Perfil"). |
| **`content`** | `String` (TEXT) | Contenido HTML/CSS de la plantilla con *placeholders* (Ej: `...<img src="{{foto_usuario}}"/>...`). |
| **`owner`** | `User` | Relación con el usuario que la creó (si es privada). |
| **`isPublic`** | `boolean` | Define si la plantilla es pública (gestionada por `CREADOR`/`ADMIN`) o privada (gestionada por `USUARIO`). |

### 1.4. `Role` (Enum)

Propósito: Definir los niveles de autorización del sistema.

| Valor | Responsabilidad |
| :--- | :--- |
| **`USUARIO`** | Puede *usar* plantillas (públicas y privadas) y *gestionar* (CRUD) sus plantillas privadas. |
| **`CREADOR`** | Puede *usar* plantillas y *gestionar* (CRUD) plantillas públicas para el "mercado". |
| **`ADMIN`** | Gestiona el sistema (usuarios, roles) y puede *gestionar* (CRUD) todas las plantillas (públicas y privadas). |

---

## 2. 🌐 Paquete `controller` (API REST Endpoints)

Actúan como la interfaz HTTP del sistema. Delegan toda la lógica al servicio.

### 2.1. `PdfController`

| Endpoint | Método | Seguridad (Nivel 1) | Descripción y Contrato |
| :--- | :--- | :--- | :--- |
| **`POST /api/generate`** | `generateDocument(GenerationRequest)` | Autenticado (Cualquier Rol) | **RF-03, RF-05**: Inicia la generación y descarga del PDF. El `PdfGenerationService` aplicará la lógica de negocio (Nivel 2) para asegurar que el usuario tenga acceso a la plantilla solicitada. |
| **Retorna (Éxito)** | `200 OK`, `ResponseEntity<byte[]>` | Archivo PDF binario, con cabecera `Content-Disposition: attachment`. |
| **Retorna (Error)** | `400 Bad Request` | Fallo de validación de datos (RF-08) o JSON incorrecto. |

### 2.2. `AuthController`

| Endpoint | Método | Seguridad (Nivel 1) | Descripción y Contrato |
| :--- | :--- | :--- | :--- |
| **`POST /api/register`** | `registerUser(User user)` | Público | Registra un nuevo `User`. **Retorna:** `201 Created`. |
| **`POST /api/login`** | `authenticateUser(LoginRequest)` | Público | Inicia sesión. **Retorna:** `200 OK` con un `JwtResponse` (Token JWT). |

### 2.3. `TemplateController` (CRUD Completo)

| Endpoint | Método | Seguridad (Nivel 1) | Descripción y Contrato (Lógica Nivel 2 en Servicio) |
| :--- | :--- | :--- | :--- |
| **`POST /api/templates`** | `createTemplate(Template)` | **JWT Requerido** (Cualquier Rol) | Crea una nueva plantilla. El `TemplateService` (Nivel 2) asignará si es pública o privada basándose en el rol del usuario. **Retorna:** `201 Created`. |
| **`GET /api/templates`** | `getAllTemplates()` | **JWT Requerido** (Cualquier Rol) | Lista las plantillas. El `TemplateService` (Nivel 2) filtra la lista (públicas + privadas propias) basándose en el rol del usuario. **Retorna:** `200 OK` con `List<Template>`. |
| **`GET /api/templates/{id}`**| `getTemplateById(id)` | **JWT Requerido** (Cualquier Rol) | Obtiene una plantilla. El `TemplateService` (Nivel 2) verificará si el usuario tiene permiso para verla (si es pública o si es el dueño). **Retorna:** `200 OK` o `404 Not Found`. |
| **`PUT /api/templates/{id}`** | `updateTemplate(id, template)` | **JWT Requerido** (Cualquier Rol) | Actualiza una plantilla. El `TemplateService` (Nivel 2) verificará la propiedad (`owner`) o el rol (`ADMIN`/`CREADOR`) antes de permitir la actualización. **Retorna:** `200 OK`. |
| **`DELETE /api/templates/{id}`**| `deleteTemplate(id)` | **JWT Requerido** (`USUARIO` o `ADMIN`) | **Autorización Nivel 1:** Solo `USUARIO` o `ADMIN` pueden *intentar* borrar. (`CREADOR` no puede). El `TemplateService` (Nivel 2) aplicará la lógica final de propiedad. <br> **Retorna:** `204 No Content` o `403 Forbidden`. |

---

## 3. 🧠 Paquete `service` (Lógica de Negocio - Autorización Nivel 2)

Contienen la lógica de negocio pura y la validación (RF-08). Llaman a los Repositorios para la persistencia.

### 3.1. `PdfGenerationService`

| Método | Contrato de Datos | Responsabilidad Principal (Lógica Nivel 2) |
| :--- | :--- | :--- |
| **`+ generatePdf(request, authUser)`** | **Recibe:** `GenerationRequest`, `User`. **Retorna:** `byte[]`. | **RF-04**: Coordina todo el flujo. Llama a `loadTemplateByType` para cargar la plantilla. **Lógica Nivel 2:** El `loadTemplateByType` debe verificar si el `authUser` tiene permiso para *ver* esa plantilla (si es pública o es el `owner`). |
| **`- validateData(request)`** | **Recibe:** `GenerationRequest`. **Retorna:** `void`. | **RF-08**: Valida que `data` y `templateType` no estén vacíos. |
| **`- loadTemplateByType(type)`**| **Recibe:** `String`. **Retorna:** `Template`. | Llama a `TemplateRepository.findByName(type)` para buscar la plantilla. |
| **`- fuse(html, data)`** | **Recibe:** `String` (HTML), `Map`. **Retorna:** `String`. | Reemplaza los *placeholders* `{{key}}` en el HTML con los valores del `data` (incluyendo los strings Base64 de las imágenes). |
| **`- convertHtmlToPdf(html)`**| **Recibe:** `String` (HTML fusionado). **Retorna:** `byte[]`. | Usa ITextRenderer/Jsoup para la conversión binaria. |

### 3.2. `AuthService`

| Método | Contrato de Datos | Responsabilidad Principal |
| :--- | :--- | :--- |
| **`+ register(user)`** | **Recibe:** `User`. **Retorna:** `User`. | Llama al `UserRepository` para guardar el usuario (incluye encriptación). |
| **`+ login(credentials)`** | **Recibe:** `LoginRequest`. **Retorna:** `String` (JWT). | Valida credenciales y genera el token de seguridad. |

### 3.3. `TemplateService`

| Método | Contrato de Datos | Responsabilidad Principal (Lógica Nivel 2) |
| :--- | :--- | :--- |
| **`+ save(template, authUser)`** | **Recibe:** `Template`, `User`. **Retorna:** `Template`. | **Lógica Nivel 2:** Si `authUser` es `CREADOR` o `ADMIN`, marca `isPublic=true`. Si es `USUARIO`, marca `isPublic=false` y asigna `owner=authUser`. Llama a `TemplateRepository` para guardar. |
| **`+ findAllByRole(authUser)`**| **Recibe:** `User`. **Retorna:** `List<Template>`.| **Lógica Nivel 2:** Si es `ADMIN`, devuelve todo. Si es `USUARIO` o `CREADOR`, llama a `TemplateRepository.findByIsPublicTrueOrOwner(authUser)`. |
| **`+ findById(id, authUser)`** | **Recibe:** `Long`, `User`. **Retorna:** `Template`. | **Lógica Nivel 2:** Busca la plantilla. Verifica si es pública O si `authUser` es el `owner`. Si no, lanza `AccessDeniedException`. |
| **`+ update(id, template, authUser)`**| **Recibe:** `Long`, `Template`, `User`. **Retorna:** `Template`. | **Lógica Nivel 2:** Busca la plantilla. Verifica permisos de propiedad (si es `USUARIO`) o rol (`ADMIN`/`CREADOR`) antes de guardar. |
| **`+ delete(id, authUser)`** | **Recibe:** `Long`, `User`. **Retorna:** `void`. | **Lógica Nivel 2:** <br> 1. Busca la plantilla. <br> 2. Si es pública (`isPublic=true`), verifica que `authUser` sea `ADMIN`. <br> 3. Si es privada (`isPublic=false`), verifica que `authUser` sea el `owner`. <br> 4. Si no cumple, lanza `AccessDeniedException`. Si cumple, llama a `templateRepository.deleteById(id)`. |

---

## 4. 💾 Paquete `repository` (Capa de Acceso a Datos)

Interfaces de Spring Data JPA que gestionan la comunicación con la Base de Datos.

### 4.1. `UserRepository` (Interface)

* **Extiende:** `JpaRepository<User, Long>`
* **Propósito:** Provee métodos CRUD para la entidad `User`.
* **Método Custom:** `Optional<User> findByUsername(String username);`

### 4.2. `TemplateRepository` (Interface)

* **Extiende:** `JpaRepository<Template, Long>`
* **Propósito:** Provee métodos CRUD para la entidad `Template`.
* **Método Custom:** `Optional<Template> findByName(String name);`
* **Método Custom:** `List<Template> findByIsPublicTrueOrOwner(User user);`