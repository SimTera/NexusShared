//
//  APIErrorCode.swift
//  NexusShared
//
//  Created by Victor Munera on 02/10/2026.
//

import Foundation

/// Códigos de error estandarizados del API de Nexus.
///
/// La aplicación debe traducir estos códigos a mensajes localizados para el usuario.
public enum APIErrorCode: String, Sendable, Codable, Hashable {
    // MARK: - 400 Bad Request
    
    /// Algún campo no cumple las reglas de validación
    case validationFailed = "validationFailed"
    
    // MARK: - 401 Unauthorized
    
    /// Email o contraseña incorrectos
    case invalidCredentials = "invalidCredentials"
    
    /// Access token caducado (la app debe hacer refresh)
    case tokenExpired = "tokenExpired"
    
    /// Token mal formado, revocado o refresh reutilizado
    case tokenInvalid = "tokenInvalid"
    
    // MARK: - 403 Forbidden
    
    /// El usuario está desactivado
    case userInactive = "userInactive"
    
    /// Debe cambiar la contraseña temporal antes de continuar
    case passwordChangeRequired = "passwordChangeRequired"
    
    /// Falta el permiso necesario para esta operación
    case forbidden = "forbidden"
    
    // MARK: - 404 Not Found
    
    /// El recurso no existe o pertenece a otra empresa
    case notFound = "notFound"
    
    // MARK: - 409 Conflict
    
    /// Email ya registrado en el sistema
    case emailAlreadyInUse = "emailAlreadyInUse"
    
    /// Nombre de rol repetido en la empresa
    case roleNameAlreadyInUse = "roleNameAlreadyInUse"
    
    /// La operación dejaría la empresa sin nadie con users.manage
    case lastAdministrator = "lastAdministrator"
    
    /// Intento de borrar un rol base o quitar permisos al Administrador base
    case systemRoleProtected = "systemRoleProtected"
    
    /// Intento de borrar un rol asignado a usuarios
    case roleInUse = "roleInUse"
    
    // MARK: - 500 Internal Server Error
    
    /// Error inesperado del servidor
    case `internal` = "internal"
}

// MARK: - HTTP Status Code Mapping

extension APIErrorCode {
    /// Código HTTP correspondiente a este error
    public var httpStatusCode: Int {
        switch self {
        case .validationFailed:
            return 400
            
        case .invalidCredentials, .tokenExpired, .tokenInvalid:
            return 401
            
        case .userInactive, .passwordChangeRequired, .forbidden:
            return 403
            
        case .notFound:
            return 404
            
        case .emailAlreadyInUse, .roleNameAlreadyInUse, .lastAdministrator,
             .systemRoleProtected, .roleInUse:
            return 409
            
        case .internal:
            return 500
        }
    }
}
