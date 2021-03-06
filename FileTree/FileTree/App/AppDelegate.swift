//
//  AppDelegate.swift
//  FileTree
//
//  Created by Andrii Staroselskyi on 10.06.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    let rootViewController = FileTreeController(collectionViewLayoutStyle: .table, requestsManager: RequestsManager(), directoryObjectUUID: nil, dataContainer: DirectoryDataContainer(), onDisappear: nil)
    let navigationController = UINavigationController(rootViewController: rootViewController)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()

    return true
  }

}
