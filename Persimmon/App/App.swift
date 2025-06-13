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
    
    var body: some Scene {
        WindowGroup {
            ContainerView()
                .environmentObject(NavigationModel.shared)
                .modelContainer(.main)
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
        }
    }
}
