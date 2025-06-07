//
//  ModelContext+Extension.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 07/06/25.
//
import SwiftData

@MainActor
extension ModelContext {
    static var main: ModelContext {
        ModelContainer.main.mainContext
    }
    
    static var preview: ModelContext {
        ModelContainer.preview.mainContext
    }
}
