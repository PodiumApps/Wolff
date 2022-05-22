//
//  NewsList.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 20/05/2022.
//

import SwiftUI

struct NewsList: View {
    
    var news: [NewsArticle]
    
    var body: some View {
        if news.isEmpty {
            NavigationView {
                VStack {
                    Text("There are no news to be shown at this time. Come back later.")
                        .font(.caption2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .navigationTitle(Text("Latest News"))
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        else {
            NavigationView {
                ScrollView {
                    ForEach(0 ..< news.count, id: \.self) { index in
                        NavigationLink(destination: {
                            Article(article: news[index])
                        }, label: {
                            HStack {
                                Text(news[index].title)
                                    .font(.caption)
                                    .bold()
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                            .padding([.leading, .trailing])
                        })
                        .buttonStyle(PlainButtonStyle())
                        
                        Divider()
                    }
                    
                    HStack {
                        Text("Source: fia.com")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.top)
                        
                        Spacer()
                    }
                    .padding([.leading, .trailing])
                }
                .navigationTitle(Text("Latest News"))
                .navigationBarTitleDisplayMode(.automatic)
            }
        }
    }
}

struct NewsList_Previews: PreviewProvider {
    static var previews: some View {
        NewsList(news: [article])
    }
}
