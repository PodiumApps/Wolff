import Foundation

enum Global {
    
    #if DEBUG
        static var url: String = "https://slipstream.perguntashamuitas.com/api"
    #else
        static var url: String = "https://slipstream.tomasmamede.com/api"
    #endif
}
