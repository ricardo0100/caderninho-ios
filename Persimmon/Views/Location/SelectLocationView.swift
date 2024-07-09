//import SwiftUI
//import MapKit
//
//struct SelectLocationView: View {
//    @Environment(\.dismiss) var dismiss
//    @StateObject var viewModel: SelectLocationViewModel
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Map(coordinateRegion: $viewModel.region,
//                showsUserLocation: true,
//                annotationItems: viewModel.markers) { place in
//                MapMarker (coordinate: .init(
//                    latitude: place.latitude,
//                    longitude: place.longitude), tint: .brand)
//            }
//            .cornerRadius(16)
//            .frame(height: 220)
//            .padding()
//            HStack {
//                Button {
//                    viewModel.didTapLocationButton()
//                } label: {
//                    Image(systemName: "location.circle").resizable().frame(width: 24, height: 24)
//                }.buttonStyle(.bordered)
//                TextField("Search place", text: $viewModel.searchText).textFieldStyle(.roundedBorder)
//            }.padding()
//            
//            List(viewModel.placesSubject, id: \.self, selection: $viewModel.selectedPlace) { location in
//                HStack {
//                    VStack(alignment: .leading) {
//                        Text(location.title).font(.caption).bold().foregroundColor(.primary)
//                        Text(location.subtitle).font(.caption2)
//                    }
//                }
//            }
//        }
//        .onAppear(perform: viewModel.didAppear)
//        .toolbar {
//            ToolbarItem {
//                Button(action: viewModel.didTapClearButton) {
//                    Image(systemName: "clear")
//                }
//            }
//        }
//        .onReceive(viewModel.$shouldDismiss) { shouldDismiss in
//            if shouldDismiss { dismiss() }
//        }
//    }
//}
//
//struct SelectLocationView_Previews: PreviewProvider {
//    @State static var location: PlaceModel? = PlaceModel(
//        title: "HiperBom",
//        subtitle: "Florianópolis SC",
//        latitude: -27.7045892,
//        longitude: -48.5042036)
//    
//    static var previews: some View {
//        NavigationStack {
//            SelectLocationView(viewModel: SelectLocationViewModel(selectedLocation: $location)).tint(.brand)
//        }
//    }
//}
