import Testing
import Foundation
@testable import NexusShared

@Suite("Control de calidad de los DTOs de Autentificacion")
struct AuthDTOTest {
    // Herramientas compartidas en la mesa de pruebas
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    // MARK: - 1. Comprobacion de LoginRequest
    @Test("Login: Falla la validacion si el mail o contraseña estan vacios")
    func loginWithEmptyDataFail() async throws {
        let requestNotMail = LoginRequest(email: "  ", password: "Pasword1234!")
        let requestNotPass = LoginRequest(email: "victor@nexus.com", password: "")
        
        #expect(throws: APIError.self) {
            try requestNotMail.validate()
        }
        
        #expect(throws: APIError.self) {
            try requestNotPass.validate()
        }
    }
    
    @Test("Login: La normalización limpia espacios y pasa el email a minúsculas")
    func loginDataNormal() {
        let requestDirty = LoginRequest(email: "  VICTOR@Nexus.COM  ", password: "MiPassword123")
        let requestClean = requestDirty.normalized()
        
        #expect(requestClean.email == "victor@nexus.com")
        #expect(requestClean.password == "MiPassword123")
    }
    
    @Test("Login: Conversión de ida y vuelta a JSON sin pérdidas") // Esto es util cuando ponga los codingkeys para comprobar que no me he equivocado
    func loginJSONData() throws {
        let origin = LoginRequest(email: "victor@nexus.com", password: "Password123!")
        
        // empaquetar JSON y desempaquetar
        let data = try encoder.encode(origin)
        let received = try decoder.decode(LoginRequest.self, from: data)
        
        #expect(received.email == origin.email)
        #expect(received.password == origin.password)
    }
    
    // MARK: - 2. Comprobacion de RefreshRequest
    @Test("Refresh: Falla si el token no contiene caracteres válidos")
    func refreshEmptyTokenFail() {
        let request = RefreshRequest(refreshToken: "   ")
        
        #expect(throws: APIError.self) {
            try request.validate()
        }
    }
    
    // MARK: - 3. Comprobacion de ChangePasswordRequest
    @Test("ChangePassword: Falla si la nueva contraseña es idéntica a la actual")
    func changePaswordForIdenticFail() {
        let request = ChangePasswordRequest(
            currentPassword: "Password123!",
            newPassword: "Password123!"
        )
        
        #expect(throws: APIError.self) {
            try request.validate()
        }
    }
    
    @Test("ChangePassword: Pasa la validación cuando son distintas y válidas")
    func changePasswordOtherValidate() throws {
        let request = ChangePasswordRequest(
            currentPassword: "PasswordVieja123!",
            newPassword: "PasswordNueva456!"
        )
        
        try request.validate()
    }
}




//func example() async throws {
//    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
//    // Swift Testing Documentation
//    // https://developer.apple.com/documentation/testing
//}
