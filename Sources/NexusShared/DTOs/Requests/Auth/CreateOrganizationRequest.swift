//
//  CreateOrganizationRequest.swift
//  NexusShared
//
//  Created by Victor Munera on 02/10/2026.
//

import Foundation

/// Request para crear una nueva organización con su usuario administrador.
///
/// Este endpoint es público y permite el registro inicial de nuevas empresas.
/// El usuario administrador se crea con `mustChangePassword = false`.
public struct CreateOrganizationRequest: Sendable, Codable, Hashable {
    /// Nombre de la organización
    public let organizationName: String
    
    /// Nombre del usuario administrador
    public let adminName: String
    
    /// Email del usuario administrador (único en todo el sistema)
    public let adminEmail: String
    
    /// Contraseña del usuario administrador
    public let adminPassword: String
    
    public init(
        organizationName: String,
        adminName: String,
        adminEmail: String,
        adminPassword: String
    ) {
        self.organizationName = organizationName
        self.adminName = adminName
        self.adminEmail = adminEmail
        self.adminPassword = adminPassword
    }
}

// MARK: - Validation

extension CreateOrganizationRequest {
    /// Valida que todos los campos cumplan las reglas de validación
    public func validate() throws {
        var errors: [String] = []
        
        if !Validation.isValidOrganizationName(organizationName) {
            errors.append("Organization name must be between \(Validation.TextRequirements.minLength) and \(Validation.TextRequirements.maxLength) characters")
        }
        
        if !Validation.isValidUserName(adminName) {
            errors.append("Admin name must be between \(Validation.TextRequirements.minLength) and \(Validation.TextRequirements.maxLength) characters")
        }
        
        if !Validation.isValidEmail(adminEmail) {
            errors.append("Invalid email format")
        }
        
        if !Validation.isValidPassword(adminPassword) {
            errors.append(Validation.passwordValidationMessage())
        }
        
        if !errors.isEmpty {
            throw APIError.validationFailed(errors.joined(separator: "; "))
        }
    }
    
    /// Crea una copia normalizada con los campos procesados según las reglas
    public func normalized() -> CreateOrganizationRequest {
        CreateOrganizationRequest(
            organizationName: Validation.normalizeText(organizationName),
            adminName: Validation.normalizeText(adminName),
            adminEmail: Validation.normalizeEmail(adminEmail),
            adminPassword: adminPassword
        )
    }
}
