//
//  Permission.swift
//  NexusShared
//
//  Created by Victor Munera on 02/10/2026.
//

import Foundation

/// Permisos disponibles en el sistema Nexus.
///
/// Al decodificar, un valor desconocido se ignora para permitir tolerancia hacia adelante
/// (versiones antiguas de la app pueden recibir permisos nuevos del servidor).
public enum Permission: String, Sendable, Codable, Hashable, CaseIterable {
    /// Permite editar datos de la organización
    case organizationManage = "organization.manage"
    
    /// Permite ver usuarios de la organización
    case usersView = "users.view"
    
    /// Permite crear, editar, activar y desactivar usuarios
    case usersManage = "users.manage"
    
    /// Permite crear, editar y borrar roles y sus permisos
    case rolesManage = "roles.manage"
}

// MARK: - Permissions Container (Forward-Compatible & Sendable)

/// Conjunto de permisos con tolerancia hacia adelante (ignora claves desconocidas del backend).
///
/// Este tipo envuelve un `Set<Permission>` y proporciona:
/// - Decodificación segura que ignora permisos desconocidos
/// - Sendable para concurrencia Swift 6
/// - API conveniente para consultar permisos
public struct Permissions: Sendable, Hashable, ExpressibleByArrayLiteral {
    public let rawElements: Set<Permission>

    public init(_ elements: some Sequence<Permission> = []) {
        self.rawElements = Set(elements)
    }

    public init(arrayLiteral elements: Permission...) {
        self.init(elements)
    }

    public func contains(_ permission: Permission) -> Bool {
        rawElements.contains(permission)
    }
}

// MARK: - Predefined Roles

extension Permissions {
    /// Todos los permisos disponibles en el sistema
    public static var all: Permissions {
        Permissions(Permission.allCases)
    }
    
    /// Permisos del rol Administrador base
    public static var adminRole: Permissions {
        .all
    }
    
    /// Permisos del rol Técnico base (se ampliará en Entregable 2)
    public static var technicianRole: Permissions {
        [.usersView]
    }
    
    /// Permisos del rol Operario base (ninguno en Entregable 1)
    public static var operatorRole: Permissions {
        []
    }
}

// MARK: - Codable Implementation

extension Permissions: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawStrings = try container.decode([String].self)
        
        // Ignora valores desconocidos de forma segura hacia adelante
        let recognized = rawStrings.compactMap { Permission(rawValue: $0) }
        self.init(recognized)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let stringValues = rawElements.map(\.rawValue).sorted()
        try container.encode(stringValues)
    }
}
