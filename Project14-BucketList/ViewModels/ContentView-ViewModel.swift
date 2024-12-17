//
//  ContentView-ViewModel.swift
//  Project14-BucketList
//
//  Created by suhail on 17/12/24.
//

import Foundation
import CoreLocation
import LocalAuthentication
import MapKit
import _MapKit_SwiftUI

extension ContentView{
    @Observable
    class ViewModel{
        
        enum MapTypes{
            case standard
            case hybird
            
            var currentMap: MapStyle {
                switch self {
                case .standard:
                    return .standard
                case .hybird:
                    return .hybrid
                }
            }
            var mapSTring: String{
                switch self{
                case .standard:
                    return "Standard"
                    case .hybird:
                    return "Hybird"
                }
            }
            
            mutating func toggleMap(){
                self = (self == .standard) ? .hybird : .standard
            }
            
        }
        private(set) var locations: [Location]
        var selectedLocation: Location?
        var isUnlocked = true
        
        var mapType = MapTypes.hybird
        
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        init(){
            do{
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            }catch{
                locations = []
            }
        }
        
        
        func addNewLocation(at point: CLLocationCoordinate2D){
            let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: point.latitude, longitude: point.longitude)
           locations.append(newLocation)
            save()
        }
        
        func update(at location: Location){
            guard let selectedLocation else { return }
            if let index = locations.firstIndex(of: selectedLocation){
               locations[index] = location
                save()
            }
        }
        func save(){
            do{
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath,options: [.atomic,.completeFileProtection])
            }catch{
                print("Unable to save data.")
            }
        }
        
        func authenticate(){
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                    if success{
                        self.isUnlocked = true
                    }else{
                        //authentication error
                    }
                }
            }else{
                //no biometrics
            }
        }
    }
}
