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
    var http_error: String
    var build_date: Date
    var cpu_temp: String
    var load_avg: String
    var uptime: String
    
    var body: some View {
        VStack() {
           Text("Settings")
                .font(.largeTitle)
                .padding(5)

            Form {
                Section(header: Text("Server"),
                        footer: Text(settingsModel.addressMsg).foregroundColor(.red)) {
                    Toggle("Active", isOn: $settingsModel.olaEnabled)
                    HStack() {
                        Text("IP address")
                        Spacer()
                        TextField("IP", text: $settingsModel.olaAddress)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.blue)
                    }
                    HStack() {
                        Text("OLA port")
                        Spacer()
                        TextField("Port", text: $settingsModel.olaPort)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.blue)
                    }
                    HStack() {
                        Text("CPU info port")
                        Spacer()
                        TextField("Port", text: $settingsModel.svcPort)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.blue)
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
                    HStack() {
                        Text("HTTP last error")
                        Spacer()
                        Text(http_error)
                    }
                }
                Section(header: Text("Info")) {
                    HStack() {
                        Text("CPU temperature")
                        Spacer()
                        Text(cpu_temp)
                    }
                    HStack() {
                        Text("Load average (1, 5, 15)")
                        Spacer()
                        Text(load_avg)
                    }
                    HStack() {
                        Text("Uptime (HH:MM:SS)")
                        Spacer()
                        Text(uptime)
                    }
                    HStack() {
                        Text("Build date")
                        Spacer()
                        Text(build_date.formatted())
                    }
                }
            }
            .frame(height: 685)

            Button(action: {
                dismiss()
            }, label: {
                Label("OK", systemImage: "checkmark")                    
            })
            .disabled(!self.settingsModel.isValid)
            .frame(width: 125, height: 50)
            .background(self.settingsModel.isValid ? Color.blue.cornerRadius(8) : Color.gray.cornerRadius(8))
            .foregroundColor(.white)

            Spacer()
        }
        .preferredColorScheme(.dark)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settingsModel: Settings(),
                     http_render: "1,234µs",
                     view_render: "5,678µs",
                     http_error: "--",
                     build_date: Date(),
                     cpu_temp: "45.6ºC",
                     load_avg: "0.12 0.15 0.16",
                     uptime: "01:23:45")
    }
}
