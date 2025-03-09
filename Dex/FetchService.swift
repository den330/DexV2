//
//  FetchService.swift
//  Dex
//
//  Created by yaxin on 2025-03-04.
//

import Foundation

@MainActor
struct FetchService {
    enum FetchError: Error {
        case badResponse
    }
    
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon")!
    
    func fetchPokemon(_ id: Int) async throws -> Pokemon {
        let fetchURL = baseURL.appending(path: String(id))
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let pokemon = try decoder.decode(Pokemon.self, from: data)
        print("Fetched pokemon:\(pokemon.id): \(pokemon.name.capitalized)")
        return pokemon
    }
}
