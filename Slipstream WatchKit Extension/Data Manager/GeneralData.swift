//
//  GeneralData.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 04/06/2022.
//

struct GeneralData: Codable {
    var seasonSchedule: SeasonSchedule
    var seasonScheduleCurrentEvent: [Event]
    var seasonScheduleUpcomingEvents: [Event]
    var seasonSchedulePastEvents: [Event]
    var driverStandings: [Driver]
    var teamStandings: [Team]
    
    enum CodingKeys: String, CodingKey {
        case driverStandings = "driverStandings"
        case seasonScheduleCurrentEvent = "seasonScheduleCurrent"
        case seasonScheduleUpcomingEvents = "seasonScheduleUpcoming"
        case seasonSchedulePastEvents = "seasonSchedulePast"
        case teamStandings = "teamStandings"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        driverStandings = try container.decodeIfPresent([Driver].self, forKey: .driverStandings) ?? []
        teamStandings = try container.decodeIfPresent([Team].self, forKey: .teamStandings) ?? []
        seasonScheduleCurrentEvent = try container.decodeIfPresent([Event].self, forKey: .seasonScheduleCurrentEvent) ?? []
        seasonScheduleUpcomingEvents = try container.decodeIfPresent([Event].self, forKey: .seasonScheduleUpcomingEvents) ?? []
        seasonSchedulePastEvents = try container.decodeIfPresent([Event].self, forKey: .seasonSchedulePastEvents) ?? []
        seasonSchedule = SeasonSchedule(currentEvent: seasonScheduleCurrentEvent, upcomoingEvents: seasonScheduleUpcomingEvents, pastEvents: seasonSchedulePastEvents)
    }
}
