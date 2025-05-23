//
//  AccountQuery.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 20/05/25.
//
import AppIntents

struct AccountQuery: EntityQuery {
    func entities(for identifiers: [SelectAccountEntity.ID]) async throws -> [SelectAccountEntity] {
        getSelectAccountEntities()
    }
    
    func suggestedEntities() async throws -> [SelectAccountEntity] {
        getSelectAccountEntities()
    }

    func defaultResult() async -> SelectAccountEntity? {
        try? await suggestedEntities().first
    }
    
    private func getSelectAccountEntities() -> [SelectAccountEntity] {
        retrieveAccounts()?.map {
            SelectAccountEntity(id: $0.id, name: $0.name)
        } ?? [SelectAccountEntity(id: "", name: "No accounts found")]
    }
    
    private func retrieveAccounts() -> [AccountOrCardData]? {
        let userDefaults: UserDefaults = .widgetsUserDefaults
        guard let data = userDefaults.data(forKey: "widgetData") else {
            return nil
        }
        do {
            return try JSONDecoder().decode([AccountOrCardData].self, from: data)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
