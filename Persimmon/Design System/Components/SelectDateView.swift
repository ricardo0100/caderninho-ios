import SwiftUI

struct SelectDateView: View {
    @Binding var isShowing: Bool
    @Binding var date: Date
    
    var body: some View {
        Form {
            HStack(spacing: .spacingHuge) {
                Button("Today") {
                    date = Date()
                }.buttonStyle(.plain)
                Button("Yesterday") {
                    date = Date.yesterday()
                }.buttonStyle(.plain)
            }
            DatePicker("", selection: $date)
                .datePickerStyle(.graphical)
                
        }
        .onChange(of: date) {
            isShowing = false
        }
        .tint(.brand)
    }
}

struct SelectDateView_Previews: PreviewProvider {
    @State static var date = Date()
    
    static var previews: some View {
        SelectDateView(isShowing: .constant(true), date: $date)
    }
}
