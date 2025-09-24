//
//  FirebaseStorageHelper.swift
//  Link
//
//  Created by Assistant on 2025/01/27.
//

import Foundation
import FirebaseStorage

class FirebaseStorageHelper {
    static let shared = FirebaseStorageHelper()
    
    private init() {}
    
    /// 检查Firebase Storage是否可访问
    func checkStorageAccess() {
        print("=== Firebase Storage Access Check ===")
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        print("Storage Bucket: \(storage.reference().bucket)")
        print("Storage App: \(storage.app.name)")
        
        // 测试基本的存储访问
        let testRef = storageRef.child("test_access")
        testRef.getMetadata { metadata, error in
            if let error = error {
                print("Storage Access Error: \(error.localizedDescription)")
                if let nsError = error as NSError? {
                    print("Error Code: \(nsError.code)")
                    print("Error Domain: \(nsError.domain)")
                }
            } else {
                print("Storage Access: SUCCESS")
            }
        }
        
        print("================================")
    }
    
    /// 检查特定图片文件是否存在
    func checkImageExists(imageUrl: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: imageUrl) else {
            completion(false, NSError(domain: "FirebaseStorageHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        // 从URL中提取文件路径
        let pathComponents = url.pathComponents
        guard pathComponents.count > 2 else {
            completion(false, NSError(domain: "FirebaseStorageHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid Firebase Storage URL"]))
            return
        }
        
        // 构建存储引用
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        // 提取文件路径（跳过开头的斜杠和域名部分）
        let filePath = pathComponents.dropFirst(2).joined(separator: "/")
        print("DEBUG: Checking file path: \(filePath)")
        
        let fileRef = storageRef.child(filePath)
        
        fileRef.getMetadata { metadata, error in
            if let error = error {
                print("DEBUG: File check error: \(error.localizedDescription)")
                completion(false, error)
            } else if let metadata = metadata {
                print("DEBUG: File exists: \(metadata.name)")
                print("DEBUG: File size: \(metadata.size) bytes")
                print("DEBUG: File type: \(metadata.contentType ?? "unknown")")
                completion(true, nil)
            } else {
                print("DEBUG: No metadata received")
                completion(false, NSError(domain: "FirebaseStorageHelper", code: 404, userInfo: [NSLocalizedDescriptionKey: "No metadata"]))
            }
        }
    }
    
    /// 获取图片的下载URL（如果当前URL过期）
    func getFreshDownloadURL(for imageUrl: String, completion: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: imageUrl) else {
            completion(nil, NSError(domain: "FirebaseStorageHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        let pathComponents = url.pathComponents
        guard pathComponents.count > 2 else {
            completion(nil, NSError(domain: "FirebaseStorageHelper", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid Firebase Storage URL"]))
            return
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let filePath = pathComponents.dropFirst(2).joined(separator: "/")
        
        let fileRef = storageRef.child(filePath)
        
        fileRef.downloadURL { url, error in
            if let error = error {
                print("DEBUG: Failed to get fresh download URL: \(error.localizedDescription)")
                completion(nil, error)
            } else if let url = url {
                print("DEBUG: Fresh download URL: \(url.absoluteString)")
                completion(url.absoluteString, nil)
            } else {
                completion(nil, NSError(domain: "FirebaseStorageHelper", code: 500, userInfo: [NSLocalizedDescriptionKey: "No URL returned"]))
            }
        }
    }
} 