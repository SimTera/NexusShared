//
//  CoreInfraEstructureTest.swift
//  NexusShared
//
//  Created by Victor Munera on 15/10/2026.
//

import Foundation
import Testing
@testable import NexusShared

@Suite("Tests de Infraestructura Base: Validación, Permisos, JSON y Errores")
struct CoreInfrastructureTests {

    // MARK: - 1. Tests de Validation (Email)

    @Test("Validación Email: Acepta formatos válidos")
    func emailValido() {
        #expect(Validation.isValidEmail("admin@nexus.com") == true)
        #expect(Validation.isValidEmail("tecnico.123@empresa.es") == true)
        #expect(Validation.isValidEmail("operario+planta1@fabrica.cat") == true)
    }

    @Test("Validación Email: Rechaza formatos inválidos")
    func emailInvalido() {
        #expect(Validation.isValidEmail("") == false)
        #expect(Validation.isValidEmail("   ") == false)
        #expect(Validation.isValidEmail("sin_arroba.com") == false)
        #expect(Validation.isValidEmail("admin@sin_extension") == false)
        #expect(Validation.isValidEmail("@solo_dominio.com") == false)
    }

    // MARK: - 2. Tests de Validation (Contraseñas)

    @Test("Validación Password: Exige mínimo 10 caracteres, letra y número")
    func passwordReglas() {
        // Happy path
        #expect(Validation.isValidPassword("NexusPass1") == true) // 10 caracteres, letras y num

        // Sad paths
        #expect(Validation.isValidPassword("Corta1") == false) // < 10 caracteres
        #expect(Validation.isValidPassword("sololetrasypalabraslargas") == false) // sin números
        #expect(Validation.isValidPassword("123456789012") == false) // sin letras
    }

    // MARK: - 3. Tests de Permissions (Forward-Compatibility)

    @Test("Permissions: Ignora permisos desconocidos sin romper la decodificación")
    func permisosToleranciaHaciaAdelante() throws {
        // Simulamos un JSON que viene del backend con un permiso del futuro (v2.0)
        let jsonConPermisoNuevo = """
        [
            "organization.manage",
            "permiso.futuro.escaneo_lidar_pro",
            "users.view"
        ]
        """.data(using: .utf8)!

        let permissions = try NexusJSON.decode(Permissions.self, from: jsonConPermisoNuevo)

        // Debe conservar los conocidos
        #expect(permissions.contains(.organizationManage) == true)
        #expect(permissions.contains(.usersView) == true)
        // El conteo solo debe incluir los 2 válidos en esta versión
        #expect(permissions.rawElements.count == 2)
    }

    @Test("Permissions: Roles predefinidos contienen los permisos esperados")
    func rolesPredefinidos() {
        #expect(Permissions.adminRole.contains(.rolesManage) == true)
        #expect(Permissions.technicianRole.contains(.usersView) == true)
        #expect(Permissions.technicianRole.contains(.rolesManage) == false)
        #expect(Permissions.operatorRole.rawElements.isEmpty == true)
    }

    // MARK: - 4. Tests de APIErrorCode (HTTP Status)

    @Test("APIErrorCode: Mapeo correcto de códigos HTTP")
    func codigosHTTP() {
        #expect(APIErrorCode.validationFailed.httpStatusCode == 400)
        #expect(APIErrorCode.invalidCredentials.httpStatusCode == 401)
        #expect(APIErrorCode.tokenExpired.httpStatusCode == 401)
        #expect(APIErrorCode.forbidden.httpStatusCode == 403)
        #expect(APIErrorCode.notFound.httpStatusCode == 404)
        #expect(APIErrorCode.emailAlreadyInUse.httpStatusCode == 409)
        #expect(APIErrorCode.internal.httpStatusCode == 500)
    }

    // MARK: - 5. Tests de NexusJSON (Fechas ISO 8601)

    @Test("NexusJSON: Codificación y decodificación estandarizada con fechas")
    func nexusJSONFechas() throws {
        struct MockModel: Codable, Equatable {
            let id: UUID
            let date: Date
        }

        let original = MockModel(id: UUID(), date: Date(timeIntervalSince1970: 1700000000))
        
        let stringJSON = try NexusJSON.encodeToString(original)
        let recuperado = try NexusJSON.decode(MockModel.self, from: stringJSON)

        #expect(recuperado.id == original.id)
        // Comprobamos igualdad a nivel de segundos (por la precisión ISO 8601)
        #expect(Int(recuperado.date.timeIntervalSince1970) == Int(original.date.timeIntervalSince1970))
    }
}
