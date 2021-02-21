//
//  AppDelegate.swift
//  ToDo202102
//
//  Created by Chihiro Nishiwaki on 2021/02/15.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //realmの更新設定
        // マイグレーション処理
        migration()
        let realm = try! Realm()
        return true
    }

    // Realmマイグレーション処理
    func migration() {
        // 次のバージョン（現バージョンが1、2をセット）
        let nextSchemaVersion: UInt64 = 0
        // マイグレーション設定
        let config = Realm.Configuration(
            schemaVersion: nextSchemaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < nextSchemaVersion) {
                }
            })
        Realm.Configuration.defaultConfiguration = config
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


}

