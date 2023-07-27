//
//  TermsAndConditionsViewModel.swift
//  Slipstream Watch App
//
//  Created by Tomás Mamede on 27/07/2023.
//

import Foundation

protocol TermsAndConditionsViewModelRepresentable {

    var document: Document { get }
}

class TermsAndConditionsViewModel: TermsAndConditionsViewModelRepresentable {

    var document: Document

    init() {

        self.document = Document().decodeJSON(filename: "terms_and_conditions")
    }
}
