//
//  APIError.swift
//  NexusShared
//
//  Created by Victor Munera on 02/10/2026.
//

import Foundation

/// Error estandarizado del API de Nexus.
///
/// El campo `message` es informativo/debug. La aplicación debe traducir
/// basándose en el `code` para mostrar mensajes localizados al usuario.
public struct APIError: Sendable, Codable, Hashable, Error, LocalizedError {
    /// Código de error estandarizado
    public let code: APIErrorCode
    
    /// Mensaje descriptivo (en inglés, solo para debug/logs)
    public let message: String
    
    public init(code: APIErrorCode, message: String) {
        self.code = code
        self.message = message
    }
    
    // MARK: - LocalizedError Conformance
    
    public var errorDescription: String? {
        message
    }
}

// MARK: - Convenience Initializers

extension APIError {
    /// Error de validación genérico
    public static func validationFailed(_ message: String = "Validation failed") -> APIError {
        APIError(code: .validationFailed, message: message)
    }
    
    /// Credenciales inválidas
    public static var invalidCredentials: APIError {
        APIError(code: .invalidCredentials, message: "Invalid email or password")
    }
    
    /// Token expirado
    public static var tokenExpired: APIError {
        APIError(code: .tokenExpired, message: "Access token expired")
    }
    
    /// Token inválido
    public static var tokenInvalid: APIError {
        APIError(code: .tokenInvalid, message: "Invalid or revoked token")
    }
    
    /// Usuario inactivo
    public static var userInactive: APIError {
        APIError(code: .userInactive, message: "User account is inactive")
    }
    
    /// Cambio de contraseña requerido
    public static var passwordChangeRequired: APIError {
        APIError(code: .passwordChangeRequired, message: "Password change required")
    }
    
    /// Permiso denegado
    public static func forbidden(_ message: String = "Forbidden") -> APIError {
        APIError(code: .forbidden, message: message)
    }
    
    /// Recurso no encontrado
    public static var notFound: APIError {
        APIError(code: .notFound, message: "Resource not found")
    }
    
    /// Email ya en uso
    public static var emailAlreadyInUse: APIError {
        APIError(code: .emailAlreadyInUse, message: "Email already in use")
    }
    
    /// Nombre de rol ya en uso
    public static var roleNameAlreadyInUse: APIError {
        APIError(code: .roleNameAlreadyInUse, message: "Role name already in use")
    }
    
    /// Último administrador
    public static var lastAdministrator: APIError {
        APIError(code: .lastAdministrator, message: "Cannot remove the last administrator")
    }
    
    /// Rol de sistema protegido
    public static var systemRoleProtected: APIError {
        APIError(code: .systemRoleProtected, message: "System roles cannot be modified")
    }
    
    /// Rol en uso
    public static var roleInUse: APIError {
        APIError(code: .roleInUse, message: "Role is assigned to users")
    }
    
    /// Error interno del servidor
    public static var `internal`: APIError {
        APIError(code: .internal, message: "Internal server error")
    }
}
