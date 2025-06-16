//
//  App.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 06/05/25.
//
import SwiftUI
import SwiftData

@main
struct PersimmonApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.modelContext) var modelContext
    let modelManager = ModelManager(context: .main)
    
    var body: some Scene {
        WindowGroup {
            ContainerView()
                .onChange(of: scenePhase) {
                    switch scenePhase {
                    case .active:
                        print("App is active")
                    case .inactive:
                        print("App is inactive")
                    case .background:
                        print("App moved to background")
                        ModelManager(context: ModelContainer.main.mainContext)
                            .updateWidgetInfo()
                    @unknown default:
                        print("Unexpected new value.")
                    }
                }
                .onOpenURL { url in
                    open(url)
                }
                .environmentObject(NavigationModel.shared)
                .modelContainer(.main)
        }
    }
    
    private func open(_ url: URL) {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                let items = components.queryItems else {
            print("Could not open URL: \(url)")
            return
        }
        
        switch components.host {
        case "open":
            if let id = items.first(where: { $0.name == "id" })?.value {
                presentAccountOrCard(with: id)
            }
        case "new":
            if let id = items.first(where: { $0.name == "id" })?.value {
                presentNewTransactionWithAccountOrCard(with: id)
            }
        default:
            print("Invalid URL scheme: \(url)")
        }
    }
    
    private func presentNewTransactionWithAccountOrCard(with id: String) {
        guard let uuid = UUID(uuidString: id) else { return }
        if let account = modelManager.getAccount(with: uuid) {
            NavigationModel.shared.presentNewTransaction(for: account)
        } else if let card = modelManager.getCard(with: uuid) {
            NavigationModel.shared.presentNewTransaction(for: card)
        }
    }
    
    private func presentAccountOrCard(with id: String) {
        guard let uuid = UUID(uuidString: id) else { return }
        
        if let account = modelManager.getAccount(with: uuid) {
            NavigationModel.shared.presentAccount(account)
        } else if let card = modelManager.getCard(with: uuid) {
            NavigationModel.shared.presentCard(card)
        }
    }
}
