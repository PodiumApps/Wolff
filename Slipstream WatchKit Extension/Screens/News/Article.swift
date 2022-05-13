//
//  Article.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 28/03/2022.
//

import SwiftUI

struct Article: View {
    
    var article: NewsArticle
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(article.title)
                        .font(.caption)
                        .bold()
                    
                    Text(article.date)
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Divider()
                    
                    Text(article.text)
                        .font(.caption2)
                }
                .padding([.leading, .trailing])
            }
        }
    }
}

struct Article_Previews: PreviewProvider {
    static var previews: some View {
        Article(article: article)
    }
}
