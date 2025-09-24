//
//  CreateLinkViewModel.swift
//  Link
//
//  Created by KAON SOU on 2025/03/21.
//

import Firebase
import FirebaseAuth
import CoreLocation

class CreateLinkViewModel: ObservableObject {
    func uploadLink(caption: String, location: CLLocation?) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let locationName = try await getLocationName(from: location)
        
        let link = Link(
            ownerUid: uid,
            caption: caption,
            timestamp: Timestamp(),
            likes: 0,
            location: locationName
        )
        
        try await LinkService.uploadLink(link)
    }
    
    private func getLocationName(from location: CLLocation?) async throws -> String? {
        guard let location = location else { return nil }
        
        return try await withCheckedThrowingContinuation { continuation in
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    guard let placemark = placemarks?.first else {
                        continuation.resume(returning: "")
                        return
                    }
                    
                    let country = placemark.country ?? ""
                    let administrativeArea = placemark.administrativeArea ?? ""
                    let locality = placemark.locality ?? ""
                    let subLocality = placemark.subLocality ?? ""
                    
                    let locationName: String
                    if locality.isEmpty || locality == administrativeArea {
                        locationName = "\(country)\(locality)\(subLocality)"
                    } else {
                        locationName = "\(country)\(administrativeArea)\(locality)\(subLocality)"
                    }
                    
                    continuation.resume(returning: locationName)
                }
            }
        }
    }
}

extension Notification.Name {
    static let linkPosted = Notification.Name("linkPosted")
}
