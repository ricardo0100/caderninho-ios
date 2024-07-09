//import SwiftUI
//import MapKit
//
//struct TransactionDetailsView: View {
//    @ObservedObject var viewModel: TransactionDetailsViewModel
//    
//    var body: some View {
//        if let transaction = viewModel.transaction, let account = viewModel.account {
//            List {
//                Section {
//                    LabeledView(labelText: "Name") {
//                        Text(transaction.name)
//                    }
//                    
//                    LabeledView(labelText: "Type") {
//                        HStack(spacing: .spacingMedium) {
//                            Image(systemName: transaction.type.iconName)
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 22, height: 22)
//                                .foregroundColor(Color.secondary)
//                            Text(transaction.type.text)
//                        }
//                    }
//                    
//                    LabeledView(labelText: "Account") {
//                        HStack(spacing: .spacingMedium) {
//                            LettersIconView(text: account.name.firstLetters(),
//                                            color: Color(hex: account.color))
//                            Text(account.name).font(.title3)
//                        }
//                    }
//                    
//                    LabeledView(labelText: "Value") {
//                        Text(transaction.value.toCurrency(with: account.currency)).font(.title3)
//                    }
//                    
//                    LabeledView(labelText: "Date") {
//                        Text(transaction.date.formatted(date: .complete, time: .shortened)).font(.subheadline)
//                    }
//                    
//                    if let place = viewModel.transaction?.place {
//                        LabeledView(labelText: "Location") {
//                            VStack(alignment: .leading) {
//                                Text(place.title).font(.caption).bold().foregroundColor(.primary)
//                                Text(place.subtitle).font(.caption2)
//                            }
//                        }
//                    }
//                }  header: {
//                    if let place = transaction.place {
//                        Map(coordinateRegion: $viewModel.region,
//                            showsUserLocation: true,
//                            annotationItems: [place]) { place in
//                            MapMarker (coordinate: .init(
//                                latitude: place.latitude,
//                                longitude: place.longitude), tint: .brand)
//                        }
//                            .listRowInsets(.init(top: .zero,
//                                                 leading: .zero,
//                                                 bottom: .spacingBig,
//                                                 trailing: .zero))
//                            .cornerRadius(8)
//                            .frame(height: 180)
//                    }
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Edit", action: viewModel.didTapEdit)
//                }
//            }
//            .sheet(isPresented: $viewModel.isShowingEdit) {
//                NavigationStack {
////                    EditTransactionView(viewModel: EditTransactionViewModel(
////                        transactionId: transaction.id,
////                        transactionInteractor: TransactionInteractor(),
////                        accountInteractor: AccountInteractor()))
//                }
//            }
//        }
//    }
//}
//
//struct TransactionDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        let transactionId = TransactionModel.mockObjects.value.first!.id
//        NavigationStack {
//            TransactionDetailsView(viewModel: TransactionDetailsViewModel(transactionId: transactionId))
//        }
//    }
//}
