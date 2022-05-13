//
//  Settings.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 29/03/2022.
//

import SwiftUI

struct Settings: View {
    
    @State private var toggleIsOn = true
    var lastServerUpdate: String
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Section("Notifications", content: {
                        Toggle(isOn: $toggleIsOn, label: {
                            Text("When Event Starts")
                                .font(.caption2)
                        })
                        Divider()
                        Toggle(isOn: $toggleIsOn, label: {
                            Text("When Event Finishes")
                                .font(.caption2)
                        })
                        Divider()
                        Toggle(isOn: $toggleIsOn, label: {
                            Text("Latest News")
                                .font(.caption2)
                        })
                        Divider()
                    })
                    .padding(5)
                    
                    Spacer()
                    
                    Text("Last data retrieval from server: \(lastServerUpdate)")
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.gray)
                        .padding(5)
                    
                    Text("Version: 0.1")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(5)
                }
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(lastServerUpdate: "")
    }
}
