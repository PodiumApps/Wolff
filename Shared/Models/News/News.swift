//
//  News.swift
//  SlipstreamWatch Watch App
//
//  Created by Tomás Mamede on 19/12/2022.
//

import Foundation

struct News: Decodable, Hashable, Identifiable {

    let id: String
    let title: String
    let body: String
    let date: Date
}
