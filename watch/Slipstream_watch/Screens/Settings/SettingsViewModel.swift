import Foundation
import SwiftUI
import Combine

protocol SettingsViewModelRepresentable: ObservableObject {

    var action: PassthroughSubject<SettingsViewModel.Action, Never> { get }
    var isActiveSessionStartedNotification: Bool { get set }
    var isActiveSessionEndedNotification: Bool { get set }
    var isPremium: Bool { get }
}

final class SettingsViewModel: SettingsViewModelRepresentable {

    @AppStorage(UserDefaultsKeys.isActiveSessionStartedNotification.rawValue)
    var isActiveSessionStartedNotification: Bool = false

    @AppStorage(UserDefaultsKeys.isActiveSessionEndedNotification.rawValue)
    var isActiveSessionEndedNotification: Bool = false

    var action = PassthroughSubject<Action, Never>()
    var subscribers = Set<AnyCancellable>()

    private var navigation: AppNavigationRepresentable
    private let purchaseService: PurchaseServiceRepresentable

    @Published var isPremium: Bool

    init(navigation: AppNavigationRepresentable, purchaseService: PurchaseServiceRepresentable) {

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
                }
            }
            .store(in: &subscribers)
    }
}

extension SettingsViewModel {

    enum Action {

        case showInAppPurchaseView
    }
}

extension SettingsViewModel {

    static func make(navigation: AppNavigationRepresentable) -> SettingsViewModel {

        SettingsViewModel(
            navigation: navigation,
            purchaseService: ServiceLocator.shared.purchaseService
        )
    }
}
