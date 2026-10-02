// API Routes - Nexus v1
//
// Este archivo documenta todas las rutas del API REST de Nexus.
// NO es código ejecutable, solo documentación para referencia.

/*
 
 BASE URL: /v1
 
 AUTENTICACIÓN:
 - Rutas públicas: no requieren autenticación
 - Rutas autenticadas: requieren cabecera `Authorization: Bearer <accessToken>`
 - Rutas con permisos específicos: verifican que el usuario tenga el permiso requerido
 
 FORMATO:
 - Content-Type: application/json
 - Fechas: ISO 8601 en UTC ("2026-10-02T10:30:00Z")
 - IDs: UUID como string
 - Campos: camelCase
 
 ═══════════════════════════════════════════════════════════════════════════════
 ORGANIZATIONS
 ═══════════════════════════════════════════════════════════════════════════════
 
 POST /v1/organizations
 Crear una nueva organización con su usuario administrador
 
 Access: público
 Body: CreateOrganizationRequest {
   organizationName: String,
   adminName: String,
   adminEmail: String,
   adminPassword: String
 }
 Response: 201 AuthResponse
 Errors:
   - 400 validationFailed: campos inválidos
   - 409 emailAlreadyInUse: el email ya está registrado
 
 
 ═══════════════════════════════════════════════════════════════════════════════
 AUTHENTICATION
 ═══════════════════════════════════════════════════════════════════════════════
 
 POST /v1/auth/login
 Iniciar sesión con email y contraseña
 
 Access: público
 Body: LoginRequest {
   email: String,
   password: String
 }
 Response: 200 AuthResponse
 Errors:
   - 400 validationFailed: campos vacíos
   - 401 invalidCredentials: email o contraseña incorrectos
   - 403 userInactive: el usuario está desactivado (solo si la contraseña es correcta)
 
 
 POST /v1/auth/refresh
 Renovar un access token usando un refresh token
 
 Access: público
 Body: RefreshRequest {
   refreshToken: String
 }
 Response: 200 AuthResponse
 Errors:
   - 401 tokenInvalid: token mal formado, revocado o reutilizado
 
 Notes:
   - Cada uso invalida el refresh token anterior
   - Reutilizar un token ya usado revoca TODOS los refresh tokens del usuario
 
 
 POST /v1/auth/logout
 Cerrar sesión (revocar refresh token)
 
 Access: autenticado
 Body: RefreshRequest {
   refreshToken: String
 }
 Response: 204 (sin contenido)
 Errors:
   - 401 tokenExpired: access token expirado
   - 401 tokenInvalid: access token inválido
 
 
 POST /v1/auth/change-password
 Cambiar la contraseña del usuario autenticado
 
 Access: autenticado (funciona aunque mustChangePassword = true)
 Body: ChangePasswordRequest {
   currentPassword: String,
   newPassword: String
 }
 Response: 200 AuthResponse
 Errors:
   - 400 validationFailed: contraseña nueva no cumple requisitos
   - 401 invalidCredentials: contraseña actual incorrecta
 
 Notes:
   - Revoca todos los demás refresh tokens del usuario
   - Establece mustChangePassword = false
   - Retorna nuevos tokens
 
 
 ═══════════════════════════════════════════════════════════════════════════════
 SESSION
 ═══════════════════════════════════════════════════════════════════════════════
 
 GET /v1/me
 Obtener el perfil de sesión del usuario autenticado
 
 Access: autenticado (funciona aunque mustChangePassword = true)
 Body: ninguno
 Response: 200 SessionProfile
 Errors:
   - 401 tokenExpired: access token expirado
   - 401 tokenInvalid: access token inválido
 
 
 ═══════════════════════════════════════════════════════════════════════════════
 USERS
 ═══════════════════════════════════════════════════════════════════════════════
 
 GET /v1/users
 Listar todos los usuarios de la organización
 
 Access: autenticado
 Permission: users.view
 Body: ninguno
 Response: 200 [UserDTO]
 Errors:
   - 401 tokenExpired: access token expirado
   - 403 passwordChangeRequired: debe cambiar contraseña temporal
   - 403 forbidden: no tiene permiso users.view
 
 
 POST /v1/users
 Crear un nuevo usuario en la organización
 
 Access: autenticado
 Permission: users.manage
 Body: CreateUserRequest {
   name: String,
   email: String,
   roleID: UUID,
   temporaryPassword: String
 }
 Response: 201 UserDTO
 Errors:
   - 400 validationFailed: campos inválidos
   - 403 passwordChangeRequired: debe cambiar contraseña temporal
   - 403 forbidden: no tiene permiso users.manage
   - 404 notFound: el roleID no existe o pertenece a otra empresa
   - 409 emailAlreadyInUse: el email ya está registrado
 
 Notes:
   - El usuario se crea con mustChangePassword = true
   - El usuario se crea activo (isActive = true)
 
 
 PATCH /v1/users/:id
 Actualizar un usuario existente
 
 Access: autenticado
 Permission: users.manage
 Body: UpdateUserRequest {
   name: String?,
   roleID: UUID?,
   isActive: Bool?
 }
 Response: 200 UserDTO
 Errors:
   - 400 validationFailed: campos inválidos
   - 403 passwordChangeRequired: debe cambiar contraseña temporal
   - 403 forbidden: no tiene permiso users.manage o intenta desactivarse a sí mismo
   - 404 notFound: el usuario o roleID no existe o pertenece a otra empresa
   - 409 lastAdministrator: dejaría la empresa sin usuarios con users.manage
 
 Notes:
   - Un usuario no puede desactivarse a sí mismo
   - Desactivar un usuario revoca sus refresh tokens
   - Solo se aplican los campos presentes (actualizaciones parciales)
 
 
 ═══════════════════════════════════════════════════════════════════════════════
 ROLES
 ═══════════════════════════════════════════════════════════════════════════════
 
 GET /v1/roles
 Listar todos los roles de la organización
 
 Access: autenticado
 Permission: users.view o roles.manage
 Body: ninguno
 Response: 200 [RoleDTO]
 Errors:
   - 401 tokenExpired: access token expirado
   - 403 passwordChangeRequired: debe cambiar contraseña temporal
   - 403 forbidden: no tiene permiso users.view ni roles.manage
 
 
 POST /v1/roles
 Crear un nuevo rol en la organización
 
 Access: autenticado
 Permission: roles.manage
 Body: CreateRoleRequest {
   name: String,
   permissions: Permissions
 }
 Response: 201 RoleDTO
 Errors:
   - 400 validationFailed: campos inválidos
   - 403 passwordChangeRequired: debe cambiar contraseña temporal
   - 403 forbidden: no tiene permiso roles.manage
   - 409 roleNameAlreadyInUse: nombre de rol repetido en la empresa
 
 Notes:
   - El rol se crea con isSystem = false
 
 
 PATCH /v1/roles/:id
 Actualizar un rol existente
 
 Access: autenticado
 Permission: roles.manage
 Body: UpdateRoleRequest {
   name: String?,
   permissions: Permissions?
 }
 Response: 200 RoleDTO
 Errors:
   - 400 validationFailed: campos inválidos
   - 403 passwordChangeRequired: debe cambiar contraseña temporal
   - 403 forbidden: no tiene permiso roles.manage
   - 404 notFound: el rol no existe o pertenece a otra empresa
   - 409 roleNameAlreadyInUse: nombre de rol repetido en la empresa
   - 409 systemRoleProtected: intento de quitar permisos al Administrador base
   - 409 lastAdministrator: dejaría la empresa sin usuarios con users.manage
 
 Notes:
   - Los roles de sistema (isSystem = true) pueden ser editados
   - Al rol "Administrador" base no se le pueden quitar permisos
   - Solo se aplican los campos presentes (actualizaciones parciales)
 
 
 DELETE /v1/roles/:id
 Borrar un rol
 
 Access: autenticado
 Permission: roles.manage
 Body: ninguno
 Response: 204 (sin contenido)
 Errors:
   - 403 passwordChangeRequired: debe cambiar contraseña temporal
   - 403 forbidden: no tiene permiso roles.manage
   - 404 notFound: el rol no existe o pertenece a otra empresa
   - 409 systemRoleProtected: intento de borrar un rol base
   - 409 roleInUse: el rol está asignado a usuarios
   - 409 lastAdministrator: dejaría la empresa sin usuarios con users.manage
 
 Notes:
   - Los roles de sistema (isSystem = true) no se pueden borrar
   - No se puede borrar un rol asignado a usuarios
 
 
 ═══════════════════════════════════════════════════════════════════════════════
 ROLES BASE (Sistema)
 ═══════════════════════════════════════════════════════════════════════════════
 
 Al crear una organización, se crean automáticamente 3 roles base:
 
 1. Administrador (isSystem = true)
    - Permisos: todos los disponibles
    - No se puede borrar
    - No se le pueden quitar permisos
 
 2. Técnico (isSystem = true)
    - Permisos: users.view (se ampliará en Entregable 2)
    - No se puede borrar
    - Se le pueden añadir/quitar permisos (excepto dejar sin ninguno)
 
 3. Operario (isSystem = true)
    - Permisos: ninguno en Entregable 1
    - No se puede borrar
    - Se le pueden añadir permisos
 
 */
