//
//  RoleDTO.swift
//  NexusShared
//
//  Created by Victor Munera on 02/10/2026.
//

import Foundation

/// Información de un rol
public struct RoleDTO: Sendable, Codable, Hashable, Identifiable {
    /// Identificador único del rol
    public let id: UUID
    
    /// Nombre del rol
    public let name: String
    
    /// Permisos asignados al rol
    public let permissions: Permissions
    
    /// Indica si es un rol de sistema (no se puede borrar ni modificar sus restricciones)
    public let isSystem: Bool
    
    public init(
        id: UUID,
        name: String,
        permissions: Permissions,
        isSystem: Bool
    ) {
        self.id = id
        self.name = name
        self.permissions = permissions
        self.isSystem = isSystem
    }
}

// MARK: - System Roles

extension RoleDTO {
    /// Nombres de los roles de sistema base
    public enum SystemRoleName {
        public static let administrator = "Administrador"
        public static let technician = "Técnico"
        public static let operatorRole = "Operario"
    }
}
