// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Localization {
  internal enum DriverDetails {
    /// All Time Points
    internal static let allTimePoints = Localization.tr("Localizable", "driver_details.all_time_points", fallback: "All Time Points")
    /// Championships
    internal static let championships = Localization.tr("Localizable", "driver_details.championships", fallback: "Championships")
    /// Grand Prix Entered
    internal static let grandPrixEntered = Localization.tr("Localizable", "driver_details.grand_prix_entered", fallback: "Grand Prix Entered")
    /// Highest Grid Position
    internal static let highestGridPosition = Localization.tr("Localizable", "driver_details.highest_grid_position", fallback: "Highest Grid Position")
    /// Number of Podiums
    internal static let numberOfPodiums = Localization.tr("Localizable", "driver_details.number_of_podiums", fallback: "Number of Podiums")
    /// Place of Birth
    internal static let placeOfBirth = Localization.tr("Localizable", "driver_details.place_of_birth", fallback: "Place of Birth")
  }
  internal enum DriverStandingsCell {
    /// Car %@
    internal static func carNumber(_ p1: Any) -> String {
      return Localization.tr("Localizable", "driver_standings_cell.car_number", String(describing: p1), fallback: "Car %@")
    }
    /// Leader
    internal static let leader = Localization.tr("Localizable", "driver_standings_cell.leader", fallback: "Leader")
    /// Time / Gap
    internal static let timeGap = Localization.tr("Localizable", "driver_standings_cell.time_gap", fallback: "Time / Gap")
    /// Tyre
    internal static let tyre = Localization.tr("Localizable", "driver_standings_cell.tyre", fallback: "Tyre")
  }
  internal enum FinishedCardCell {
    /// FINISHED
    internal static let finished = Localization.tr("Localizable", "finished_card_cell.finished", fallback: "FINISHED")
  }
  internal enum FinishedSessionCell {
    /// Winner:
    internal static let winner = Localization.tr("Localizable", "finished_session_cell.winner", fallback: "Winner:")
  }
  internal enum GrandPrixCard {
    internal enum Label {
      /// in %@
      internal static func time(_ p1: Any) -> String {
        return Localization.tr("Localizable", "grand_prix_card.label.time", String(describing: p1), fallback: "in %@")
      }
    }
    internal enum Top {
      /// Round %@
      internal static func round(_ p1: Any) -> String {
        return Localization.tr("Localizable", "grand_prix_card.top.round", String(describing: p1), fallback: "Round %@")
      }
    }
  }
  internal enum LiveCardCell {
    /// About to Start
    internal static let aboutToStart = Localization.tr("Localizable", "live_card_cell.about_to_start", fallback: "About to Start")
    /// TO
    internal static let to = Localization.tr("Localizable", "live_card_cell.to", fallback: "TO")
    internal enum Time {
      /// HOUR
      internal static let hour = Localization.tr("Localizable", "live_card_cell.time.hour", fallback: "HOUR")
      /// HOURS
      internal static let hours = Localization.tr("Localizable", "live_card_cell.time.hours", fallback: "HOURS")
      /// left
      internal static let `left` = Localization.tr("Localizable", "live_card_cell.time.left", fallback: "left")
      /// MINUTE
      internal static let minute = Localization.tr("Localizable", "live_card_cell.time.minute", fallback: "MINUTE")
      /// MINUTES
      internal static let minutes = Localization.tr("Localizable", "live_card_cell.time.minutes", fallback: "MINUTES")
      /// SECONDS
      internal static let seconds = Localization.tr("Localizable", "live_card_cell.time.seconds", fallback: "SECONDS")
    }
    internal enum Title {
      /// HAPPENING NOW
      internal static let now = Localization.tr("Localizable", "live_card_cell.title.now", fallback: "HAPPENING NOW")
      /// HAPPENING SOON
      internal static let soon = Localization.tr("Localizable", "live_card_cell.title.soon", fallback: "HAPPENING SOON")
    }
    internal enum Top {
      /// Round %@
      internal static func round(_ p1: Any) -> String {
        return Localization.tr("Localizable", "live_card_cell.top.round", String(describing: p1), fallback: "Round %@")
      }
    }
  }
  internal enum Podium {
    /// %@.
    internal static func ordinalComponent(_ p1: Any) -> String {
      return Localization.tr("Localizable", "podium.ordinal_component", String(describing: p1), fallback: "%@.")
    }
  }
  internal enum SeasonConstructorStandings {
    /// Team Principle
    internal static let teamPrinciple = Localization.tr("Localizable", "season_constructor_standings.team_principle", fallback: "Team Principle")
  }
  internal enum SeasonDriverStandings {
    /// Car
    internal static let carNo = Localization.tr("Localizable", "season_driver_standings.car_no", fallback: "Car")
    /// Points
    internal static let points = Localization.tr("Localizable", "season_driver_standings.points", fallback: "Points")
  }
  internal enum SeasonListView {
    internal enum Navigation {
      /// Season 2023
      internal static let title = Localization.tr("Localizable", "season_list_view.navigation.title", fallback: "Season 2023")
    }
  }
  internal enum Session {
    /// Sessions
    internal static let screenTitle = Localization.tr("Localizable", "session.screen_title", fallback: "Sessions")
  }
  internal enum SessionDriverList {
    internal enum Error {
      /// Refresh
      internal static let cta = Localization.tr("Localizable", "session_driver_list.error.cta", fallback: "Refresh")
      /// Something went wrong
      internal static let text = Localization.tr("Localizable", "session_driver_list.error.text", fallback: "Something went wrong")
    }
  }
  internal enum SessionTime {
    /// Today at %@
    internal static func today(_ p1: Any) -> String {
      return Localization.tr("Localizable", "session_time.today", String(describing: p1), fallback: "Today at %@")
    }
    /// Tomorrow at %@
    internal static func tomorrow(_ p1: Any) -> String {
      return Localization.tr("Localizable", "session_time.tomorrow", String(describing: p1), fallback: "Tomorrow at %@")
    }
  }
  internal enum StandingsListView {
    /// Standings
    internal static let screenTitle = Localization.tr("Localizable", "standings_list_view.screen_title", fallback: "Standings")
    /// Selection
    internal static let selectionLabel = Localization.tr("Localizable", "standings_list_view.selection_label", fallback: "Selection")
  }
  internal enum TrackInfo {
    /// First Grand Prix
    internal static let firstGrandPrix = Localization.tr("Localizable", "track_info.first_grand_prix", fallback: "First Grand Prix")
    /// Lap Record
    internal static let lapRecord = Localization.tr("Localizable", "track_info.lap_record", fallback: "Lap Record")
    /// Race Distance
    internal static let raceDistance = Localization.tr("Localizable", "track_info.race_distance", fallback: "Race Distance")
    /// %@ km
    internal static func raceDistanceValue(_ p1: Any) -> String {
      return Localization.tr("Localizable", "track_info.race_distance_value", String(describing: p1), fallback: "%@ km")
    }
    /// Track Info
    internal static let screenTitle = Localization.tr("Localizable", "track_info.screen_title", fallback: "Track Info")
    /// Track Length
    internal static let trackLength = Localization.tr("Localizable", "track_info.track_length", fallback: "Track Length")
    /// %@ km
    internal static func trackLengthValue(_ p1: Any) -> String {
      return Localization.tr("Localizable", "track_info.track_length_value", String(describing: p1), fallback: "%@ km")
    }
  }
  internal enum UpcomingAndStandingsCell {
    internal enum Segment {
      /// Past
      internal static let past = Localization.tr("Localizable", "upcoming_and_standings_cell.segment.past", fallback: "Past")
      /// Upcoming
      internal static let upcoming = Localization.tr("Localizable", "upcoming_and_standings_cell.segment.upcoming", fallback: "Upcoming")
    }
    internal enum Standings {
      /// Current Standings
      internal static let title = Localization.tr("Localizable", "upcoming_and_standings_cell.standings.title", fallback: "Current Standings")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Localization {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
