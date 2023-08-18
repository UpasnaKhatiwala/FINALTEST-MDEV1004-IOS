//
//  Games.swift
//  MDEV1004-iOS
//
//  Created by Upasna Khatiwala on 2023-08-18.
//

struct Games: Codable
{
    let _id: String
    let ID: Int32
    let title: String
    let platforms: [String]
    let genres: [String]
    let developers: String
    let designers: String
    let publishers: String
    let description: String
    let imageURL: String
    let modes: [String]
    let artists: String
    let rating: Double
    let releaseDate: String

}
