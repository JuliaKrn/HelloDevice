//
//  ViewController.swift
//  HelloDevice
//
//  Created by Yulia Kornichuk on 10/09/2023.
//

import Cocoa

protocol AdminViewControllerProtocol: AnyObject {
  func reload()
  func showErrorAlert(message: String)
}

class AdminViewController: NSViewController, AdminViewControllerProtocol {

  // MARK: Outlets & Properties
  
  @IBOutlet private weak var adminNameTextFiled: NSTextField!
  @IBOutlet private weak var searchField: NSSearchField!
  @IBOutlet private weak var scrollView: NSScrollView!
  @IBOutlet private weak var tableView: NSTableView!
  
  private let dateFormatter = DateFormatter()
  
  var viewModel: AdminViewModelProtocol!
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    if let adminName = viewModel.adminName {
      adminNameTextFiled.stringValue = "Admin: \(adminName)"
    }
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(scrollViewDidScroll(_:)),
      name: NSView.boundsDidChangeNotification,
      object: scrollView.contentView
    )
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: Protocol conformance
  
  func reload() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
  
  func showErrorAlert(message: String) {
    DispatchQueue.main.async {
      let alert = NSAlert()
      alert.messageText = "Error"
      alert.informativeText = message
      alert.alertStyle = .critical
      alert.addButton(withTitle: "OK")
      alert.addButton(withTitle: "Retry")
      
      let response = alert.runModal()
    
      switch response {
      case .alertFirstButtonReturn:
        break
      case .alertSecondButtonReturn:
        self.retryLoad()
      default:
        break
      }
      
    }
  }
  
  private func retryLoad() {
    viewModel.loadMoreDevices()
  }
  
  // MARK: Search
  
  func controlTextDidChange(_ notification : Notification) {
    guard let field = notification.object as? NSSearchField,
          field == self.searchField else {
      return
    }
    viewModel.filterDevices(with: field.stringValue)
  }
  
  // MARK: Lazy loading
  
  @objc private func scrollViewDidScroll(_ notification: Notification) {
    guard let scrollView = notification.object as? NSClipView else {
      return
    }
    
    let visibleRect = scrollView.visibleRect
    let maxScrollY = scrollView.documentRect.height - visibleRect.height
    let currentScrollY = visibleRect.origin.y
    let threshold: CGFloat = 100.0
    
    if (maxScrollY - currentScrollY) < threshold {
      viewModel.loadMoreDevices()
    }
  }
}

// MARK: - NSTableViewDataSource & NSTableViewDelegate

extension AdminViewController: NSTableViewDataSource, NSTableViewDelegate {
  func numberOfRows(in tableView: NSTableView) -> Int {
    return viewModel.devices.count
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    guard let identifier = tableColumn?.identifier,
          let cell = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView else {
      return nil
    }
    
    let deviceModel = viewModel.devices[row]

    var text: String?
    switch identifier.rawValue {
    case "name":
      text = deviceModel.name
    case "date":
      text = formatScanDate(deviceModel.latestScanDate)
    case "code":
      text = deviceModel.code
    default:
      break
    }

    cell.textField?.stringValue = text ?? "-"
    return cell
  }
  
  private func formatScanDate(_ dateString: String?) -> String? {
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
    
    guard let dateString, let date = dateFormatter.date(from: dateString) else {
      return nil
    }
    
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    return  dateFormatter.string(from: date)
  }
}


