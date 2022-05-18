//
//  Animation.swift
//  TBGB Control
//
//  Created by John Scholvin on 5/4/22.
//

import Foundation
import CoreGraphics
import SwiftUI

// a Cel is a single grid of pixels and a time to display it (could be zero if it's the only scene in the animation)
struct Cel {
    var grid: Grid
    var time_msec: Int = 0
    var cached_power: Double = -1 // TODO: make me private
    
    // this is a little mathy, so we'll calculate it only when its as
    mutating func power() -> Double {
        if cached_power != -1 {
            return cached_power
        }
        var p: Double = 0
        for x in 0...TBGB.XMAX - 1 {
            for y in 0...TBGB.YMAX - 1 {
                if Letters.has_pixel(x: x, y: y) {
                    let components = grid[x, y]!.components
                    for i in 0...2 {
                        p += components![i]
                    }
                }
            }
        }
        cached_power = p / Double(Letters.pixels_T + 2 * Letters.pixels_B + Letters.pixels_G) / 3
        return cached_power
    }
}

// an Animation is a list of Scenes
// if the length of the list is longer than 1 and loop == true, this animation loops
struct Animation {
    var cels: [Cel]
    var name: String
    var pre_blackout: Bool = false
    var loop: Bool = true
}

// this creates the list of all Animations for the application
class AnimationManager {
    var _animations: [Animation] = []
    
    init() {
        _animations.append(blackout())
        _animations.append(white25())
        _animations.append(white100())
        _animations.append(impulse())
        _animations.append(topdown())
        _animations.append(rainbow())
        
        _animations.append(hardwhite())
        //_animations.append(linetest())
       
    }
    
    // return all the animations we made
    func animations() -> [Animation] {
        return _animations
    }
    
    // --------------------------
    // individual animations below here
    
    func blackout() -> Animation {
        let s = Cel(grid: Grid(color: TBGB.BLACK))
        let a = Animation(cels: [s], name: "blackout")
        return a
    }
    
    func white100() -> Animation {
        let s = Cel(grid: Grid(color: TBGB.INCANDESCENT))
        let a = Animation(cels: [s], name: "100% white")
        return a
    }
    
    func white25() -> Animation {
        let s = Cel(grid: Grid(color: Globals.mod_color(color: TBGB.INCANDESCENT, mult: 0.25)))
        let a = Animation(cels: [s], name: "25% white")
        return a
    }
    
    func hardwhite() -> Animation {
        let s = Cel(grid: Grid(color: TBGB.WHITE))
        let a = Animation(cels: [s], name: "hard white")
        return a
    }
    
    func topdown() -> Animation {
        let delay = 75
        var cels: [Cel] = []
        for z in 0..<TBGB.YMAX {
            var cel = Cel(grid: Grid(color: TBGB.BLACK))
            for y in 0...z {
                for x in 0..<TBGB.XMAX {
                    cel.grid[x, y] = TBGB.INCANDESCENT
                }
            }
            cel.time_msec = delay
            cels.append(cel)            
        }
        return Animation(cels: cels, name: "top down", pre_blackout: true)
    }
    
    func linetest() -> Animation {
        var g = Grid(color: TBGB.BLACK)
        g.line(x0: 0, y0: 0, x1: TBGB.XMAX-1, y1: TBGB.YMAX-1, color: TBGB.ORANGE)
        g.line(x0: TBGB.XMAX-1, y0: 0, x1: 0, y1: TBGB.YMAX-1, color: TBGB.GREEN)
        let cel = Cel(grid: g)
        return Animation(cels: [cel], name: "linetest")
    }
    
    // someday: make it appear to go NW -> SE
    func rainbow() -> Animation {
        var cels: [Cel] = []
        var c = 0
        
        for _ in 0..<TBGB.RAINBOW.count {
            var g = Grid(color: TBGB.BLACK)
            for x in 0..<(TBGB.XMAX + TBGB.YMAX - 2) {
                g.line(x0: x, y0: 0, x1: 0, y1: x, color: TBGB.RAINBOW[c]);
                c = (c + 1) % TBGB.RAINBOW.count
            }
            cels.append(Cel(grid: g, time_msec: 75))
            c = (c + 1) % TBGB.RAINBOW.count
        }
        return Animation(cels: cels, name: "rainbow")
    }
    
    func impulse() -> Animation {
        let IMPULSE_STEPS = 10
        let IMPULSE_DELAY = 5
        let IMPULSE_START = 1.0
        let IMPULSE_MID = 0.1
        let IMPULSE_END = 0.25
        
        var cels: [Cel] = []
        var mult = IMPULSE_START
        while mult > IMPULSE_MID {
            let g = Grid(color: Globals.mod_color(color: TBGB.INCANDESCENT, mult: mult))
            var cel = Cel(grid: g)
            cel.time_msec = IMPULSE_DELAY
            cels.append(cel)
            mult -= (IMPULSE_START-IMPULSE_MID) / Double(IMPULSE_STEPS)
        }
        while mult > IMPULSE_END {
            let g = Grid(color: Globals.mod_color(color: TBGB.INCANDESCENT, mult: mult))
            var cel = Cel(grid: g)
            cel.time_msec = IMPULSE_DELAY
            cels.append(cel)
            mult -= (IMPULSE_MID-IMPULSE_END) / Double(IMPULSE_STEPS)
        }
        
        return Animation(cels: cels, name: "impulse", loop: false)
    }
    
    
}
