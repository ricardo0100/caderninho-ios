import SwiftUI

struct SelectDateView: View {
    @Binding var date: Date
    
    var body: some View {
        Form {
            Button("Now") {
                date = Date()
            }
            Button("Yesterday") {
                date = Date.yesterday()
            }
            DatePicker("", selection: $date)
                .datePickerStyle(.graphical)
        }
        .tint(.brand)
    }
}

struct SelectDateView_Previews: PreviewProvider {
    @State static var date = Date()
    
    static var previews: some View {
        SelectDateView(date: $date)
    }
}
