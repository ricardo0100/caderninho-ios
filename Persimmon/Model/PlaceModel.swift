import Foundation
import CoreLocation

struct PlaceModel: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var subtitle: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
}
