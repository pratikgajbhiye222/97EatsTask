//
//  userModel.swift
//  97TextApi
//
//  Created by Vinay Gajbhiye on 17/01/22.
//

import Foundation

// MARK: - Welcome
struct UserModel: Codable {
    let id, title, firstName, lastName: String?
    let picture: String?
    let gender, email, dateOfBirth, phone: String?
    let location: Location?
    let registerDate, updatedDate: String?
}

// MARK: - Location
struct Location: Codable {
    let street, city, state, country: String?
    let timezone: String?
}
