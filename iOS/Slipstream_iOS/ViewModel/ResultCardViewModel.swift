//
//  ResultCardViewModel.swift
//  Slipstream_iOS
//
//  Created by Tomás Mamede on 09/01/2023.
//

import Foundation

protocol ResultCardRepresentable {

    var sessionType: String { get }
    var fastestLap: String { get }
    var drivers: [ResultCardViewModel.Driver] { get }
}

final class ResultCardViewModel: ResultCardRepresentable {

    struct Driver: Identifiable {

        let id: String // Driver Ticker
        let position: Position
    }

    let sessionType: String
    let fastestLap: String
    let drivers: [Driver]

    enum Position {

        case first
        case second
        case third

        var label: String {
            switch self {
            case .first: return "1"
            case .second: return "2"
            case .third: return "3"
            }
        }

        var showTrophyImage: Bool { self == .first }
    }

    init(sessionType: String, fastestLap: String, drivers: [Driver]) {

        self.sessionType = sessionType
        self.fastestLap = fastestLap
        self.drivers = drivers
    }
}
