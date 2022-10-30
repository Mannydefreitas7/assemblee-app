//
//  AssembleeApp.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/9/22.
//

import SwiftUI
import Firebase
import FirebaseAppCheck


@main
struct AssembleeApp: App {
    
#if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#endif
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

#if os(iOS)
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
       // let providerFactory = AppCheckDebugProviderFactory()
      //  AppCheck.setAppCheckProviderFactory(providerFactory)
        
        FirebaseApp.configure()
        return true
    }
}
#endif
