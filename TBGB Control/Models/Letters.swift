//
//  Letters.swift
//  TBGB Control
//
//  Created by John Scholvin on 5/5/22.
//
// Information about the layout of the letters themselves
// All coordinates are specified as (x, y)

import Foundation
import CoreGraphics

struct Letters {
    static func has_pixel(x: Int, y: Int) -> Bool {
        if x >= TBGB.XMAX || y >= TBGB.YMAX || x < 0 || y < 0 {
            return false
        }
        let index = bips[y].index(bips[y].startIndex, offsetBy: x)
        return bips[y][index] == "X"
    }
    
    static var generator = SystemRandomNumberGenerator()
    
    static func get_random_pixel() -> (Int, Int) {
        var x = -1, y = -1
        repeat {
            x = Int.random(in: 0..<TBGB.XMAX, using: &generator)
            y = Int.random(in: 0..<TBGB.YMAX, using: &generator)
        } while !has_pixel(x: x, y: y)
        return (x, y)
    }
    
    // is there a pixel on the grid at location (x,y)? also, looks cool
    
    static let bips: [String] = [
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
    
    // how many pixels per letter
    
    static let pixels_T = 69
    static let pixels_B = 126
    static let pixels_G = 106
    
    // these outline_X structures denote the coordinates *between* the pixels where the
    // outlines of the letters will be rendered in the main view
    
    static let outline_T: [(CGFloat, CGFloat)] = [
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
    static let outline_B_outer: [(CGFloat, CGFloat)] = [
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
    static let outline_B_inner: [(CGFloat, CGFloat)] = [
        (3, 0),
        (6, 0),
        (6, 4),
        (3, 4)
    ]
    
    static let outline_G_outer: [(CGFloat, CGFloat)] = [
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
    
    // These pixmap_X structures represent the ordering of the individual pixels on
    // each letter. The code that renders the HTTP POST messages for ola will transform
    // these to data structures for more efficient mapping from X,Y -> pixel location
    
    static let pixmap_T: [[Int]] = [
        [  46,  47,  50,  51,  56,  57,  62,  63,  68 ],
        [  45,  48,  49,  52,  55,  58,  61,  64,  67 ],
        [  44,  43,  42,  53,  54,  59,  60,  65,  66 ],
        [  -1,  -1,  -1,  41,  40,  39,  -1,  -1,  -1 ],
        [  -1,  -1,  -1,  36,  37,  38,  -1,  -1,  -1 ],
        [  -1,  -1,  -1,  35,  34,  33,  -1,  -1,  -1 ],
        [  -1,  -1,  -1,  30,  31,  32,  -1,  -1,  -1 ],
        [  -1,  -1,  -1,  29,  28,  27,  -1,  -1,  -1 ],
        [  -1,  -1,  -1,  24,  25,  26,  -1,  -1,  -1 ],
        [  -1,  -1,  -1,  23,  22,  21,  -1,  -1,  -1 ],
        [  -1,  -1,  -1,  18,  19,  20,  -1,  -1,  -1 ],
        [  -1,  -1,  -1,  17,  16,  15,  -1,  -1,  -1 ],
        [  -1,  -1,  -1,  12,  13,  14,  -1,  -1,  -1 ],
        [  -1,  -1,  -1,  11,  10,   9,  -1,  -1,  -1 ],
        [  -1,  -1,  -1,   6,   7,   8,  -1,  -1,  -1 ],
        [  -1,  -1,  -1,   5,   4,   3,  -1,  -1,  -1 ],
        [  -1,  -1,  -1,   0,   1,   2,  -1,  -1,  -1 ]
    ]
    
    static let pixmap_B: [[Int]] = [
        [ 118, 119, 120, 121, 122, 123, 124, 125,  -1 ],
        [ 117, 116, 115, 114, 113, 112, 111, 110, 109 ],
        [  88,  89,  90,  91,  92,  93,  94, 107, 108 ],
        [  87,  86,  85,  -1,  -1,  -1,  95, 106, 105 ],
        [  82,  83,  84,  -1,  -1,  -1,  96, 103, 104 ],
        [  81,  80,  79,  -1,  -1,  -1,  97, 102, 101 ],
        [  76,  77,  78,  -1,  -1,  -1,  98,  99, 100 ],
        [  75,  74,  73,  72,  71,  70,  69,  68,  67 ],
        [  59,  60,  61,  62,  63,  64,  65,  66,  -1 ],
        [  58,  57,  44,  43,  42,  41,  40,  39,  38 ],
        [  55,  56,  45,  -1,  -1,  -1,  35,  36,  37 ],
        [  54,  53,  46,  -1,  -1,  -1,  34,  33,  32 ],
        [  51,  52,  47,  -1,  -1,  -1,  29,  30,  31 ],
        [  50,  49,  48,  -1,  -1,  -1,  28,  27,  26 ],
        [  17,  18,  19,  20,  21,  22,  23,  24,  25 ],
        [  16,  15,  14,  13,  12,  11,  10,   9,   8 ],
        [   0,   1,   2,   3,   4,   5,   6,   7,  -1 ]
    ]
    
    static let pixmap_G: [[Int]] = [
        [  -1,  86,  87,  88,  89,  90,  91,  92,  93 ],
        [  83,  84,  85,  99,  98,  97,  96,  95,  94 ],
        [  82,  81,  80, 100, 101, 102, 103, 104, 105 ],
        [  77,  78,  79,  -1,  -1,  -1,  -1,  -1,  -1 ],
        [  76,  75,  74,  -1,  -1,  -1,  -1,  -1,  -1 ],
        [  71,  72,  73,  -1,  -1,  -1,  -1,  -1,  -1 ],
        [  70,  69,  68,  -1,  -1,  -1,  -1,  -1,  -1 ],
        [  65,  66,  67,  -1,  -1,  -1,   0,   1,   2 ],
        [  64,  63,  62,  -1,  -1,  -1,   5,   4,   3 ],
        [  59,  60,  61,  -1,  -1,  -1,   6,   7,   8 ],
        [  58,  57,  56,  -1,  -1,  -1,  11,  10,   9 ],
        [  53,  54,  55,  -1,  -1,  -1,  12,  13,  14 ],
        [  52,  51,  50,  -1,  -1,  -1,  17,  16,  15 ],
        [  47,  48,  49,  -1,  -1,  -1,  18,  19,  20 ],
        [  46,  45,  44,  43,  42,  41,  40,  39,  21 ],
        [  31,  32,  33,  34,  35,  36,  37,  38,  22 ],
        [  -1,  30,  29,  28,  27,  26,  25,  24,  23 ]
    ]
}
