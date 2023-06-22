import Foundation
import SwiftUI
import Combine

protocol SettingsViewModelRepresentable: ObservableObject {

    var action: PassthroughSubject<SettingsViewModel.Action, Never> { get }
    var notificationCells: [NotificationService.Notification] { get }
    var isPremium: Bool { get }
}

final class SettingsViewModel: SettingsViewModelRepresentable {

    var action = PassthroughSubject<Action, Never>()
    var subscribers = Set<AnyCancellable>()

    private var appDelegate: AppDelegate

    private var navigation: AppNavigationRepresentable

    private let purchaseService: PurchaseServiceRepresentable
    private let notificationService: NotificationServiceRepresentable

    @Published var isPremium: Bool
    @Published var notificationCells: [NotificationService.Notification]

    init(
        appDelegate: AppDelegate,
        navigation: AppNavigationRepresentable,
        purchaseService: PurchaseServiceRepresentable,
        notificationService: NotificationServiceRepresentable
    ) {
        self.appDelegate = appDelegate
        self.navigation = navigation

        self.isPremium = false
        self.notificationCells = []

        self.purchaseService = purchaseService
        self.notificationService = notificationService

        self.setUpBindings()
    }

    private func setUpBindings() {

        notificationService.statePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] notificationService in

                switch notificationService {
                case .refreshed(let notifications):
                    return notifications
                case .refreshing, .error:
                    return []
                }
            }
            .assign(to: &$notificationCells)

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
            purchaseService: ServiceLocator.shared.purchaseService,
            notificationService: ServiceLocator.shared.notificationService
        )
    }
}
