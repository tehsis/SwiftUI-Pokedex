//
//  ContentView.swift
//  Flush
//
//  Created by Pablo Terradillos on 10/8/19.
//  Copyright © 2019 Pablo Terradillos. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var store = PokemonsStore()
    
     var body: some View {
        NavigationView {
            List {
                Section {
                    Button(action: addPokemon) {
                        Text("Add Pokemon")
                    }
                }
                
                Section {
                    ForEach(store.pokemons) { pokemon in
                        return PokemonCell(pokemon: pokemon)
                    }.onDelete(perform: delPokemon)
                    .onMove(perform: movePokemon)
                }
            }.navigationBarTitle(Text("Pokemon"))
        }
    }
    
    func movePokemon(from source: IndexSet, to destination: Int) {
        if let first = source.first {
            store.pokemons.swapAt(first, destination)
        }
    }
    
    func delPokemon(at offSets: IndexSet) {
        if let IndexToDelete = offSets.first {
            store.pokemons.remove(at: IndexToDelete)
        }
    }
    
    func addPokemon() {
        store.pokemons.append(PokemonStore(pokemon: Pokemon(name: "Squirtle", number: 6, type: "water")))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: PokemonsStore(pokemons: testData))
    }
}

struct PokemonCell: View {
    var pokemon: PokemonStore
    @State private var captured = false
    var body: some View {
        NavigationLink(destination: PokemonDetail(pokemon: pokemon)) {
            Image(systemName: "photo")
            VStack(alignment: .leading) {
                Text(pokemon.pokemon.name.capitalized)
                Text("\(pokemon.pokemon.number)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Toggle(isOn: $captured) {
                    Text("is captured?").font(.footnote)
                }
            }
        }
    }
}
