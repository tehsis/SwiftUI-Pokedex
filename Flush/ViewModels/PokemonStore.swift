//
//  PokemonStore.swift
//  Flush
//
//  Created by Pablo Terradillos on 10/8/19.
//  Copyright © 2019 Pablo Terradillos. All rights reserved.
//

import SwiftUI
import Combine

final class PokemonsStore: ObservableObject {
    var pokemons: [PokemonStore] {
        didSet {
            objectWillChange.send()
        }
    }
    
    init(pokemons:[Pokemon] = []) {
        self.pokemons = pokemons.map {PokemonStore(pokemon: $0)}
        fetchPokemons()
    }
    
    private func fetchPokemons() {
        PokemonService().getAll {
            self.pokemons = $0.map {PokemonStore(pokemon: $0)}
        }
    }
    
    var objectWillChange = PassthroughSubject<Void, Never>()
}

final class PokemonStore: ObservableObject, Identifiable {
    var id: UUID {
        get {
            pokemon.id
        }
    }
    var pokemon: Pokemon {
        didSet {
            objectWillChange.send()
        }
    }
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    public func ensureDetails() {
        if (self.pokemon.type == "unknown") {
            PokemonService().get(pokemon: self.pokemon) { pokemonWithDetails in
                self.pokemon =  pokemonWithDetails
            }
        }
    }
    
    var objectWillChange = PassthroughSubject<Void, Never>()
}
