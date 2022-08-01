//
//  BeerResponse.swift
//  RandomBeerPicker
//
//  Created by 강민혜 on 8/1/22.
//

import Foundation

// MARK: - BeerResponseElement
struct BeerResponseElement: Decodable {
    let id: Int
    let name, tagline, firstBrewed, beerResponseDescription: String
    let imageURL: JSONNull?
    let abv: Double
    let ibu, targetFg, targetOg, ebc: Int
    let srm: Int
    let ph: Double
    let attenuationLevel: Int
    let volume, boilVolume: BoilVolume
    let method: Method
    let ingredients: Ingredients
    let foodPairing: [String]
    let brewersTips, contributedBy: String

    enum CodingKeys: String, CodingKey {
        case id, name, tagline
        case firstBrewed = "first_brewed"
        case beerResponseDescription = "description"
        case imageURL = "image_url"
        case abv, ibu
        case targetFg = "target_fg"
        case targetOg = "target_og"
        case ebc, srm, ph
        case attenuationLevel = "attenuation_level"
        case volume
        case boilVolume = "boil_volume"
        case method, ingredients
        case foodPairing = "food_pairing"
        case brewersTips = "brewers_tips"
        case contributedBy = "contributed_by"
    }
}

// MARK: - BoilVolume
struct BoilVolume: Decodable {
    let value: Double
    let unit: String
}

// MARK: - Ingredients
struct Ingredients: Decodable {
    let malt: [Malt]
    let hops: [Hop]
    let yeast: String
}

// MARK: - Hop
struct Hop: Decodable {
    let name: String
    let amount: BoilVolume
    let add, attribute: String
}

// MARK: - Malt
struct Malt: Decodable {
    let name: String
    let amount: BoilVolume
}

// MARK: - Method
struct Method: Decodable {
    let mashTemp: [MashTemp]
    let fermentation: Fermentation
    let twist: JSONNull?

    enum CodingKeys: String, CodingKey {
        case mashTemp = "mash_temp"
        case fermentation, twist
    }
}

// MARK: - Fermentation
struct Fermentation: Decodable {
    let temp: BoilVolume
}

// MARK: - MashTemp
struct MashTemp: Decodable {
    let temp: BoilVolume
    let duration: Int
}

typealias BeerResponse = [BeerResponseElement]

// MARK: - Encode/decode helpers

class JSONNull: Decodable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
