//
//  IconPickerView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 28/07/24.
//

import SwiftUI

enum NiceIcon: String, CaseIterable {
    case rainbow = "rainbow"
    case dog = "dog.fill"
    case cat = "cat.fill"
    case heart = "heart.fill"
    case house = "house"
    case shoe = "shoe.2.fill"
    case fuelpump = "fuelpump.fill"
    case car = "car"
    case strengthtraining = "figure.strengthtraining.traditional"
    case cycle = "figure.outdoor.cycle"
    case brain = "brain"
    case sofa = "sofa.fill"
    case gamecontroller = "gamecontroller"
    case moon = "moon"
    case health = "cross.fill"
    case bolt = "bolt.fill"
    case fish = "fish"
    case tree = "tree.fill"
    case cart = "cart"
    case banknote = "banknote"
    case cross = "cross.case"
    case truck = "truck.box.fill"
    case bus = "bus"
    case airplane = "airplane"
    case tram = "tram"
    case network = "network"
    case forkknife = "fork.knife"
    case lightspectrum = "lightspectrum.horizontal"
    case camera = "camera.fill"
    case headphones = "headphones"
    case pencil = "pencil.and.scribble"
    case graduationcap = "graduationcap"
    case dumbbell = "dumbbell"
    case beach = "beach.umbrella.fill"
    case flag = "flag.checkered"
    case hammer = "hammer.fill"
    case theatermasks = "theatermasks"
    case lamp = "lamp.desk.fill"
    case spigot = "spigot.fill"
    case party = "party.popper.fill"
    case popcorn = "popcorn"
    case guitars = "guitars"
    case teddybear = "teddybear.fill"
    case paintpalette = "paintpalette"
    case cup = "cup.and.saucer.fill"
    case phone = "phone.circle.fill"
    case hexagongrid = "circle.hexagongrid.fill"
    case ladybug = "ladybug.fill"
}

struct NiceIconPicker: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selected: NiceIcon?
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(NiceIcon.allCases, id: \.self) { icon in
                    ZStack {
                        if selected == icon {
                            Circle()
                                .fill(Color.brand)
                                .opacity(0.1)
                        }
                        Image(systemName: icon.rawValue)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                    }
                    .onTapGesture {
                        withAnimation {
                            self.selected = icon
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
    @Previewable @State var selected: NiceIcon? = .rainbow
    NiceIconPicker(selected: $selected)
}
