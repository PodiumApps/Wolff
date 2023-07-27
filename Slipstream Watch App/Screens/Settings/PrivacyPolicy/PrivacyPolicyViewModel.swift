//
//  PrivacyPolicyViewModel.swift
//  Slipstream Watch App
//
//  Created by Tomás Mamede on 27/07/2023.
//

import Foundation

protocol PrivacyPolicyViewModelRepresentable {

    var document: Document { get }
}

class PrivacyPolicyViewModel: PrivacyPolicyViewModelRepresentable {

    var document: Document

    init() {
        self.document = Document().decodeJSON(filename: "privacy_policy")
    }
}
