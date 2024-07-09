//import Foundation
//import CoreLocation
//import MapKit
//import SwiftUI
//import Combine
//
//class SelectLocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private var locationManager: CLLocationManager?
//    private let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
//    var lastAuthorizationStatus: CLAuthorizationStatus = .notDetermined
//    var cancellables: [AnyCancellable] = []
//    
//    @Binding var selectedPlace: PlaceModel? {
//        didSet {
//            guard let place = selectedPlace else {
//                markers = []
//                return
//            }
//            region = .init(center: .init(latitude: place.latitude, longitude: place.longitude), span: span)
//            markers = [place]
//        }
//    }
//    @Published var region = MKCoordinateRegion()
//    @Published var placesSubject: [PlaceModel] = []
//    @Published var searchText = ""
//    @Published var markers: [PlaceModel] = []
//    @Published var shouldDismiss = false
//    
//    required init(selectedLocation: Binding<PlaceModel?>) {
//        self._selectedPlace = selectedLocation
//        super.init()
//        $searchText
//            .debounce(for: .seconds(0.5), scheduler: OperationQueue.main)
//            .sink { value in
//                self.searchMapItems(location: .init(latitude: self.region.center.latitude,
//                                                    longitude: self.region.center.longitude),
//                                    text: value)
//            }.store(in: &cancellables)
//    }
//    
//    func didTapLocationButton() {
//        selectedPlace = nil
//        updateLocation()
//    }
//
//    func didTapClearButton() {
//        selectedPlace = nil
//        shouldDismiss = true
//    }
//    
//    func didAppear() {
//        if let place = selectedPlace {
//            region = .init(center: .init(latitude: place.latitude, longitude: place.longitude), span: span)
//            searchMapItems(location: .init(latitude: place.latitude, longitude: place.longitude), text: searchText)
//        } else {
//            updateLocation()
//        }
//    }
//    
//    func didSelectPlace(place: PlaceModel) {
//        $selectedPlace.wrappedValue = place
//        shouldDismiss = true
//    }
//    
//    private func updateLocation() {
//        if locationManager == nil {
//            locationManager = .init()
//            locationManager?.delegate = self
//        }
//        DispatchQueue.global().async { [weak self] in
//            guard CLLocationManager.locationServicesEnabled() else {
//                return
//            }
//            
//            if self?.locationManager?.authorizationStatus == .authorizedWhenInUse {
//                self?.locationManager?.requestLocation()
//            } else {
//                self?.locationManager?.requestWhenInUseAuthorization()
//            }
//        }
//    }
//    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        if manager.authorizationStatus == .authorizedWhenInUse {
//            manager.requestLocation()
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else { return }
//        region = .init(center: location.coordinate, span: span)
//        searchMapItems(location: location, text: searchText)
//    }
//    
//    func searchMapItems(location: CLLocation, text: String) {
//        let search: MKLocalSearch
//        if text.isEmpty {
//            search = .init(request: MKLocalPointsOfInterestRequest(coordinateRegion: region))
//        } else {
//            let searchRequest = MKLocalSearch.Request()
//            searchRequest.naturalLanguageQuery = text
//            searchRequest.region = MKCoordinateRegion(center: .init(latitude: location.coordinate.latitude,
//                                                                    longitude: location.coordinate.longitude),
//                                                      span: .init(latitudeDelta: 0.1,
//                                                                  longitudeDelta: 0.1))
//            search = .init(request: searchRequest)
//        }
//        
//        search.start { response, error in
//            guard let response = response else {
//                self.placesSubject = []
//                return
//            }
//            self.placesSubject = response.mapItems.map {
//                PlaceModel(title: $0.placemark.name ?? "",
//                              subtitle: $0.placemark.title ?? "",
//                              latitude: $0.placemark.coordinate.latitude,
//                              longitude: $0.placemark.coordinate.longitude)
//            }
//            
//            guard let place = self.selectedPlace else { return }
//            if let index = self.placesSubject.firstIndex(where: {
//                $0.title == place.title &&
//                $0.latitude == place.latitude &&
//                $0.longitude == place.longitude
//            }) {
//                self.placesSubject.remove(at: index)
//            }
//            self.placesSubject.insert(place, at: .zero)
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//    }
//}
