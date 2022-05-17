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
    @State var oladEnabled: Bool = false
    @State var oladAddress: String = "192.168.1.100:9090"
    
    var body: some View {
        VStack() {
           Text("Settings")
                .font(.largeTitle)
                .padding(5)

            Form {
                Section(header: Text("OLAD")) {
                    Toggle("Active", isOn: $oladEnabled)
                    HStack() {
                        Text("IP")
                        Spacer()
                        TextField("IP", text: $oladAddress).multilineTextAlignment(.trailing)
                    }
                }
            }
            .frame(height: 200)
                
            Button(action: {
                activeSheet = nil
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
        SettingsView(activeSheet: Binding(get: { Sheet.settings }, set: { _ in }))
    }
}
