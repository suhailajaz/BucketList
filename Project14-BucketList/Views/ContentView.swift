//
//  ContentView.swift
//  Project14-BucketList
//
//  Created by suhail on 14/12/24.
//

import SwiftUI
import MapKit


struct ContentView: View {
    
    let startPosition = MapCameraPosition.region(
    MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 56, longitude: -3), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    )
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked{
            ZStack{
                MapReader { proxy in
                    Map(initialPosition: startPosition){
                        ForEach(viewModel.locations){ location in
                            Annotation(location.name, coordinate: location.coordinates) {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44,height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onLongPressGesture {
                                        viewModel.selectedLocation = location
                                    }
                            }
                        }
                    }.mapStyle(viewModel.mapType.currentMap)
                        .onTapGesture { position in
                            if let coordinates = proxy.convert(position, from: .local){
                                viewModel.addNewLocation(at: coordinates)
                            }
                        }
                        .sheet(item: $viewModel.selectedLocation) { place in
                            EditView(location: place) { newLocation in
                                viewModel.update(at: newLocation)
                            }
                        }
                    
                }
                VStack(){
                    HStack{
                        Spacer()
                        Button(viewModel.mapType.mapSTring){
                            viewModel.mapType.toggleMap()
                        }

                        .padding()
                        .foregroundStyle(.white)
                        .border(.yellow, width: 0.3)
                        .font(.headline)
                        .background(.yellow)
                        .clipShape(.rect(cornerRadius: 12))

                    }
                        Spacer()
                    
                }
            }

            
        }
        else{
            Button("Unlock Places",action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
        }
    }
}
#Preview {
    ContentView()
}
