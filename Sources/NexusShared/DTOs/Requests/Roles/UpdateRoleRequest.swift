//
//  UpdateRoleRequest.swift
//  NexusShared
//
//  Created by Victor Munera on 02/10/2026.
//

import Foundation

/// Request para actualizar un rol existente.
///
/// Solo se aplican los campos presentes (no nil). Permite actualizaciones parciales.
///
/// Requiere permiso: `roles.manage`
///
/// Restricciones:
/// - Los roles de sistema (`isSystem = true`) no se pueden borrar
/// - Al rol Administrador base no se le pueden quitar permisos
/// - No se puede dejar la organización sin usuarios activos con `users.manage`
public struct UpdateRoleRequest: Sendable, Codable, Hashable {
    /// Nuevo nombre del rol (opcional)
    public let name: String?
    
    /// Nuevos permisos del rol (opcional)
    public let permissions: Permissions?
    
    public init(
        name: String? = nil,
        permissions: Permissions? = nil
    ) {
        self.name = name
        self.permissions = permissions
    }
}

// MARK: - Validation

extension UpdateRoleRequest {
    /// Valida que los campos presentes cumplan las reglas de validación
    public func validate() throws {
        var errors: [String] = []
        
        if let name = name, !Validation.isValidRoleName(name) {
            errors.append("Role name must be between \(Validation.TextRequirements.minLength) and \(Validation.TextRequirements.maxLength) characters")
        }
        
        if !errors.isEmpty {
            throw APIError.validationFailed(errors.joined(separator: "; "))
        }
    }
    
    /// Crea una copia normalizada con el nombre procesado
    public func normalized() -> UpdateRoleRequest {
        UpdateRoleRequest(
            name: name.map { Validation.normalizeText($0) },
            permissions: permissions
        )
    }
    
    /// Verifica si el request está vacío (no actualiza nada)
    public var isEmpty: Bool {
        name == nil && permissions == nil
    }
}
