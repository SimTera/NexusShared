//
//  OrganizationDTO.swift
//  NexusShared
//
//  Created by Victor Munera on 02/10/2026.
//

import Foundation

/// Información de una organización
public struct OrganizationDTO: Sendable, Codable, Hashable, Identifiable {
    /// Identificador único de la organización
    public let id: UUID
    
    /// Nombre de la organización
    public let name: String
    
    /// Fecha de creación
    public let createdAt: Date
    
    public init(id: UUID, name: String, createdAt: Date) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
    }
}
