//
//  GraphItem.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 21/12/24.
//


import SwiftUI

struct GraphItem: Identifiable {
    let id = UUID()
    let title: AttributedString
    let value: Double
    let color: Color
}
