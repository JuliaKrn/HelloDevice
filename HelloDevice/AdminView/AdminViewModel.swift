//
//  AdminViewModel.swift
//  HelloDevice
//
//  Created by Yulia Kornichuk on 10/09/2023.
//

import Foundation

protocol AdminViewModelProtocol {
  var adminName: String? { get }
  var devices: [Device] { get }
  
  func loadMoreDevices()
  func filterDevices(with text: String)
}

class AdminViewModel: AdminViewModelProtocol {
  
  // MARK: Public properties
  
  var adminName: String?
  var devices: [Device] {
    devicesToShow
  }
  
  // MARK: Private properties
  
  weak private var adminView: AdminViewControllerProtocol?
  
  private var devicesToShow: [Device] = []
  private var fetchedDevices: [Device] = []
  
  private var currentPage: Int = 1
  private let itemsPerPage: Int = 100
  private var isLoadingData: Bool = false
  
  // MARK: Init
  
  init(adminView: AdminViewControllerProtocol) {
    self.adminView = adminView
    generateAdminName()
    loadDevices()
  }
    
  // MARK: Loading
  
  func loadMoreDevices() {
    loadDevices()
  }
  
  private func loadDevices() { 
    guard !isLoadingData else {
      return
    }
    isLoadingData = true

    Task {
      defer {
        isLoadingData = false
      }
      
      let result = await NetworkManager.sharedInstance.fetchDevices(page: currentPage, pageSize: itemsPerPage)
      
      switch result {
      case .success(let devices):
        currentPage += 1
        updateDevices(with: devices)
      case .failure(let error):
        adminView?.showErrorAlert(message: error.localizedDescription)
      }
    }
  }
  
  private func updateDevices(with devices: [Device]) {
    fetchedDevices.append(contentsOf: devices)
    devicesToShow = fetchedDevices
    adminView?.reload()
  }
  
  // MARK: Filtering
  
  func filterDevices(with text: String) {
    
    if text.isEmpty {
      devicesToShow = fetchedDevices
    } else {
      devicesToShow = fetchedDevices.filter({ device in
        guard let name = device.name?.lowercased() else {
          return false
        }
        return name.contains(text.lowercased())
      })
    }
    
    adminView?.reload()
  }
  
  // MARK: Admin Name
  
  func generateAdminName() {
    let randomName = get_admin_name()
    
    guard let text = randomName else {
      adminName = "Anonymous"
      return
    }
    
    let name = String(cString: text)
    adminName = name.capitalized
  }
}
