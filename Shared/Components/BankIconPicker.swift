//
//  BankIconPicker.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 23/05/25.
//
import SwiftUI

enum BankIcon: String, CaseIterable {
    case bb = "bb"
    case caixa = "caixa"
    case bnds = "bnds"
    case alelo = "alelo"
    case ifood = "ifood"
    case luiza = "luiza"
    case neon = "neon"
    case pagbank = "pagbank"
    case sicoob = "sicoob"
    case stone = "stone"
    case visa = "visa"
    case bradesco = "bradesco"
    case inter = "inter"
    case mastercard = "mastercard"
    case nubank = "nubank"
    case picpay = "picpay"
    case sicredi = "sicredi"
    case ticket = "ticket"
    case vr = "vr"
    case c6 = "c6"
    case itau = "itau"
    case mercadopago = "mercadopago"
    case original = "original"
    case santander = "santander"
    case sodexo = "sodexo"
    case unicred = "unicred"
    case xp = "xp"
    
}

struct BankIconPicker: View {
    @Binding var selectedIcon: BankIcon?
    @Environment(\.dismiss) var dismiss
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(BankIcon.allCases, id: \.self) { icon in
                        Image(icon.rawValue)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.spacingSmall)
                            .background(selectedIcon?.rawValue == icon.rawValue ? Color.brand : .clear)
                            .onTapGesture {
                                self.selectedIcon = icon
                                dismiss()
                            }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var selected: BankIcon? = .bb
    BankIconPicker(selectedIcon: $selected)
}
