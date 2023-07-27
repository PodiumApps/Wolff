//
//  PrivacyPolicyView.swift
//  Slipstream Watch App
//
//  Created by Tomás Mamede on 27/07/2023.
//

import SwiftUI

struct PrivacyPolicyView<ViewModel: PrivacyPolicyViewModelRepresentable>: View {

    private let viewModel: ViewModel

    private let sections: Sections
    typealias Sections = [Document.Section]

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
        sections = viewModel.document.sections
    }

    var body: some View {

        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: .Spacing.default3) {
                    ForEach(0 ..< sections.count, id: \.self) { i in
                        VStack(alignment: .leading, spacing: .Spacing.default) {
                            Text(sections[i].title)
                                .font(.Body.regular)
                                .bold()

                            VStack(spacing: .Spacing.default2) {
                                ForEach(0 ..< sections[i].paragraphs.count, id: \.self) { j in
                                    Text(sections[i].paragraphs[j])
                                        .font(.Body.medium)
                                        .bold()
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 2)
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
