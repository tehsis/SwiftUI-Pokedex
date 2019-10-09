//
//  PokemonDetail.swift
//  Flush
//
//  Created by Pablo Terradillos on 10/8/19.
//  Copyright © 2019 Pablo Terradillos. All rights reserved.
//

import SwiftUI

struct PokemonDetail: View {
    @ObservedObject var pokemon: PokemonStore
    
    init(pokemon: PokemonStore) {
        self.pokemon = pokemon
        self.pokemon.ensureDetails()
    }
    
    var body: some View {
        VStack {
            Text("\(pokemon.pokemon.number)")
                .font(.headline)
            Text(pokemon.pokemon.type)
                .font(.subheadline)
                .navigationBarTitle(Text(pokemon.pokemon.name.capitalized), displayMode: .inline)
        }
    }
}

struct PokemonDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PokemonDetail(pokemon: PokemonStore(pokemon: testData[0]))
        }
    }
}
