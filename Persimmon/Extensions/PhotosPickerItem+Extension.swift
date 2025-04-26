import SwiftUI
import PhotosUI

extension PhotosPickerItem: @retroactive Identifiable {
    public var id: String {
        UUID().uuidString
    }
}
