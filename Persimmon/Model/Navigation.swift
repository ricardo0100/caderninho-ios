//
//  Navigation.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 07/06/25.
//

import SwiftUI

class Navigation: ObservableObject {
    @Published var path = NavigationPath()
    @Published var editingTransaction: Transaction?
}
