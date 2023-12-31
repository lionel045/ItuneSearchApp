//
//  SearchApiRequest.swift
//  iTunes Store Lookup App
//
//  Created by Lion on 30/11/2023.
//

import Foundation
import UIKit

enum ApiError: Error {
    case invalidResponse
   
}
//This class aims to make query
class SearchApiRequest {
    
    static let shared = SearchApiRequest()
    
    func makeRequest(query: String) async throws -> [Track]? {
        
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(query)&media=music&country=US&&limit=25") else {
            throw URLError(.badURL)
        }
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw ApiError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let result = String(decoding: data, as: UTF8.self)
            print(result)
            let trackInfo = try  decoder.decode(TrackContainer.self, from: data)
            
            return trackInfo.results
            
        }
    }
    
    func downloadImageArtist(urlImage: URL?) async throws  -> UIImage? {
        
        guard let urlImage = urlImage else { return nil }
        
        let request = URLRequest(url: urlImage)
        let (data,response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let image = UIImage(data: data)
        
        return image
        
    }
}
    


struct Track: Codable {
    var wrapperType: String?
    var kind: String?
    var artistId: Int?
    var collectionId: Int?
    var trackId: Int?
    var artistName: String?
    var collectionName: String?
    var trackName: String?
    var collectionCensoredName: String?
    var trackCensoredName: String?
    var artistViewUrl: URL?
    var collectionViewUrl: URL?
    var trackViewUrl: URL?
    var previewUrl: URL?
    var artworkUrl30: URL?
    var artworkUrl60: URL?
    var artworkUrl100: URL?
    var collectionPrice: Double?
    var trackPrice: Double?
    var releaseDate: String?
    var collectionExplicitness: String?
    var trackExplicitness: String?
    var discCount: Int?
    var discNumber: Int?
    var trackCount: Int?
    var trackNumber: Int?
    var trackTimeMillis: Int?
    var country: String?
    var currency: String?
    var primaryGenreName: String?
    var isStreamable: Bool?
}

struct TrackContainer: Codable {
    var results: [Track]?
}


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
 
