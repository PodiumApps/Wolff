//
//  More.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 21/05/2022.
//

import SwiftUI

struct Preferences: View {
    var lastServerUpdate: String
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        NavigationLink(destination: {
                            Notifications()
                        }, label: {
                            HStack {
                                Text("Notifications")
                                Spacer()
                            }
                        })
                        
                        NavigationLink(destination: {
                            FavoriteDriver(drivers: readDriversFromFile())
                        }, label: {
                            HStack {
                                Text("Favorites Driver")
                                Spacer()
                            }
                        })
                        
                        NavigationLink(destination: {
                            FavoriteTeam(teams: readConstructorsFromFile())
                            
                        }, label: {
                            HStack {
                                Text("Favorites Team")
                                Spacer()
                            }
                        })
                        
                        Divider()
                            .padding()
                        
                        VStack(alignment: .leading) {
                            Text("Last data retrieval from server: \(lastServerUpdate)")
                                .font(.footnote)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.gray)
                                .padding(.leading, 10)
                            
                            Text("Version: 0.1")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .padding(.top, 5)
                                .padding(.leading, 10)
                        }
                        .frame(width: geometry.size.width, alignment: .leading)
                    }
                }
                .navigationTitle("Preferences")
                .navigationBarTitleDisplayMode(.automatic)
            }
        }
    }
    
    private func readDriversFromFile() -> [String] {
        let filename = "drivers"
        
        do {
            let fileContent = try String(contentsOfFile: Bundle.main.path(forResource: filename, ofType: "txt")!)
            let drivers = fileContent.split(separator: "\n").map { String($0) }
            return drivers.sorted()
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func readConstructorsFromFile() -> [String] {
        let filename = "constructors"
        
        do {
            let fileContent = try String(contentsOfFile: Bundle.main.path(forResource: filename, ofType: "txt")!)
            let constructors = fileContent.split(separator: "\n").map { String($0) }
            return constructors.sorted()
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
}

struct More_Previews: PreviewProvider {
    static var previews: some View {
        Preferences(lastServerUpdate: "")
    }
}
