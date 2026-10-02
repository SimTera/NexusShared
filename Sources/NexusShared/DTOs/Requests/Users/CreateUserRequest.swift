//
//  CreateUserRequest.swift
//  NexusShared
//
//  Created by Victor Munera on 02/10/2026.
//

import Foundation

/// Request para crear un nuevo usuario en la organización.
///
/// El usuario se crea con `mustChangePassword = true` y recibe
/// una contraseña temporal que debe cambiar en su primer inicio de sesión.
///
/// Requiere permiso: `users.manage`
public struct CreateUserRequest: Sendable, Codable, Hashable {
    /// Nombre del usuario
    public let name: String
    
    /// Email del usuario (único en todo el sistema)
    public let email: String
    
    /// ID del rol a asignar al usuario
    public let roleID: UUID
    
    /// Contraseña temporal (el usuario deberá cambiarla al iniciar sesión)
    public let temporaryPassword: String
    
    public init(
        name: String,
        email: String,
        roleID: UUID,
        temporaryPassword: String
    ) {
        self.name = name
        self.email = email
        self.roleID = roleID
        self.temporaryPassword = temporaryPassword
    }
}

// MARK: - Validation

extension CreateUserRequest {
    /// Valida que todos los campos cumplan las reglas de validación
    public func validate() throws {
        var errors: [String] = []
        
        if !Validation.isValidUserName(name) {
            errors.append("Name must be between \(Validation.TextRequirements.minLength) and \(Validation.TextRequirements.maxLength) characters")
        }
        
        if !Validation.isValidEmail(email) {
            errors.append("Invalid email format")
        }
        
        if !Validation.isValidPassword(temporaryPassword) {
            errors.append(Validation.passwordValidationMessage())
        }
        
        if !errors.isEmpty {
            throw APIError.validationFailed(errors.joined(separator: "; "))
        }
    }
    
    /// Crea una copia normalizada con los campos procesados según las reglas
    public func normalized() -> CreateUserRequest {
        CreateUserRequest(
            name: Validation.normalizeText(name),
            email: Validation.normalizeEmail(email),
            roleID: roleID,
            temporaryPassword: temporaryPassword
        )
    }
}
