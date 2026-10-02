//
//  LoginRequest.swift
//  NexusShared
//
//  Created by Victor Munera on 02/10/2026.
//

import Foundation

/// Request para iniciar sesión con email y contraseña.
public struct LoginRequest: Sendable, Codable, Hashable {
    /// Email del usuario
    public let email: String
    
    /// Contraseña del usuario
    public let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

// MARK: - Validation

extension LoginRequest {
    /// Valida que todos los campos estén presentes
    public func validate() throws {
        var errors: [String] = []
        
        if email.trimmingCharacters(in: .whitespaces).isEmpty {
            errors.append("Email is required")
        }
        
        if password.isEmpty {
            errors.append("Password is required")
        }
        
        if !errors.isEmpty {
            throw APIError.validationFailed(errors.joined(separator: "; "))
        }
    }
    
    /// Crea una copia normalizada con el email procesado
    public func normalized() -> LoginRequest {
        LoginRequest(
            email: Validation.normalizeEmail(email),
            password: password
        )
    }
}
