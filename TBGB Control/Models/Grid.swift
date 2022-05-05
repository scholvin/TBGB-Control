//
//  Grid.swift
//  TBGB Control
//
//  Created by John Scholvin on 5/1/22.
//

import Foundation
import CoreGraphics

// borrowed from here https://stackoverflow.com/a/68964615/1053577
struct Grid {      
    var elements: [CGColor?]
    
    init(color: CGColor) {
        self.elements = Array(repeating: color, count: Constants.TBGB_YMAX * Constants.TBGB_XMAX)
    }
    
    subscript(row: Int, column: Int) -> CGColor? {
        get { elements[(row * Constants.TBGB_XMAX) + column] }
        set { elements[(row * Constants.TBGB_XMAX) + column] = newValue }
    }
}
