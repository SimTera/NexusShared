//
//  UserRoleRequestTest.swift
//  NexusShared
//
//  Created by Victor Munera on 13/10/2026.
//

import Foundation
import Testing
@testable import NexusShared

// Añadir tanto test que sean el camino correcto como test de si se equivoca que ha de hacer, como los que tengo.

@Suite("Tests de Requests para Roles y Usuarios")
struct UserRoleRequestsTests {
    
    // MARK: - 1. CreateRoleRequest Tests
    
    @Test("CreateRole: Falla si el nombre del rol no cumple las restricciones")
    func createRoleNombreInvalido() {
        let requestInvalido = CreateRoleRequest(
            name: "", // Nombre vacío
            permissions: Permissions() // O la instancia por defecto que tengas
        )
        
        #expect(throws: APIError.self) {
            try requestInvalido.validate()
        }
    }
    
    // MARK: - 2. UpdateRoleRequest Tests
    
    @Test("UpdateRole: isEmpty detecta correctamente si no hay cambios")
    func updateRoleIsEmpty() {
        let requestVacio = UpdateRoleRequest()
        let requestConNombre = UpdateRoleRequest(name: "Técnico Especialista")
        
        #expect(requestVacio.isEmpty == true)
        #expect(requestConNombre.isEmpty == false)
    }
    
    // MARK: - 3. CreateUserRequest Tests
    
    @Test("CreateUser: Falla si el email o la contraseña temporal son inválidos")
    func createUserValidacion() {
        let requestMalo = CreateUserRequest(
            name: "Víctor",
            email: "email-invalido",
            roleID: UUID(),
            temporaryPassword: "123" // Muy corta
        )
        
        #expect(throws: APIError.self) {
            try requestMalo.validate()
        }
    }
    
    @Test("CreateUser: Normalización procesa email y texto")
    func createUserNormalizado() {
        let request = CreateUserRequest(
            name: "  Víctor Múnera  ",
            email: "  VICTOR@Nexus.COM  ",
            roleID: UUID(),
            temporaryPassword: "TemporalPassword123!"
        )
        let normalizado = request.normalized()
        
        #expect(normalizado.name == "Víctor Múnera")
        #expect(normalizado.email == "victor@nexus.com")
    }
    
    // MARK: - 4. UpdateUserRequest Tests
    
    @Test("UpdateUser: isEmpty comprueba todos los campos opcionales")
    func updateUserIsEmpty() {
        let vacio = UpdateUserRequest()
        let soloEstado = UpdateUserRequest(isActive: false)
        let soloRol = UpdateUserRequest(roleID: UUID())
        
        #expect(vacio.isEmpty == true)
        #expect(soloEstado.isEmpty == false)
        #expect(soloRol.isEmpty == false)
    }
    
    @Test("UpdateUser: No lanza error si todos los campos son nil")
    func updateUserOpcionalesValidos() throws {
        let vacio = UpdateUserRequest()
        try vacio.validate()
    }
}
