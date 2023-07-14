import Foundation
import Combine

protocol FinishedSessionCellViewModelRepresentable {

    var sessionID: Session.ID { get }
    var sessionName: String { get }
    var winners: [String] { get }

    var action: PassthroughSubject<FinishedSessionCellViewModel.Action, Never> { get }
}

final class FinishedSessionCellViewModel: FinishedSessionCellViewModelRepresentable {

    var sessionID: Session.ID
    var sessionName: String
    var winners: [String]
    
    var action = PassthroughSubject<FinishedSessionCellViewModel.Action, Never>()

    init(
        sessionID: Session.ID,
        session: String,
        winners: [String]
    ) {

        self.sessionID = sessionID
        self.sessionName = session
        self.winners = winners
    }
}

extension FinishedSessionCellViewModel {
    
    enum Action {
        
        case tapSession
    }
}
