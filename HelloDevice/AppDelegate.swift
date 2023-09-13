//
//  AppDelegate.swift
//  HelloDevice
//
//  Created by Yulia Kornichuk on 10/09/2023.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
  
  var window: NSWindow!

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let storyboard = NSStoryboard(name: "Main", bundle: nil)
    
    if let viewController = storyboard.instantiateController(withIdentifier: "AdminViewController") as? AdminViewController {
      
      let viewModel = AdminViewModel(adminView: viewController)
      viewController.viewModel = viewModel
      
      window = NSWindow(contentViewController: viewController)
      window.makeKeyAndOrderFront(nil)
    }
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }

  func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }


}

