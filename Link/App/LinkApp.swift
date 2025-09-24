//
//  LinkApp.swift
//  Link
//
//  Created by 宋佳音 on 2025/03/08.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct LinkApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/*firebase缓存
 let settings = Firestore.firestore().settings
 settings.isPersistenceEnabled = true
 Firestore.firestore().settings = settings
 */
