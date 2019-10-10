import SwiftUI
import Foundation

struct Pokemon: Identifiable {
    var id = UUID()
    
    var name: String
    var number: Int
    
    var type = "unknown"
    var image: UIImageView?
    
}


#if DEBUG
    let testData = [
        Pokemon(name: "Bulbasaur", number: 1, type: "plant"),
        Pokemon(name: "Charmander", number: 4, type: "fire")
    ]
#endif
