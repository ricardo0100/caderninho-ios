//
//  App.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 06/05/25.
//
import SwiftUI

@main
struct PersimmonApp: App {
    var body: some Scene {
        WindowGroup {
            ContainerView()
                .modelContainer(.shared)
        }
    }
}
