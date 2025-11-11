# 📝 Documento de Especificación de Clases y Funciones (DynaDocs)

Este documento detalla el contrato de cada componente de la arquitectura Controller-Service-Model para la aplicación DynaDocs. Es la referencia obligatoria para el desarrollo del Backend y el Frontend.

---

## 1. `model` (Estructura de los Datos)

Define las clases que transportan y persisten los datos.

### 1.1. `GenerationRequest` (DTO - Request Body)

Propósito: Recibir el JSON del Frontend para la generación de PDF (Fase 1).

| Atributo | Tipo | Propósito |
| :--- | :--- | :--- |
| **`templateType`** | `String` | **RF-02**: Identificador de la plantilla a utilizar (Ej: "Factura", "Reporte"). |
| **`data`** | `Map<String, String>` | **RF-03, RF-04**: Pares clave-valor con la información dinámica para la plantilla. |

### 1.2. `User` (Entidad JPA - Fase 2)

Propósito: Representar los usuarios persistidos en la base de datos.

| Atributo | Tipo | Propósito |
| :--- | :--- | :--- |
| **`username`** | `String` | Identificador único del usuario (usado para login). |
| **`password`** | `String` | Contraseña (almacenada encriptada). |
| **`role`** | `Enum` (Role) | Permisos del usuario (`USUARIO` o `ADMIN`). |

### 1.3. `Template` (Entidad JPA - Fase 2)

Propósito: Almacenar el contenido HTML/CSS de las plantillas.

| Atributo | Tipo | Propósito |
| :--- | :--- | :--- |
| **`name`** | `String` | Nombre de la plantilla para el catálogo. |
| **`content`** | `String` | Contenido HTML/CSS de la plantilla con *placeholders*. |
| **`owner`** | `User` | Relación con el usuario que la creó o gestiona. |

---

## 2. `controller` (API REST Endpoints)

Actúan como la interfaz HTTP del sistema. **Debe delegar toda la lógica al servicio.**

### 2.1. `PdfController`

| Endpoint | Método | Seguridad | Descripción y Contrato |
| :--- | :--- | :--- | :--- |
| **`POST /api/generate`** | `generateDocument(GenerationRequest)` | **Público** (Temporalmente) | **RF-03, RF-05**: Inicia la generación y descarga del PDF. |
| **Retorna (Éxito)** | `200 OK`, `ResponseEntity<byte[]>` | Archivo PDF binario, con cabecera `Content-Disposition: attachment`. |
| **Retorna (Error)** | `400 Bad Request` | Fallo de validación de datos (RF-08) o formato JSON incorrecto. |
| **Retorna (Error)** | `500 Internal Server Error` | Fallo interno durante el proceso de conversión de PDF (RNF-03). |

### 2.2. `AuthController` (Fase 2)

| Endpoint | Método | Seguridad | Descripción y Contrato |
| :--- | :--- | :--- | :--- |
| **`POST /api/register`** | `registerUser(User user)` | Público | Registra un nuevo `User`. **Retorna:** `201 Created` o `400 Bad Request`. |
| **`POST /api/login`** | `authenticateUser(LoginRequest)` | Público | Inicia sesión. **Retorna:** `200 OK` con un objeto `JwtResponse` (contiene el Token JWT). |

### 2.3. `TemplateController` (Fase 2)

| Endpoint | Método | Seguridad | Descripción y Contrato |
| :--- | :--- | :--- | :--- |
| **`POST /api/templates`** | `createTemplate(Template template)` | **JWT Requerido** | Crea y guarda una nueva plantilla en la base de datos. **Retorna:** `201 Created` con la entidad `Template` guardada. |

---

## 3. `service` (Lógica de Negocio)

Contienen la lógica de negocio pura y la validación (RF-08). Independientes del protocolo HTTP.

### 3.1. `PdfGenerationService` (Fase 1 MVP)

| Método | Contrato de Datos | Responsabilidad Principal |
| :--- | :--- | :--- |
| **`+ generatePdf(request)`** | **Recibe:** `GenerationRequest`. **Retorna:** `byte[]`. | **RF-04**: Coordinar la fusión de datos (`applyPlaceholders`) y la conversión final a PDF (`convertHtmlToPdfBytes`). |
| **`- validateData(request)`** | **Recibe:** `GenerationRequest`. **Retorna:** `void` o lanza `IllegalArgumentException`. | **RF-08**: Valida que los datos sean coherentes y estén completos. |
| **`- convertHtmlToPdfBytes(html)`**| **Recibe:** `String` (HTML fusionado). **Retorna:** `byte[]`. | Usa OpenPDF/ITextRenderer para la conversión binaria (RNF-03). |

### 3.2. `AuthService` (Fase 2)

| Método | Contrato de Datos | Responsabilidad Principal |
| :--- | :--- | :--- |
| **`+ register(user)`** | **Recibe:** `User`. **Retorna:** `User`. | Lógica de negocio para guardar el usuario (incluye encriptación). |
| **`+ login(credentials)`** | **Recibe:** `LoginRequest`. **Retorna:** `String` (JWT). | Valida las credenciales y genera el token de seguridad. |

### 3.3. `TemplateService` (Fase 2)

| Método | Contrato de Datos | Responsabilidad Principal |
| :--- | :--- | :--- |
| **`+ save(template)`** | **Recibe:** `Template`. **Retorna:** `Template`. | Persiste la plantilla en la base de datos (CRUD). |
| **`+ findAllByRole()`**| **Recibe:** (Contexto de Usuario). **Retorna:** `List<Template>`. | Consulta la BD, aplicando filtros de rol y propiedad para seguridad de datos. |