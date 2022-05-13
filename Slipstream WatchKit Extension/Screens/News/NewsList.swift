//
//  NewsList.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 28/03/2022.
//

import SwiftUI

struct NewsList: View {
    
    var news: [NewsArticle]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
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
            }
            .navigationTitle(Text("Latest News"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct NewsList_Previews: PreviewProvider {
    static var previews: some View {
        NewsList(news: [article])
    }
}
