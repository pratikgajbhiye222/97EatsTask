//
//  HomeModel.swift
//  97TextApi
//
//  Created by Vinay Gajbhiye on 17/01/22.
//

import Foundation

// MARK: - Home Model
struct HomeModel: Codable {
    let data: [Datum]?
    let total, page, limit: Int?
}

// MARK: - Datum
struct Datum: Codable {
    let id, title, firstName, lastName: String?
    let picture: String?
}
