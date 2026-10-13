//
//  ResponseDTOTest.swift
//  NexusShared
//
//  Created by Victor Munera on 12/10/2026.
//

import Testing
import Foundation
@testable import NexusShared

@Suite("Tests de DTOs de Responses (User, Organization, Role)")
struct ResponseDTOTest {
    
    // Estrategia de fechas
    var isoDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    var isoEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
    
    //MARK: - OrganizationDTO test
    @Test("OrganizationDTO: Decodificación correcta con fechas en formato ISO 8601")
    func organizationDataISO8610() throws {
        // Simulamos el JSON exacto que escupirá el backend en Vapor
        let jsonMock = """
            {
                "id": "E621E1F8-C36C-495A-93FC-0C247A3E6E5F",
                "name": "Mantenimiento Industrial S.L.",
                "createdAt": "2026-10-12T10:30:00Z"
            }
            """.data(using: .utf8)!
        
        let organization = try isoDecoder.decode(OrganizationDTO.self, from: jsonMock)
        
        #expect(organization.name == "Mantenimiento Industrial S.L.")
        #expect(organization.id == UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F"))
    }
    
    //MARK: - Users DTOs
    @Test("UserDTO: Decodificación completa incluyendo flags de seguridad")
    func userDTODecodificacion() throws {
        let jsonMock = """
            {
                "id": "11111111-2222-3333-4444-555555555555",
                "name": "Víctor Múnera",
                "email": "victor@nexus.com",
                "roleID": "99999999-8888-7777-6666-555555555555",
                "isActive": true,
                "mustChangePassword": true,
                "createdAt": "2026-10-12T08:00:00Z"
            }
            """.data(using: .utf8)!
        
        let user = try isoDecoder.decode(UserDTO.self, from: jsonMock)
        
        #expect(user.email == "victor@nexus.com")
        #expect(user.isActive == true)
        #expect(user.mustChangePassword == true)
    }
    
    // MARK: - RoleDTO Tests
    
    @Test("RoleDTO: Comprobación de constantes de roles del sistema")
    func rolesDelSistemaValores() {
        #expect(RoleDTO.SystemRoleName.administrator == "Administrador")
        #expect(RoleDTO.SystemRoleName.technician == "Técnico")
        #expect(RoleDTO.SystemRoleName.operatorRole == "Operario")
    }
}
