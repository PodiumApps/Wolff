//
//  NotificationView.swift
//  Slipstream WatchKit Extension
//
//  Created by Tomás Mamede on 20/05/2022.
//

import SwiftUI

struct NotificationView: View {
    
    var message: String
    
    var body: some View {
        Text(message)
            .multilineTextAlignment(.leading)
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(message: "Miami Qualifying (Q3): Red Flag!")
    }
}
