//
//  RefreshResquest.swift
//  NexusShared
//
//  Created by Victor Munera on 02/10/2026.
//

import Foundation

/// Request para renovar un access token usando un refresh token.
public struct RefreshRequest: Sendable, Codable, Hashable {
    /// Refresh token válido
    public let refreshToken: String
    
    public init(refreshToken: String) {
        self.refreshToken = refreshToken
    }
}

// MARK: - Validation

extension RefreshRequest {
    /// Valida que el refresh token esté presente
    public func validate() throws {
        if refreshToken.trimmingCharacters(in: .whitespaces).isEmpty {
            throw APIError.validationFailed("Refresh token is required")
        }
    }
}
