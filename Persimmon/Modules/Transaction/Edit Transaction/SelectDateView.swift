import SwiftUI

struct SelectDateView: View {
    @Binding var date: Date
    
    var body: some View {
        Form {
            VStack(alignment: .leading) {
                DatePicker("", selection: $date)
                    .datePickerStyle(.graphical)
                
                HStack {
                    Button("Today") {
                        date = Date()
                    }.buttonStyle(.automatic)
                    
                    Button("Yesterday") {
                        date = Date.yesterday()
                    }.buttonStyle(.automatic)
                }
            }
        }.tint(.brand)
    }
}

struct SelectDateView_Previews: PreviewProvider {
    @State static var date = Date()
    
    static var previews: some View {
        SelectDateView(date: $date)
    }
}
