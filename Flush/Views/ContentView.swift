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
//    private var text: String = "char"
    @State private var text: String = "";
    private var currentPokemons: [PokemonStore] {
        get {
            return text.count > 0 ? store.pokemons.filter {
                return $0.pokemon.name.contains(text.lowercased())
            } : store.pokemons
        }
    }
    
     var body: some View {
        NavigationView {
            HStack{
                List {
                    Section {
                        TextField("Search", text: $text)
                    }
                    Section {
                        ForEach(currentPokemons) { pokemon in
                            return PokemonCell(pokemon: pokemon)
                        }
                    }
                }.navigationBarTitle(Text("Pokemon"))
            }
        }.background(Color.red)
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


struct PokemonCell: View {
    var pokemon: PokemonStore
    var body: some View {
        NavigationLink(destination: PokemonDetail(pokemon: pokemon)) {
            Image(systemName: "photo")
            VStack(alignment: .leading) {
                Text(pokemon.pokemon.name.capitalized)
                Text("\(pokemon.pokemon.number)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: PokemonsStore(pokemons: testData))
    }
}
#endif
