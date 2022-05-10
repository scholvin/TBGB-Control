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
        self.elements = Array(repeating: color, count: TBGB.YMAX * TBGB.XMAX)
    }
    
    subscript(x: Int, y: Int) -> CGColor? {
        get { elements[(y * TBGB.XMAX) + x] }
        set { elements[(y * TBGB.XMAX) + x] = newValue }
    }
    
    // Bresenham rides again
    // https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
    mutating func line(x0: Int, y0: Int, x1: Int, y1: Int, color: CGColor) {
        if x0 == x1 {
            // special case for vertical
            for y in min(y0, y1)...max(y0, y1) {
                if x0 >= 0 && x0 < TBGB.XMAX && y >= 0 && y < TBGB.YMAX {
                    self[x0, y] = color
                }
            }
            return;
            
        }
        if y0 == y1 {
            // special case for horizontal
            for x in min(x0, x1)...max(x0, x1) {
                if x >= 0 && x < TBGB.XMAX && y0 >= 0 && y0 < TBGB.YMAX {
                    self[x, y0] = color;
                }
            }
            return;
        }
        if abs(y1-y0) < abs(x1-x0) {
            if x0 > x1 {
                lineLow(x0: x1, y0: y1, x1: x0, y1: y0, color: color)
            } else {
                lineLow(x0: x0, y0: y0, x1: x1, y1: y1, color: color)
            }
        } else {
            if y0 > y1 {
                lineHigh(x0: x1, y0: y1, x1: x0, y1: y0, color: color)
            } else {
                lineHigh(x0: x0, y0: y0, x1: x1, y1: y1, color: color)
            }
        }
    }
    
    mutating func lineLow(x0: Int, y0: Int, x1: Int, y1: Int, color: CGColor) {
        let dx: Double = Double(x1) - Double(x0)
        var dy: Double = Double(y1) - Double(y0)
        var yi: Int = 1
        if dy < 0 {
            yi = -1
            dy = -dy
        }
        var D: Double = 2 * dy - dx
        var y: Int = y0

        for x in x0...x1 {
            if x >= 0 && x < TBGB.XMAX && y >= 0 && y < TBGB.YMAX {
                // silent clip
                self[x, y] = color
            }
            if D > 0 {
                y += yi
                D -= 2*dx
            }
            D += 2*dy
        }
    }
    
    mutating func lineHigh(x0: Int, y0: Int, x1: Int, y1: Int, color: CGColor) {
        var dx: Double = Double(x1) - Double(x0)
        let dy: Double = Double(y1) - Double(y0)
        var xi: Int = 1
        if dx < 0 {
            xi = -1
            dx = -dx
        }
        var D: Double = 2*dx - dy
        var x: Int = x0

        for y in y0...y1 {
            if x >= 0 && x < TBGB.XMAX && y >= 0 && y < TBGB.YMAX {
                // silent clip
                self[x,y] = color
            }
            if D > 0 {
                x += xi
                D -= 2*dy
            }
            D += 2*dx
        }
    }
}
