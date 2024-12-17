//
//  EditView.swift
//  Project14-BucketList
//
//  Created by suhail on 15/12/24.
//

import SwiftUI

struct EditView: View {
    enum LoadingState{
        case loading, loaded, failed
    }
    
    @Environment(\.dismiss) var dismiss
    @State private var viewModel: ViewModel
    
    var onSave: (Location) -> Void
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    TextField("Place Name",text: $viewModel.name)
                    TextField("Decsription", text: $viewModel.description)
                }
                
                Section("Nearby..."){
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading ...")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid){ page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.terms?.description?.first ?? "No description availible")
                                .italic()
                        }
                    case .failed:
                        Text("Failed ...")

                    }
                }
            }
            .navigationTitle("Place Details")
            .toolbar{
                Button("Save"){
                    
                    let newLocation = viewModel.saveLocation(location: viewModel.location)
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }

    }
    
    init(location: Location, onSave: @escaping (Location)->Void){
        self.onSave = onSave
        

        _viewModel = State(initialValue: ViewModel(name: location.name, description: location.description, location: location))
       
    }
 
}

#Preview {
    EditView(location: .dummyLocation){ _ in}
}
