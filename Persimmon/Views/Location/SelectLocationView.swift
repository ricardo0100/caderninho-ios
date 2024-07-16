import SwiftUI
import MapKit

struct SelectLocationView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SelectLocationViewModel
    
    init(place: Binding<Transaction.Place?>) {
        viewModel = SelectLocationViewModel(placeBinding: place)
    }
    
    var body: some View {
        VStack {
            if viewModel.searchIsPresented {
                TextField("Search", text: $viewModel.searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding()
            }
            ZStack(alignment: .bottomTrailing) {
                Map(position: $viewModel.mapPosition) {
                    if let place = viewModel.highlightedPlace,
                       let coordinate = place.coordinate,
                       let name = place.name {
                        Marker(name, coordinate: coordinate)
                    }
                }
                .mapStyle(.imagery)
                
                Button(action: {
                    withAnimation {
                        viewModel.didTapLocationButton()
                    }
                }) {
                    Image(systemName: "location.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .tint(.white)
                }
                .padding()
            }
            .frame(height: 180)
            .cornerRadius(8).clipped()
            .padding()
            
            Form {
                ForEach(viewModel.places) { place in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(place.name ?? "-")
                                .font(.headline)
                            Text(place.title ?? "-")
                                .font(.caption2)
                            if let subtitle = place.subtitle {
                                Text(subtitle)
                                    .font(.caption2)
                            }
                        }
                        Spacer()
                        Image(systemName: viewModel.highlightedPlace?.id == place.id ? "checkmark.circle" : "")
                            .renderingMode(.template)
                            .tint(.brand)
                    }
                    .onTapGesture {
                        viewModel.didTapPlace(place)
                    }
                }
            }
            .onAppear(perform: viewModel.onAppear)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        withAnimation {
                            viewModel.didTapSearchButton()
                        }
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        viewModel.didTapTrash()
                    }) {
                        Image(systemName: "trash")
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button("Save", action: {
                        viewModel.didTapSave()
                        dismiss()
                    })
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    let place = Transaction.Place(
        name: "Trem de Minas",
        title: "Restaurante",
        subtitle: "Florianópolis SC",
        latitude: -27.7074301,
        longitude: -48.5104108)
    NavigationStack {
        SelectLocationView(place: .constant(place))
    }.tint(.brand)
}
