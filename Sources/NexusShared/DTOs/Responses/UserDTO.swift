//
//  UserDTO.swift
//  NexusShared
//
//  Created by Victor Munera on 02/10/2026.
//

import Foundation

/// Información de un usuario
public struct UserDTO: Sendable, Codable, Hashable, Identifiable {
    /// Identificador único del usuario
    public let id: UUID
    
    /// Nombre del usuario
    public let name: String
    
    /// Email del usuario (único en todo el sistema)
    public let email: String
    
    /// ID del rol asignado al usuario
    public let roleID: UUID
    
    /// Indica si el usuario está activo
    public let isActive: Bool
    
    /// Indica si el usuario debe cambiar su contraseña temporal
    public let mustChangePassword: Bool
    
    /// Fecha de creación del usuario
    public let createdAt: Date
    
    public init(
        id: UUID,
        name: String,
        email: String,
        roleID: UUID,
        isActive: Bool,
        mustChangePassword: Bool,
        createdAt: Date
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.roleID = roleID
        self.isActive = isActive
        self.mustChangePassword = mustChangePassword
        self.createdAt = createdAt
    }
}
