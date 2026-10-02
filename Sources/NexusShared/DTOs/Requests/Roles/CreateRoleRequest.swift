//
//  CreateRoleRequest.swift
//  NexusShared
//
//  Created by Victor Munera on 02/10/2026.
//

import Foundation

/// Request para crear un nuevo rol en la organización.
///
/// Requiere permiso: `roles.manage`
///
/// El nombre del rol debe ser único dentro de la organización.
public struct CreateRoleRequest: Sendable, Codable, Hashable {
    /// Nombre del rol
    public let name: String
    
    /// Permisos asignados al rol
    public let permissions: Permissions
    
    public init(name: String, permissions: Permissions) {
        self.name = name
        self.permissions = permissions
    }
}

// MARK: - Validation

extension CreateRoleRequest {
    /// Valida que todos los campos cumplan las reglas de validación
    public func validate() throws {
        var errors: [String] = []
        
        if !Validation.isValidRoleName(name) {
            errors.append("Role name must be between \(Validation.TextRequirements.minLength) and \(Validation.TextRequirements.maxLength) characters")
        }
        
        if !errors.isEmpty {
            throw APIError.validationFailed(errors.joined(separator: "; "))
        }
    }
    
    /// Crea una copia normalizada con el nombre procesado
    public func normalized() -> CreateRoleRequest {
        CreateRoleRequest(
            name: Validation.normalizeText(name),
            permissions: permissions
        )
    }
}
