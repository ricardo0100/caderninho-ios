//
//  AccountQuery.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 20/05/25.
//
import AppIntents

struct AccountQuery: EntityQuery {
    static let userDefaults = UserDefaults(suiteName: "group.br.com.rrghkf.test.group")
    
    func entities(for identifiers: [SelectAccountEntity.ID]) async throws -> [SelectAccountEntity] {
        [
            SelectAccountEntity(id: UUID(), name: "Test 1"),
            SelectAccountEntity(id: UUID(), name: "Test 2"),
            SelectAccountEntity(id: UUID(), name: "Test 3")
        ]
    }
    
    func suggestedEntities() async throws -> [SelectAccountEntity] {
        [
            SelectAccountEntity(id: UUID(), name: "Test 1"),
            SelectAccountEntity(id: UUID(), name: "Test 2"),
            SelectAccountEntity(id: UUID(), name: "Test 3")
        ]
    }

    func defaultResult() async -> SelectAccountEntity? {
        try? await suggestedEntities().first
    }
}
