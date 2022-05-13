//
//  InfoView.swift
//  TBGB Control
//
//  Created by John Scholvin on 5/13/22.
//

import SwiftUI

// https://kristaps.me/blog/swiftui-modal-view/

struct InfoView: View {
    @Binding var activeSheet: Sheet?
    
    var body: some View {
        VStack(spacing: 50) {
            Text("Information view")
                .font(.largeTitle)
            
            Button(action: {
                activeSheet = nil
            }, label: {
                Label("Close", systemImage: "xmark.circle")
            })
        }
        .background(Color.pink)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(activeSheet: Binding(get: { Sheet.info }, set: { _ in }))
    }
}
