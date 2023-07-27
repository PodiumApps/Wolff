//
//  Document.swift
//  Slipstream Watch App
//
//  Created by Tomás Mamede on 27/07/2023.
//

import Foundation

struct Document: Codable {

    var sections = [Section]()

    struct Section: Codable {

        var title: String
        var paragraphs: [String]
    }

    func decodeJSON(filename: String) -> Document {

        if let filePath = Bundle.main.url(forResource: filename, withExtension: "json") {

            do {

                let data = try Data(contentsOf: filePath)
                print(data)
                let document = try JSONDecoder().decode(Document.self, from: data)

                return document

            } catch {
                fatalError("Could not decode JSON file")
            }
        }

        fatalError("Could not find file named \(filename)")
    }
}
