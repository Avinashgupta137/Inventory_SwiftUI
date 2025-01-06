//
//  GetAllCartList.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 13/12/24.
//

import Foundation

struct GetAllCartList : Codable {
    let status : Bool?
    let message : String?
    let data : [CartList]?
    let error : ErrorDetail?

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
        data = try values.decodeIfPresent([CartList].self, forKey: .data)
        error = try values.decodeIfPresent(ErrorDetail.self, forKey: .error)
    }

}

struct ErrorDetail: Codable {
    let code: Int?
    let message: String?
}
struct CartList : Codable {
    let iTEM_MASTER_ID : String?
    let id : String?
    let user_id : String?
    let iTEM_NAME : String?
    let mODEL_NO : String?
    let bRAND : String?
    let sR_NUMBER : String?
    let iTEM_THUMBNAIL : String?
    var items_in_cart : Int?

    enum CodingKeys: String, CodingKey {
        case iTEM_MASTER_ID = "ITEM_MASTER_ID"
        case id = "id"
        case user_id = "user_id"
        case iTEM_NAME = "ITEM_NAME"
        case mODEL_NO = "MODEL_NO"
        case bRAND = "BRAND"
        case sR_NUMBER = "SR_NUMBER"
        case iTEM_THUMBNAIL = "ITEM_THUMBNAIL"
        case items_in_cart = "items_in_cart"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        iTEM_MASTER_ID = try values.decodeIfPresent(String.self, forKey: .iTEM_MASTER_ID)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        iTEM_NAME = try values.decodeIfPresent(String.self, forKey: .iTEM_NAME)
        mODEL_NO = try values.decodeIfPresent(String.self, forKey: .mODEL_NO)
        bRAND = try values.decodeIfPresent(String.self, forKey: .bRAND)
        sR_NUMBER = try values.decodeIfPresent(String.self, forKey: .sR_NUMBER)
        iTEM_THUMBNAIL = try values.decodeIfPresent(String.self, forKey: .iTEM_THUMBNAIL)
        items_in_cart = try values.decodeIfPresent(Int.self, forKey: .items_in_cart)
    }

}


struct AddRemoveData : Codable {
    let status : Bool?
    let message : String?
    let data : Bool?
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
        data = try values.decodeIfPresent(Bool.self, forKey: .data)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}
