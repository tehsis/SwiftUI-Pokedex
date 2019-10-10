//
//  PokemonService.swift
//  Flush
//
//  Created by Pablo Terradillos on 10/9/19.
//  Copyright © 2019 Pablo Terradillos. All rights reserved.
//

import Foundation
import UIKit

class APIType: Decodable {
    var name: String = ""
}

class APIPokemonType: Decodable {
    var slot: Int = 0
    var type: APIType = APIType()
}

class APISprite: Decodable {
    var front_default = ""
}

class APIPokemon: Decodable {
    var id: Int? = 0
    var name: String = ""
    var url: String? = ""
    var sprites: APISprite? = APISprite()
    var types: [APIPokemonType]? = [APIPokemonType()]
}

class APIPokemons: Decodable {
    var results: [APIPokemon] = []
    var count: Int = 0
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
            
            let image = UIImageView()
            image.downloaded(from: URL(string: apiPokemon.sprites!.front_default)!)
            DispatchQueue.main.async {
                completion(Pokemon(name: apiPokemon.name, number: apiPokemon.id!, type: apiPokemon.types![0].type.name, image: image))
            }
        }.resume()
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
}
