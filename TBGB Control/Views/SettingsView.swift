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
    var http_render: String
    var view_render: String
    
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
                Section(header: Text("Statistics")) {
                    HStack() {
                        Text("HTTP POST average render")
                        Spacer()
                        Text(http_render)
                    }
                    HStack() {
                        Text("SwiftUI View average render")
                        Spacer()
                        Text(view_render)
                    }
                }
            }
            .frame(height: 300)

            Button(action: {
                print("enabled=\(settingsModel.olaEnabled)")
                settingsModel.update()
                dismiss()
            }, label: {
                Label("OK", systemImage: "checkmark")                    
            })
            .frame(width: 125, height: 50)
            .background(Color.blue.cornerRadius(8))
            .foregroundColor(.white)

            Spacer()
        
        }
        .preferredColorScheme(.dark)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settingsModel: Settings(olaEnabled: false, olaAddress: "192.168.1.100:9090"),
                     http_render: "1,234µs",
                     view_render: "5,678µs")
    }
}
