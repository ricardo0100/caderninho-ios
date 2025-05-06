//
//  InstallmentCellView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 05/05/25.
//

import SwiftUI

struct InstallmentCellView: View {
    @EnvironmentObject var installment: Installment
    
    var body: some View {
        Text(installment.transaction.name)
    }
}

#Preview {
    List(0 ..< 5) { item in
        InstallmentCellView()
            .environmentObject(DataController.createRandomInstallment())
    }
}
