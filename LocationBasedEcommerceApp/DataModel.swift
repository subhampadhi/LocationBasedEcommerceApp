//
//  DataModel.swift
//  LocationBasedEcommerceApp
//
//  Created by Subham Padhi on 03/02/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import Foundation

struct Result:  Codable {
    var result : [AllData]?
    var status : String?
}

struct AllData: Codable {
    var locations : [Location]?
    var id : Oid
}

struct Oid: Codable {
    var oid : String?
}

struct Location: Codable {
    
    var state: String?
    var name: String?
    var stores: [Stores]?
}

struct Stores: Codable {
    var categories: [Category]
    var storeID: Int?
}

struct Category: Codable {
    var category_name: String?
    var items: [StoreItem]?
}

struct StoreItem: Codable {
    var id: Int?
    var image_Url: String?
    var name: String?
    var price: Double?
    var type: String?
}

