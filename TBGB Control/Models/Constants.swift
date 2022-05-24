//
//  Constants.swift
//  TBGB Control
//
//  Created by John Scholvin on 5/1/22.
//

import Foundation
import CoreGraphics

struct TBGB {
    static let LETTER_WIDTH = 9
    static let T1_START = 0
    static let B2_START = T1_START + LETTER_WIDTH + 1
    static let G3_START = B2_START + LETTER_WIDTH + 1
    static let B4_START = G3_START + LETTER_WIDTH + 1
    static let XMAX = B4_START + LETTER_WIDTH      // columns
    static let YMAX = 17                           // rows
    
    // there is some way to do these named constants based on CGColor class variables, but swift makes no sense
    static let BLACK = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    static let WHITE = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
   
    // https://drafts.csswg.org/css-color/#named-colors
    static let RED = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
    static let ORANGE = CGColor(red: 1, green: 0.647, blue: 0, alpha: 1)
    static let YELLOW = CGColor(red: 1, green: 1, blue: 0, alpha: 1)
    static let GREEN = CGColor(red: 0, green: 1, blue: 0, alpha: 1)
    static let BLUE = CGColor(red: 0, green: 0, blue: 1, alpha: 1)
    static let PURPLE = CGColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)
    static let DIM = CGColor(red: 20.0/255.0, green: 20.0/255.0, blue: 10.0/255.0, alpha: 1) // TODO: verify on frame
    // legacy
    static let GREG = CGColor(red: 1, green: 115.0/255.0, blue: 0, alpha: 1)
    
    // custom blend to make the LED's look more like incandescent bulbs
    static let INCANDESCENT = CGColor(red: 1, green: 144.0/255.0, blue: 32.0/255.0, alpha: 1)
    
    static let RAINBOW = [RED, ORANGE, YELLOW, GREEN, BLUE, PURPLE]
}

struct Globals {
    // utility modify the input color by multiplying the RGB space by mult
    static func mod_color(color: CGColor, mult: Double) -> CGColor {
        let components = color.components
        return CGColor(red: components![0] * mult, green: components![1] * mult, blue: components![2] * mult, alpha: components![3])
    }
}
