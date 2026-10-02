//
//  NexusJSON.swift
//  NexusShared
//
//  Created by Victor Munera on 02/10/2026.
//

import Foundation

/// Codificadores y decodificadores JSON estandarizados para el ecosistema Nexus.
///
/// Todos los componentes (app cliente y servidor) deben usar estos codecs
/// para garantizar consistencia en el formato de fechas (ISO 8601 en UTC).
public enum NexusJSON {
    
    // MARK: - Encoder
    
    /// Codificador JSON con configuración estándar de Nexus
    public static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
        return encoder
    }
    
    // MARK: - Decoder
    
    /// Decodificador JSON con configuración estándar de Nexus
    public static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    // MARK: - Convenience Methods
    
    /// Codifica un valor a JSON Data
    public static func encode<T: Encodable>(_ value: T) throws -> Data {
        try encoder.encode(value)
    }
    
    /// Decodifica JSON Data a un tipo específico
    public static func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        try decoder.decode(type, from: data)
    }
    
    /// Codifica un valor a String JSON
    public static func encodeToString<T: Encodable>(_ value: T) throws -> String {
        let data = try encode(value)
        guard let string = String(data: data, encoding: .utf8) else {
            throw EncodingError.invalidValue(
                value,
                EncodingError.Context(
                    codingPath: [],
                    debugDescription: "Unable to convert encoded data to UTF-8 string"
                )
            )
        }
        return string
    }
    
    /// Decodifica un String JSON a un tipo específico
    public static func decode<T: Decodable>(_ type: T.Type, from string: String) throws -> T {
        guard let data = string.data(using: .utf8) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Invalid UTF-8 string"
                )
            )
        }
        return try decode(type, from: data)
    }
}
