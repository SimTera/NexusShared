# NexusShared

Librería compartida entre la aplicación **Nexus** (cliente) y **NexusServer** (servidor) que define el contrato completo del API v1.

## Características

- ✅ **Swift 6** con concurrencia estricta (`strict-concurrency=complete`)
- ✅ **100% Sendable**: Todos los tipos son seguros para concurrencia
- ✅ **Swift Package Manager**: Compatible con iOS, macOS, watchOS, tvOS y visionOS
- ✅ **Codificación estandarizada**: Fechas en ISO 8601 UTC
- ✅ **Validación compartida**: Reglas consistentes entre cliente y servidor
- ✅ **Tolerancia hacia adelante**: Permisos desconocidos se ignoran en la decodificación

## Contenido

### Models

- **Permission**: Enum con los permisos disponibles del sistema
- **APIErrorCode**: Códigos de error estandarizados
- **APIError**: Estructura de error con código y mensaje

### DTOs - Responses

- **OrganizationDTO**: Información de una organización
- **UserDTO**: Información de un usuario
- **RoleDTO**: Información de un rol con permisos
- **SessionProfile**: Perfil completo de sesión del usuario
- **AuthResponse**: Respuesta de autenticación con tokens

### DTOs - Requests

#### Auth
- **CreateOrganizationRequest**: Crear organización y admin
- **LoginRequest**: Iniciar sesión
- **RefreshRequest**: Renovar access token
- **ChangePasswordRequest**: Cambiar contraseña

#### Users
- **CreateUserRequest**: Crear usuario en la organización
- **UpdateUserRequest**: Actualizar usuario existente

#### Roles
- **CreateRoleRequest**: Crear rol personalizado
- **UpdateRoleRequest**: Actualizar rol existente

### Utilities

- **NexusJSON**: Encoder/Decoder estandarizados con ISO 8601
- **Validation**: Reglas de validación compartidas

## Uso

### En el cliente (Nexus App)

```swift
import NexusShared

// Crear un request
let loginRequest = LoginRequest(
    email: "user@example.com",
    password: "password123"
)

// Validar antes de enviar
try loginRequest.validate()

// Codificar a JSON
let data = try NexusJSON.encode(loginRequest)

// ... enviar al servidor ...

// Decodificar respuesta
let authResponse = try NexusJSON.decode(AuthResponse.self, from: responseData)

// Verificar permisos
if authResponse.session.hasPermission(.usersManage) {
    // Mostrar UI de gestión de usuarios
}
```

### En el servidor (NexusServer)

```swift
import NexusShared
import Vapor

func login(req: Request) async throws -> AuthResponse {
    // Decodificar request
    let loginRequest = try req.content.decode(LoginRequest.self)
    
    // Validar
    try loginRequest.validate()
    
    // Normalizar
    let normalized = loginRequest.normalized()
    
    // Procesar autenticación...
    let user = try await authenticate(email: normalized.email, password: normalized.password)
    
    // Crear respuesta
    let response = AuthResponse(
        accessToken: generateAccessToken(for: user),
        accessTokenExpiresAt: Date().addingTimeInterval(3600),
        refreshToken: generateRefreshToken(for: user),
        session: buildSessionProfile(for: user)
    )
    
    return response
}
```

## Validación

Todos los requests tienen métodos de validación y normalización:

```swift
let request = CreateOrganizationRequest(
    organizationName: "  My Company  ",
    adminName: "John Doe",
    adminEmail: "  JOHN@EXAMPLE.COM  ",
    adminPassword: "SecurePass123"
)

// Validar antes de enviar
try request.validate() // Lanza APIError si falla

// Normalizar (trim spaces, lowercase email)
let normalized = request.normalized()
// normalized.email == "john@example.com"
```

## Reglas de Validación

### Email
- Formato válido según regex estándar
- Se guarda en minúsculas y sin espacios
- Único en todo el sistema (global)

### Password
- Mínimo 10 caracteres
- Al menos 1 letra
- Al menos 1 número

### Nombres (organización, usuario, rol)
- 1-100 caracteres después de recortar espacios
- Nombres de rol únicos dentro de la empresa

## Permisos

```swift
public enum Permission: String, Sendable, Codable {
    case organizationManage = "organization.manage"
    case usersView = "users.view"
    case usersManage = "users.manage"
    case rolesManage = "roles.manage"
}
```

### Roles Base del Sistema

Cada organización tiene 3 roles predefinidos (`isSystem = true`):

| Rol | Permisos | Notas |
|-----|----------|-------|
| **Administrador** | Todos | No se puede borrar ni quitar permisos |
| **Técnico** | `users.view` | No se puede borrar (se ampliará en v2) |
| **Operario** | Ninguno | No se puede borrar (se ampliará en v2) |

## Manejo de Errores

```swift
do {
    try request.validate()
    let response = try await sendToServer(request)
} catch let error as APIError {
    // Traducir código a mensaje localizado
    switch error.code {
    case .invalidCredentials:
        showError("Email o contraseña incorrectos")
    case .emailAlreadyInUse:
        showError("Este email ya está registrado")
    case .tokenExpired:
        // Hacer refresh automático
        try await refreshToken()
    default:
        showError("Ha ocurrido un error")
    }
}
```

## Codificación de Fechas

Todas las fechas se codifican en **ISO 8601 UTC**:

```swift
let date = Date()
let encoded = try NexusJSON.encode(date)
// "2026-10-02T10:30:00Z"

let decoded = try NexusJSON.decode(Date.self, from: encoded)
```

## Testing

La librería incluye tests completos:

```bash
swift test
```

Los tests cubren:
- ✅ Serialización/deserialización de todos los DTOs
- ✅ Validación de emails, passwords y campos de texto
- ✅ Tolerancia hacia adelante en permisos
- ✅ Conversión de códigos de error a HTTP status
- ✅ Normalización de requests

## Requisitos

- Swift 6.0+
- Platforms:
  - iOS 17.0+
  - macOS 14.0+
  - watchOS 10.0+
  - tvOS 17.0+
  - visionOS 1.0+

## Instalación

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/yourorg/NexusShared.git", from: "1.0.0")
]
```

## Roadmap

### Entregable 1 (Actual)
- ✅ Contratos completos de Auth, Users, Roles
- ✅ Validación y normalización
- ✅ Tests completos

### Entregable 2 (Futuro)
- 🔄 Permisos adicionales para Técnicos y Operarios
- 🔄 Paginación en listados
- 🔄 Filtros y búsqueda
- 🔄 Auditoría (createdBy, updatedAt, updatedBy)

### Entregable 3+ (Futuro)
- 🔄 Invitaciones por email
- 🔄 Recuperación de contraseña
- 🔄 Tipos de nube / servidor propio
- 🔄 Sistema de licencias/suscripción

## Licencia

Copyright © 2026. Todos los derechos reservados.
