//
//  TBGB_ControlApp.swift
//  TBGB Control
//
//  Created by John Scholvin on 4/20/22.
//

import SwiftUI

@main
struct TBGB_ControlApp: App {
    
    @StateObject var viewModel = LetterModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
