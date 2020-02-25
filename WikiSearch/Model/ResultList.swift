//
//  ResultList.swift
//  WikiSearch
//
//  Created by Ivan Fabri on 2/18/20.
//  Copyright © 2020 Ivan Fabri. All rights reserved.
//

import Foundation
import UIKit

struct ResultList: Codable {
    let query: QueryList
}

struct QueryList: Codable {
    let search: [PageList]
}

struct PageList: Codable {
    let title: String
    let pageid: Int
    let snippet: String
}
