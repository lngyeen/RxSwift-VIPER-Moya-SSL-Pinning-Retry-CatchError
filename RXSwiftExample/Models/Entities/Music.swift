//
//  Music.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/22/21.
//

import Foundation

struct Music: Codable {
    var artistName: String
    var id: String
    var releaseDate: String
    var name: String
    var url: String
    var artworkUrl100: String
    
    var isLiked: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case artistName
        case id
        case releaseDate
        case name
        case url
        case artworkUrl100
    }
}

extension Music: Hashable {
    
}

public struct MusicResults: Codable {
  var results: [Music]
}

public struct FeedResults: Codable {
  var feed: MusicResults
}

enum NetworkingError: Error {
    case invalidURL(String)
    case invalidParameter(String, Any)
    case invalidJSON(String)
    case invalidDecoderConfiguration
}

extension CodingUserInfoKey {
    static let contentIdentifier = CodingUserInfoKey(rawValue: "contentIdentifier")!
}

struct NetworkingResult<Content: Decodable>: Decodable {
    
    let content: Content
    
    private struct CodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int? = nil
        
        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = 0
        }
        
        init?(intValue: Int) {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        guard let ci = decoder.userInfo[CodingUserInfoKey.contentIdentifier],
              let contentIdentifier = ci as? String,
              let key = CodingKeys(stringValue: contentIdentifier) else {
                  throw NetworkingError.invalidDecoderConfiguration
              }
        
        do {
            let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
            content = try container.decode(Content.self, forKey: key)
        } catch {
            throw error
        }
    }
}
