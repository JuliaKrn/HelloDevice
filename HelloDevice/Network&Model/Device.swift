//
//  Device.swift
//  HelloDevice
//
//  Created by Yulia Kornichuk on 10/09/2023.
//

import Foundation

struct DevicesResult: Decodable {
  let devices: [Device]
}

struct Device: Decodable {
  //let id: Int
  let name: String?
  let code: String?
  let latestScanDate: String?
}
