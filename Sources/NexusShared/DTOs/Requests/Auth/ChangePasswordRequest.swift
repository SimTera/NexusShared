//
//  ChangePasswordRequest.swift
//  NexusShared
//
//  Created by Victor Munera on 02/10/2026.
//

import Foundation

/// Request para cambiar la contraseña del usuario autenticado.
///
/// Al cambiar la contraseña:
/// - Se revocan todos los demás refresh tokens del usuario
/// - Se establece `mustChangePassword = false`
/// - Se retorna un nuevo AuthResponse con nuevos tokens
public struct ChangePasswordRequest: Sendable, Codable, Hashable {
    /// Contraseña actual del usuario
    public let currentPassword: String
    
    /// Nueva contraseña
    public let newPassword: String
    
    public init(currentPassword: String, newPassword: String) {
        self.currentPassword = currentPassword
        self.newPassword = newPassword
    }
}

// MARK: - Validation

extension ChangePasswordRequest {
    /// Valida que ambas contraseñas estén presentes y la nueva cumpla requisitos
    public func validate() throws {
        var errors: [String] = []
        
        if currentPassword.isEmpty {
            errors.append("Current password is required")
        }
        
        if newPassword.isEmpty {
            errors.append("New password is required")
        } else if !Validation.isValidPassword(newPassword) {
            errors.append(Validation.passwordValidationMessage())
        }
        
        if currentPassword == newPassword {
            errors.append("New password must be different from current password")
        }
        
        if !errors.isEmpty {
            throw APIError.validationFailed(errors.joined(separator: "; "))
        }
    }
}
