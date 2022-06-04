//
//  NewsData.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 04/06/2022.
//

struct NewsData: Codable {
    var news: [NewsArticle]
    
    enum CodingKeys: String, CodingKey {
        case news = "data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        news = try container.decodeIfPresent([NewsArticle].self, forKey: .news) ?? []
    }
}
