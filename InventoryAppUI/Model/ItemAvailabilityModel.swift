//
//  ItemAvailabilityModel.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 04/01/25.
//

import Foundation

struct ItemAvailabilityModel : Codable {
    let status : Bool?
    let message : String?
    let data : [String]?
    let error : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
        case error = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([String].self, forKey: .data)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}
