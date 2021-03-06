//
//  AppDelegate.swift
//  raceGame
//
//  Created by Виктор Васильков on 28.03.22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if !UserDefaults.standard.bool(forKey: "firstStartedApp") {
            setFirtsStartedInitialUserDefaultsValues()
            
            let myImage = UIImage(named: AppSettings.shared.image)
            FileStorage.saveImage(myImage, withName: "ProfileImage")
        }
        
        
        UserDefaults.standard.set(true, forKey: "firstStartedApp")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    private func setFirtsStartedInitialUserDefaultsValues () {
        AppSettings.shared.name = "User"
        AppSettings.shared.speed = 120
        AppSettings.shared.carColor = "white"
        AppSettings.shared.obstacles = Obstacles(smallCar: false,
                                                 bigcar: false,
                                                 motocycle: false,
                                                 tree: false,
                                                 conus: false,
                                                 rock: true)
        AppSettings.shared.image = "ProfileImage"
        AppSettings.shared.countGames = 0
        AppSettings.shared.recordOfGame = 0
        AppSettings.shared.lastScores = ResultRace(name: "", score: 0, date: .now)
    }


}

