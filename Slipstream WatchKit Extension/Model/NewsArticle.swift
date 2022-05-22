//
//  NewsArticle.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 20/05/2022.
//

import Foundation

struct NewsArticle: Codable {
    var title: String
    var date: String
    var text: String
}

var article = NewsArticle(title: "Verstappen beats Leclerc in thrilling duel in Saudi Arabia ", date: "27/03/22", text: "Max Verstappen took his first victory of the 2022 FIA Formula One World thanks to a late overtaking move past Ferrari.")

func decodeNews() -> [NewsArticle]? {
    let decoder = JSONDecoder()
    
    if let path = Bundle.main.url(forResource: "news", withExtension: "json") {
        
        let data = try? Data(contentsOf: path)
        
        if let data = data {
            let news = try? decoder.decode([NewsArticle].self, from: data)
            return news
        }
    }
    
    return nil
}

