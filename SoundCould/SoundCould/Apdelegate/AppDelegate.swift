//
//  AppDelegate.swift
//  SoundCould
//
//  Created by nguyen.van.bao on 17/05/2018.
//  Copyright © 2018 nguyen.van.bao. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var managerObContext: NSManagedObjectContext?
    static var share = AppDelegate()
    var window: UIWindow?
    var naviMucsicOff: UINavigationController!
    var naviHome: UINavigationController!
    var tabBarMain: UITabBarController!
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.managerObContext = persistentContainer.viewContext
        window = UIWindow(frame: UIScreen.main.bounds)
        self.configNavigationControllerHome()
        self.configNavigationControllerMusic()
        tabBarMain = UITabBarController()
        tabBarMain.viewControllers = [naviHome, naviMucsicOff]
        self.window?.rootViewController = tabBarMain
        self.window?.makeKeyAndVisible()
        return true
    }
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func configNavigationControllerHome() {
        let storyboardHome = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyboardHome.instantiateViewController(withIdentifier: "HomeID")
        naviHome = UINavigationController.init(rootViewController: homeViewController)
        homeViewController.tabBarItem = UITabBarItem(title: "Online", image: #imageLiteral(resourceName: "Home3"), selectedImage: #imageLiteral(resourceName: "Home3"))
        homeViewController.navigationController?.navigationBar.topItem?.title = " Sound Cloud "
        homeViewController.navigationController?.navigationBar.tintColor = .black
    }
    
    func configNavigationControllerMusic() {
        let storyboardMusic = UIStoryboard(name: "MusicOff", bundle: nil)
        let mucsicOffViewController = storyboardMusic.instantiateViewController(withIdentifier: "MusicOffView")
        naviMucsicOff = UINavigationController.init(rootViewController: mucsicOffViewController)
        mucsicOffViewController.tabBarItem = UITabBarItem(title: "Offine", image: #imageLiteral(resourceName: "music_timeline"), selectedImage: #imageLiteral(resourceName: "music_timeline"))
        mucsicOffViewController.navigationController?.navigationBar.topItem?.title = " Sound Off "
        mucsicOffViewController.navigationController?.navigationBar.tintColor = .black
    }
}
