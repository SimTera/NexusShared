//
//  UpdateUserRequest.swift
//  NexusShared
//
//  Created by Victor Munera on 02/10/2026.
//

import Foundation

/// Request para actualizar un usuario existente.
///
/// Solo se aplican los campos presentes (no nil). Permite actualizaciones parciales.
///
/// Requiere permiso: `users.manage`
///
/// Restricciones:
/// - Un usuario no puede desactivarse a sí mismo
/// - Desactivar un usuario revoca sus refresh tokens
/// - No se puede dejar la organización sin usuarios activos con `users.manage`
public struct UpdateUserRequest: Sendable, Codable, Hashable {
    /// Nuevo nombre del usuario (opcional)
    public let name: String?
    
    /// Nuevo ID de rol (opcional)
    public let roleID: UUID?
    
    /// Nuevo estado activo/inactivo (opcional)
    public let isActive: Bool?
    
    public init(
        name: String? = nil,
        roleID: UUID? = nil,
        isActive: Bool? = nil
    ) {
        self.name = name
        self.roleID = roleID
        self.isActive = isActive
    }
}

// MARK: - Validation

extension UpdateUserRequest {
    /// Valida que los campos presentes cumplan las reglas de validación
    public func validate() throws {
        var errors: [String] = []
        
        if let name = name, !Validation.isValidUserName(name) {
            errors.append("Name must be between \(Validation.TextRequirements.minLength) and \(Validation.TextRequirements.maxLength) characters")
        }
        
        if !errors.isEmpty {
            throw APIError.validationFailed(errors.joined(separator: "; "))
        }
    }
    
    /// Crea una copia normalizada con los campos de texto procesados
    public func normalized() -> UpdateUserRequest {
        UpdateUserRequest(
            name: name.map { Validation.normalizeText($0) },
            roleID: roleID,
            isActive: isActive
        )
    }
    
    /// Verifica si el request está vacío (no actualiza nada)
    public var isEmpty: Bool {
        name == nil && roleID == nil && isActive == nil
    }
}
