import Foundation
import SwiftUI
import Combine

protocol SettingsViewModelRepresentable: ObservableObject {

    var action: PassthroughSubject<SettingsViewModel.Action, Never> { get }
    var notificationCells: [NotificationService.Notification] { get set }
    var isPremium: Bool { get }
    var activateNotificationsActionSheet: Bool { get set } 
}

final class SettingsViewModel: SettingsViewModelRepresentable {

    var action = PassthroughSubject<Action, Never>()
    var subscribers = Set<AnyCancellable>()

    private var navigation: AppNavigationRepresentable

    private let purchaseService: PurchaseServiceRepresentable
    private let notificationService: NotificationServiceRepresentable

    @Published var isPremium: Bool
    @Published var activateNotificationsActionSheet: Bool
    @Published var notificationCells: [NotificationService.Notification] {
        didSet {

            notificationService.action.send(.checkPushNotificationsAuthorizationStatus)
            notificationService.action.send(.update(notificationCells))
        }
    }
    
    init(
        navigation: AppNavigationRepresentable,
        purchaseService: PurchaseServiceRepresentable,
        notificationService: NotificationServiceRepresentable
    ) {
        self.navigation = navigation

        self.isPremium = false
        self.activateNotificationsActionSheet = false
        self.notificationCells = []

        self.purchaseService = purchaseService
        self.notificationService = notificationService

        self.setUpBindings()
    }

    private func setUpBindings() {

        notificationService.action.send(.fetchAll)

        notificationService.statePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] notificationService in

                guard let self else { return nil }
                
                switch notificationService {
                case .refreshed(let notifications, let showActivateNotificationActionSheet):
                    activateNotificationsActionSheet = showActivateNotificationActionSheet
                    return notifications
                case .refreshing, .error:
                    return []
                }
            }
            .assign(to: &$notificationCells)

        purchaseService.statePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { purchaseService in

                switch purchaseService {
                case .refreshed(let isPremium, _, _):
                    return isPremium
                default:
                    return nil
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
                case .showPrivacyPolicyView:

                    let privacyPolicyViewModel = PrivacyPolicyViewModel()
                    navigation.action.send(.append(route: .privacyPolicy(privacyPolicyViewModel)))
                case .showTermsAndConditionsView:

                    let termsAndConditionsViewModel = TermsAndConditionsViewModel()
                    navigation.action.send(.append(route: .termsAndConditions(termsAndConditionsViewModel)))
                case .registerForRemoteNotifications:
                    
                    notificationService.action.send(.registerNotification)
                }
            }
            .store(in: &subscribers)
    }
}

extension SettingsViewModel {

    enum Action {

        case showPrivacyPolicyView
        case showTermsAndConditionsView
        case showInAppPurchaseView
        case registerForRemoteNotifications
    }
}

extension SettingsViewModel {

    static func make(navigation: AppNavigationRepresentable) -> SettingsViewModel {

        SettingsViewModel(
            navigation: navigation,
            purchaseService: ServiceLocator.shared.purchaseService,
            notificationService: ServiceLocator.shared.notificationService
        )
    }
}
