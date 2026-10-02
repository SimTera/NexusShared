//
//  Validation.swift
//  NexusShared
//
//  Created by Victor Munera on 02/10/2026.
//

import Foundation

/// Reglas de validación compartidas entre el cliente y el servidor.
///
/// Estas validaciones deben aplicarse en ambos lados:
/// - Cliente: validación inmediata antes de enviar al servidor
/// - Servidor: validación definitiva antes de persistir
public enum Validation {
    
    // MARK: - Email
    
    /// Valida el formato de un email
    public static func isValidEmail(_ email: String) -> Bool {
        let trimmed = email.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return false }
        
        // Expresión regular básica para validación de email
        let emailRegex = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return predicate.evaluate(with: trimmed)
    }
    
    /// Normaliza un email (minúsculas, sin espacios)
    public static func normalizeEmail(_ email: String) -> String {
        email.trimmingCharacters(in: .whitespaces).lowercased()
    }
    
    // MARK: - Password
    
    /// Requisitos mínimos de contraseña
    public enum PasswordRequirements {
        public static let minLength = 10
    }
    
    /// Valida que una contraseña cumpla los requisitos
    public static func isValidPassword(_ password: String) -> Bool {
        guard password.count >= PasswordRequirements.minLength else {
            return false
        }
        
        // Al menos una letra
        let hasLetter = password.rangeOfCharacter(from: .letters) != nil
        
        // Al menos un número
        let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        
        return hasLetter && hasNumber
    }
    
    /// Genera un mensaje de error descriptivo para una contraseña inválida
    public static func passwordValidationMessage() -> String {
        "Password must be at least \(PasswordRequirements.minLength) characters and contain at least one letter and one number"
    }
    
    // MARK: - Text Fields
    
    /// Requisitos para campos de texto generales
    public enum TextRequirements {
        public static let minLength = 1
        public static let maxLength = 100
    }
    
    /// Valida un campo de texto general (nombres, etc.)
    public static func isValidText(_ text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.count >= TextRequirements.minLength &&
               trimmed.count <= TextRequirements.maxLength
    }
    
    /// Normaliza un campo de texto (recorta espacios)
    public static func normalizeText(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // MARK: - Organization Name
    
    /// Valida el nombre de una organización
    public static func isValidOrganizationName(_ name: String) -> Bool {
        isValidText(name)
    }
    
    // MARK: - User Name
    
    /// Valida el nombre de un usuario
    public static func isValidUserName(_ name: String) -> Bool {
        isValidText(name)
    }
    
    // MARK: - Role Name
    
    /// Valida el nombre de un rol
    public static func isValidRoleName(_ name: String) -> Bool {
        isValidText(name)
    }
}
