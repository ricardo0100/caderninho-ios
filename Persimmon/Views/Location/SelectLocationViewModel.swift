import MapKit
import Combine
import SwiftUI

class SelectLocationViewModel: NSObject, ObservableObject {
    @Binding var selectedPlace: Transaction.Place?
    @Published var highlightedPlace: Transaction.Place? = nil
    @Published var places: [Transaction.Place] = []
    @Published var searchText = ""
    @Published var mapPosition: MapCameraPosition
    @Published var searchIsPresented = false
    private var isLocating = false
    
    private let manager = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    required init(placeBinding: Binding<Transaction.Place?>) {
        _selectedPlace = placeBinding
        highlightedPlace = placeBinding.wrappedValue
        mapPosition = .userLocation(fallback: .automatic)
        super.init()
        if let location = placeBinding.wrappedValue?.location {
            mapPosition = .camera(MapCamera(centerCoordinate: location.coordinate,
                                            distance: 1000))
        } else {
            isLocating = true
        }
        manager.delegate = self
        $searchText
            .throttle(for: 0.5, scheduler: OperationQueue.main, latest: true)
            .sink { text in
                if let coordinate = self.mapPosition.camera?.centerCoordinate {
                    self.searchLocations(in: coordinate, with: text)
                }
            }.store(in: &cancellables)
    }
    
    private func searchLocations(in coordinate: CLLocationCoordinate2D, with text: String?) {
        let search: MKLocalSearch
        if let text = text, !text.isEmpty {
            let request = MKLocalSearch.Request()
            request.region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
            request.naturalLanguageQuery = text.isEmpty ? nil : text
            search = MKLocalSearch(request: request)
        } else {
            search = MKLocalSearch(request: MKLocalPointsOfInterestRequest(center: coordinate, radius: 1000))
        }
        
        search.start { response, error in
            if let items = response?.mapItems {
                self.updatePlaces(with: items)
            }
        }
    }
    
    private func updatePlaces(with mapItems: [MKMapItem]) {
        var searchPlaces = mapItems.compactMap { mapItem in
            Transaction.Place(
                name: mapItem.name,
                title: mapItem.placemark.title,
                subtitle: mapItem.placemark.subtitle,
                latitude: mapItem.placemark.coordinate.latitude,
                longitude: mapItem.placemark.coordinate.longitude)
        }
        
        if let place = self.selectedPlace, !searchPlaces.contains(place) {
            searchPlaces.append(place)
        }
        self.places = searchPlaces.sorted {
            guard let left = $0.location, let right = $1.location else {
                return false
            }
            let userCoordinate = CLLocation(
                latitude: mapPosition.camera?.centerCoordinate.latitude ?? .zero,
                longitude: mapPosition.camera?.centerCoordinate.longitude ?? .zero)
            if selectedPlace == $0 {
                return true
            }
            return userCoordinate.distance(from: left) < userCoordinate.distance(from: right)
        }
    }
    
    func didTapLocationButton () {
        isLocating = true
        manager.requestLocation()
    }
    
    func didTapSearchButton () {
        searchIsPresented.toggle()
    }
    
    func didTapSave () {
        selectedPlace = highlightedPlace
    }
    
    func onAppear() {
        manager.requestWhenInUseAuthorization()
        searchText = ""
        searchIsPresented = false
    }
    
    func didTapPlace(_ place: Transaction.Place) {
        highlightedPlace = place
        searchIsPresented = false
        if let coordinate = place.location {
            withAnimation {
                mapPosition = .camera(MapCamera(centerCoordinate: coordinate.coordinate, distance: 1000))
            }
        }
    }
    
    func didTapTrash() {
        selectedPlace = nil
        highlightedPlace = nil
    }
}

extension SelectLocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard isLocating,
              let coordinate = locations.first?.coordinate
        else { return }
        withAnimation {
            mapPosition = .camera(MapCamera(centerCoordinate: coordinate, distance: 1000))
        }
        searchLocations(in: coordinate, with: searchText)
        isLocating = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        manager.requestLocation()
    }
}
