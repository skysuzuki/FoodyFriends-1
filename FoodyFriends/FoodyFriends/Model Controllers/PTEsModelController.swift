//
//  PTEsModelController.swift
//  FoodyFriends
//
//  Created by Lambda_School_Loaner_204 on 10/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class PlacesToEatController  {
    
    // MARK: Properties
    var placesToEat = [PlaceToEat]()
    
    init () {
        loadFromPersistentStore()
    }
    // MARK: - Class Functions
    func createPlaceToEat(_ name: String, _ address: String, _ description: String,
                          _ scheduledDate: Date, _ imageData: Data) {
        let placeToEat = PlaceToEat(name: name, address: address, description: description, scheduledDate: scheduledDate, image: imageData)
        placesToEat.append(placeToEat)
        
        saveToPersistentStore()
    }
    
    func editPlaceToEat(_ placeToEat: PlaceToEat,
                        updatedName name: String,
                        updatedAddress address: String,
                        updatedDescription description: String,
                        updatedDate scheduledDate: Date,
                        updatedImage imageData: Data) {
        if let pteIndex = placesToEat.firstIndex(of: placeToEat) {
            placesToEat[pteIndex].name = name
            placesToEat[pteIndex].address = address
            placesToEat[pteIndex].description = description
            placesToEat[pteIndex].scheduledDate = scheduledDate
            placesToEat[pteIndex].image = imageData
            saveToPersistentStore()
        }
    }
    
    func deletePlaceToEat(_ placeToEat: PlaceToEat) {
        guard let pteIndex = placesToEat.firstIndex(of: placeToEat) else { return }
        placesToEat.remove(at: pteIndex)
        saveToPersistentStore()
    }
    
    // MARK: - Persistence
    
    private var placesToEatURL: URL? {
        let fm = FileManager.default
        guard let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let filename = "PlacesToEat.plist"
        return dir.appendingPathComponent(filename)
    }
        
    private func saveToPersistentStore() {
        guard let url = placesToEatURL else { return }
        
        do {
            let encoder = PropertyListEncoder()
            let pteData = try encoder.encode(placesToEat)
            try pteData.write(to: url)
        } catch {
            print("Error saving places to eat data: \(error)")
        }
    }
    
    private func loadFromPersistentStore() {
        let fm = FileManager.default
        guard let url = placesToEatURL,
            fm.fileExists(atPath: url.path) else { return }
        
        do {
            let pteData = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            let decodedPlacesToEat = try decoder.decode([PlaceToEat].self, from: pteData)
            placesToEat = decodedPlacesToEat
        } catch {
            print("Error loading places to eat data: \(error)")
        }
    }
}
