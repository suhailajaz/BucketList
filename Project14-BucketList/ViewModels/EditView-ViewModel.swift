//
//  EditView-ViewModel.swift
//  Project14-BucketList
//
//  Created by suhail on 17/12/24.
//

import Foundation
import CoreLocation
import LocalAuthentication
import MapKit
import _MapKit_SwiftUI

extension EditView{
    @Observable
      class ViewModel{
          var location: Location
          var name: String
          var description: String
          var loadingState: LoadingState
          var pages: [Page]
          init(name: String, description: String,location: Location) {
              self.name = name
              self.description = description
              self.loadingState = LoadingState.loading
              self.pages = [Page]()
              self.location = location
          }
          
          func saveLocation(location : Location)-> Location{
              var newLOcation = location
              newLOcation.id = UUID()
              newLOcation.name = name
              newLOcation.description = description
              return newLOcation
          }
          func fetchNearbyPlaces() async{
              let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
              guard let url = URL(string: urlString) else{
                  print("Bad URL: \(urlString)")
                  return
              }
              
              do{
                  let (data,_) = try await URLSession.shared.data(from: url)
                  let items = try JSONDecoder().decode(Result.self, from: data)
                  
                  pages = items.query.pages.values.sorted{ $0.title < $1.title }
                  loadingState = .loaded
              }catch{
                  print("Failed to fetch data from the server)")
                 loadingState = .failed
              }

          }
    }
}
