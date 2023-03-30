// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Localization {
  internal enum FinishedCardCell {
    /// FINISHED
    internal static let finished = Localization.tr("Localizable", "finished_card_cell.finished", fallback: "FINISHED")
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
  internal enum SeasonListView {
    internal enum Navigation {
      /// Season 2023
      internal static let title = Localization.tr("Localizable", "season_list_view.navigation.title", fallback: "Season 2023")
    }
  }
  internal enum SessionDriverList {
    internal enum Error {
      /// Refresh
      internal static let cta = Localization.tr("Localizable", "session_driver_list.error.cta", fallback: "Refresh")
      /// Something went wrong
      internal static let text = Localization.tr("Localizable", "session_driver_list.error.text", fallback: "Something went wrong")
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
