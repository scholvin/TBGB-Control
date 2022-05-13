//
//  SettingsView.swift
//  TBGB Control
//
//  Created by John Scholvin on 5/1/22.
//

import SwiftUI

// https://kristaps.me/blog/swiftui-modal-view/

struct SettingsView: View {
    @Binding var activeSheet: Sheet?
    
    var body: some View {
        VStack(spacing: 50) {
            Text("Settings view.")
                .font(.largeTitle)
            
            Button(action: {
                activeSheet = nil
            }, label: {
                Label("Close", systemImage: "xmark.circle")
            })
        }
        .background(Color.green)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(activeSheet: Binding(get: { Sheet.settings }, set: { _ in }))
    }
}
