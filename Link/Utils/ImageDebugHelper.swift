//
//  ImageDebugHelper.swift
//  Link
//
//  Created by Assistant on 2025/01/27.
//

import Foundation
import UIKit

class ImageDebugHelper {
    static let shared = ImageDebugHelper()
    
    private init() {}
    
    /// 验证图片URL是否有效
    func validateImageURL(_ urlString: String?) -> Bool {
        guard let urlString = urlString, !urlString.isEmpty else {
            print("DEBUG: Image URL is nil or empty")
            return false
        }
        
        guard let url = URL(string: urlString) else {
            print("DEBUG: Invalid URL format: \(urlString)")
            return false
        }
        
        guard url.scheme != nil else {
            print("DEBUG: URL missing scheme: \(urlString)")
            return false
        }
        
        print("DEBUG: Valid image URL: \(urlString)")
        return true
    }
    
    /// 测试图片URL是否可访问
    func testImageURL(_ urlString: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(false, NSError(domain: "ImageDebugHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL format"]))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("DEBUG: Network error for image URL \(urlString): \(error.localizedDescription)")
                completion(false, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("DEBUG: HTTP response for \(urlString): \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    if let data = data, data.count > 0 {
                        print("DEBUG: Image data received: \(data.count) bytes")
                        completion(true, nil)
                    } else {
                        print("DEBUG: No image data received for \(urlString)")
                        completion(false, NSError(domain: "ImageDebugHelper", code: 204, userInfo: [NSLocalizedDescriptionKey: "No image data"]))
                    }
                } else {
                    print("DEBUG: HTTP error for \(urlString): \(httpResponse.statusCode)")
                    completion(false, NSError(domain: "ImageDebugHelper", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP error: \(httpResponse.statusCode)"]))
                }
            } else {
                print("DEBUG: Invalid response for \(urlString)")
                completion(false, NSError(domain: "ImageDebugHelper", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
            }
        }
        
        task.resume()
    }
    
    /// 打印用户头像信息用于调试
    func debugUserProfileImage(_ user: User?) {
        print("=== User Profile Image Debug ===")
        print("User ID: \(user?.id ?? "nil")")
        print("Username: \(user?.username ?? "nil")")
        print("Profile Image URL: \(user?.profileImageUrl ?? "nil")")
        
        if let imageUrl = user?.profileImageUrl {
            let isValid = validateImageURL(imageUrl)
            print("URL Valid: \(isValid)")
            
            if isValid {
                testImageURL(imageUrl) { success, error in
                    print("URL Accessible: \(success)")
                    if let error = error {
                        print("Access Error: \(error.localizedDescription)")
                    }
                }
            }
        }
        print("================================")
    }
} 