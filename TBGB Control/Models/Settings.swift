//
//  Settings.swift
//  TBGB Control
//
//  Created by John Scholvin on 5/10/22.
//

import Foundation

class Settings: ObservableObject {
    var olaEnabled: Bool
    var olaAddress: String
    
    init(olaEnabled: Bool, olaAddress: String) {
        self.olaEnabled = olaEnabled
        self.olaAddress = olaAddress
        print("--> SETTINGS CTOR")
    }
    
    @Published var changed = 0
    
    func update()
    {
        changed += 1
    }
}
