//
//  ResultDetails.swift
//  WikiSearch
//
//  Created by Ivan Fabri on 2/18/20.
//  Copyright © 2020 Ivan Fabri. All rights reserved.
//

import Foundation
import UIKit

struct ResultDetails: Codable {
    var query: QueryDetails
}

struct QueryDetails: Codable {
    var pages: [String: PageDetails]
}

struct PageDetails: Codable {
    var extract :String
}
