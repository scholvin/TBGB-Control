//
//  LetterModel.swift
//  TBGB Control
//
//  Created by John Scholvin on 4/28/22.
//

import Foundation
import SwiftUI
    
class LetterModel: ObservableObject {
    @Published var frames = 0
    public var grid: Grid
    
    init() {
        self.grid = Grid(color: Color.purple)
        self.grid[5, 10] = Color.black
    }
    
    func has_pixel(x: Int, y: Int) -> Bool {
        if x >= Constants.TBGB_XMAX || y >= Constants.TBGB_YMAX || x < 0 || y < 0 {
            return false
        }
        let index = bips[y].index(bips[y].startIndex, offsetBy: x)
        return bips[y][index] == "X"
    }
    
    let bips: [String] = [
        "XXXXXXXXX XXXXXXXX   XXXXXXXX XXXXXXXX ",
        "XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX",
        "XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX",
        "   XXX    XXX   XXX XXX       XXX   XXX",
        "   XXX    XXX   XXX XXX       XXX   XXX",
        "   XXX    XXX   XXX XXX       XXX   XXX",
        "   XXX    XXX   XXX XXX       XXX   XXX",
        "   XXX    XXXXXXXXX XXX   XXX XXXXXXXXX",
        "   XXX    XXXXXXXX  XXX   XXX XXXXXXXX ",
        "   XXX    XXXXXXXXX XXX   XXX XXXXXXXXX",
        "   XXX    XXX   XXX XXX   XXX XXX   XXX",
        "   XXX    XXX   XXX XXX   XXX XXX   XXX",
        "   XXX    XXX   XXX XXX   XXX XXX   XXX",
        "   XXX    XXX   XXX XXX   XXX XXX   XXX",
        "   XXX    XXXXXXXXX XXXXXXXXX XXXXXXXXX",
        "   XXX    XXXXXXXXX XXXXXXXXX XXXXXXXXX",
        "   XXX    XXXXXXXX   XXXXXXXX XXXXXXXX "
    ]
    
    public let outline_T: [(CGFloat, CGFloat)] = [
        (-0.5, -0.5),
        (8.5, -0.5),
        (8.5, 2.5),
        (5.5, 2.5),
        (5.5, 16.5),
        (2.5, 16.5),
        (2.5, 2.5),
        (-0.5, 2.5)
    ]
    
    // note: X is relative, y is absolute
    public let outline_B_outer: [(CGFloat, CGFloat)] = [
        (0, -0.5),
        (7.5, -0.5),
        (9, 1),
        (9, 7.5),
        (8.5, 8.0),
        (9, 8.5),
        (9, 15),
        (7.5, 16.5),
        (0, 16.5)
    ]
    
    // note: X and Y are both relative (there are two of these per B, shifted on the Y axis)
    public let outline_B_inner: [(CGFloat, CGFloat)] = [
        (3, 0),
        (6, 0),
        (6, 4),
        (3, 4)
    ]
    
    public let outline_G_outer: [(CGFloat, CGFloat)] = [
        (21, -0.5),
        (28.5, -0.5),
        (28.5, 2.5),
        (22.5, 2.5),
        (22.5, 13.5),
        (25.5, 13.5),
        (25.5, 6.5),
        (28.5, 6.5),
        (28.5, 16.5),
        (21, 16.5),
        (19.5, 15.0),
        (19.5, 1)
    ]
}
