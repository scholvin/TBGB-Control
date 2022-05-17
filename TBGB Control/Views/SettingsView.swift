//
//  SettingsView.swift
//  TBGB Control
//
//  Created by John Scholvin on 5/1/22.
//

import SwiftUI

// see:
// https://www.hackingwithswift.com/quick-start/swiftui/how-to-present-a-new-view-using-sheets

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var settingsModel: Settings
    
    var body: some View {
        VStack() {
           Text("Settings")
                .font(.largeTitle)
                .padding(5)

            Form {
                Section(header: Text("OLAD")) {
                    Toggle("Active", isOn: $settingsModel.olaEnabled)
                    HStack() {
                        Text("IP")
                        Spacer()
                        TextField("IP", text: $settingsModel.olaAddress).multilineTextAlignment(.trailing)
                    }
                }
            }
            .frame(height: 200)

            Button(action: {
                dismiss()
            }, label: {
                Label("OK", systemImage: "checkmark")                    
            })
            .frame(width: 125, height: 50)
            .background(Color.blue.cornerRadius(8))
            .foregroundColor(.white)

            Spacer()
        
        }
        .foregroundColor(.black)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settingsModel: Settings())
    }
}
