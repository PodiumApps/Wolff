import Foundation
import SwiftUI
import Combine

protocol SettingsViewModelRepresentable: ObservableObject {

    var action: PassthroughSubject<SettingsViewModel.Action, Never> { get }
    var isActiveSessionStartedNotification: Bool { get set }
    var isActiveSessionEndedNotification: Bool { get set }
    var isActiveLatestNewsNotification: Bool { get set }
    var isPremium: Bool { get }
}

final class SettingsViewModel: SettingsViewModelRepresentable {

    @AppStorage(UserDefaultsKeys.isActiveSessionStartedNotification.rawValue)
    var isActiveSessionStartedNotification: Bool = false

    @AppStorage(UserDefaultsKeys.isActiveSessionEndedNotification.rawValue)
    var isActiveSessionEndedNotification: Bool = false

    @AppStorage(UserDefaultsKeys.isActiveLatestNewsNotification.rawValue)
    var isActiveLatestNewsNotification: Bool = false

    var action = PassthroughSubject<Action, Never>()
    var subscribers = Set<AnyCancellable>()

    private var appDelegate: AppDelegate

    private var navigation: AppNavigationRepresentable

    private let purchaseService: PurchaseServiceRepresentable

    @Published var isPremium: Bool

    init(
        appDelegate: AppDelegate,
        navigation: AppNavigationRepresentable,
        purchaseService: PurchaseServiceRepresentable
    ) {
        self.appDelegate = appDelegate
        self.navigation = navigation
        self.isPremium = false
        self.purchaseService = purchaseService

        self.setUpBindings()
    }

    private func setUpBindings() {

        purchaseService.statePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] purchaseService in

                switch purchaseService {
                case .refreshed(let isPremium, _):
                    return isPremium ? true : false
                default: return false
                }
            }
            .assign(to: &$isPremium)

        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in

                guard let self else { return }
                switch action {
                case .showInAppPurchaseView:

                    let inAppPurchaseViewModel = InAppPurchaseViewModel.make()
                    navigation.action.send(.append(route: .activatePremium(inAppPurchaseViewModel)))
                case .registerForRemoteNotifications:

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.appDelegate.registerForRemoteNotifications()
                    }
                }
            }
            .store(in: &subscribers)
    }
}

extension SettingsViewModel {

    enum Action {

        case showInAppPurchaseView
        case registerForRemoteNotifications
    }
}

extension SettingsViewModel {

    static func make(appDelegate: AppDelegate, navigation: AppNavigationRepresentable) -> SettingsViewModel {

        SettingsViewModel(
            appDelegate: appDelegate,
            navigation: navigation,
            purchaseService: ServiceLocator.shared.purchaseService
        )
    }
}
