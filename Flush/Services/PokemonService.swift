//
//  PokemonService.swift
//  Flush
//
//  Created by Pablo Terradillos on 10/9/19.
//  Copyright © 2019 Pablo Terradillos. All rights reserved.
//

import Foundation

class APIPokemonType: Decodable {
    var slot: Int
    var type: String
}

class APIPokemon: Decodable {
    var id: Int?
    var name: String
    var url: String
    var types: [APIPokemonType]?
}

class APIPokemons: Decodable {
    var results: [APIPokemon] = []
    var count: Int?
    var next: String?
    var previous: String?
}

class PokemonService {
    
    func getAll(completion: @escaping ([Pokemon]) -> ()) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon") else {
            fatalError("URL is not correct!")
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            let apiPokemons = try!
                JSONDecoder().decode(APIPokemons.self, from: data!)
            
            let pokemons = apiPokemons.results.enumerated().map { (index, pkmn) in
                return Pokemon(name: pkmn.name, number: index + 1)
            }
            
            DispatchQueue.main.async {
                completion(pokemons)
            }
        }.resume()
    }
    
    func get(pokemon: Pokemon, completion: @escaping (Pokemon) -> ()) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemon.name)") else {
            fatalError("URL is not correct!")
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            let apiPokemon = try!
                JSONDecoder().decode(APIPokemon.self, from: data!)
            
            
            DispatchQueue.main.async {
                completion(Pokemon(name: apiPokemon.name, number: apiPokemon.id!, type: apiPokemon.types![0].type))
            }
        }
    }
   
    
    
}
