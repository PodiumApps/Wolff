// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Localization {
  internal enum GrandPrixCard {
    /// Monza 2023
    internal static let title = Localization.tr("Localizable", "grand_prix_card.title", fallback: "Monza 2023")
    internal enum Top {
      /// Round %@
      internal static func round(_ p1: Any) -> String {
        return Localization.tr("Localizable", "grand_prix_card.top.round", String(describing: p1), fallback: "Round %@")
      }
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
