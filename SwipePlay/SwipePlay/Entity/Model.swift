//
//  Model.swift
//  SwipePlay
//
//  Created by Wei Lu on 2024/4/27.
//

import Foundation

class ModelMediaInfo:Codable {
    var id: Int?
    var url: String?
    
    init(id: Int? = nil, url: String? = nil) {
        self.id = id
        self.url = url
    }
}
