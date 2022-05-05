//
//  Constants.swift
//  TBGB Control
//
//  Created by John Scholvin on 5/1/22.
//

import Foundation
import CoreGraphics

struct Constants {    
    static let LETTER_WIDTH = 9
    static let T1_START = 0
    static let B2_START = T1_START + LETTER_WIDTH + 1
    static let G3_START = B2_START + LETTER_WIDTH + 1
    static let B4_START = G3_START + LETTER_WIDTH + 1
    static let TBGB_XMAX = B4_START + LETTER_WIDTH      // columns
    static let TBGB_YMAX = 17                           // rows
}

struct Globals {
    // utility modify the input color by multiplying the RGB space by mult
    static func mod_color(color: CGColor, mult: Double) -> CGColor {
        let components = color.components
        return CGColor(red: components![0] * mult, green: components![1] * mult, blue: components![2] * mult, alpha: components![3])
    }
}
