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
        _animations.append(zero_to_full(color: TBGB.INCANDESCENT, oscillate: false, name: "0 to 100", loop: true))
        _animations.append(topdown())
        _animations.append(leftright())
        _animations.append(rainbow())
        _animations.append(zero_to_full(color: TBGB.BLUE, oscillate: true, name: "osc blue", loop: true))
        _animations.append(zero_to_full(color: TBGB.RED, oscillate: true, name: "osc red", loop: true))
        _animations.append(zero_to_full(color: TBGB.GREG, oscillate: true, name: "osc yellow", loop: true))
        _animations.append(one_by_one()) // testing only
        
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
        let DELAY = 75
        var cels: [Cel] = []
        for z in 0..<TBGB.YMAX {
            var cel = Cel(grid: Grid(color: TBGB.BLACK))
            for y in 0...z {
                for x in 0..<TBGB.XMAX {
                    cel.grid[x, y] = TBGB.INCANDESCENT
                }
            }
            cel.time_msec = DELAY
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
        let IMPULSE_STEPS = 50
        let IMPULSE_DELAY = 5
        let IMPULSE_START = 1.0
        let IMPULSE_MID = 0.1
        let IMPULSE_END = 0.25
        
        // for some reason in the original, this goes down from START to MID, and then back up to END
        var cels: [Cel] = []
        var mult = IMPULSE_START
        while mult > IMPULSE_MID {
            let g = Grid(color: Globals.mod_color(color: TBGB.INCANDESCENT, mult: mult))
            var cel = Cel(grid: g)
            cel.time_msec = IMPULSE_DELAY
            cels.append(cel)
            mult -= (IMPULSE_START-IMPULSE_MID) / Double(IMPULSE_STEPS)
        }
        // also in the original, it comes back up in half as many steps as it went down
        while mult < IMPULSE_END {
            let g = Grid(color: Globals.mod_color(color: TBGB.INCANDESCENT, mult: mult))
            var cel = Cel(grid: g)
            cel.time_msec = IMPULSE_DELAY
            cels.append(cel)
            mult += (IMPULSE_END-IMPULSE_MID) / Double(IMPULSE_STEPS / 2)
        }
        
        return Animation(cels: cels, name: "impulse", loop: false)
    }
    
    // this was "foo_to_full" in the original, but it always started at zero
    func zero_to_full(color: CGColor, oscillate: Bool, name: String, loop: Bool) -> Animation {
        let ZERO_TO_FULL_STEPS = 50
        let ZERO_TO_FULL_DELAY = 20
        
        var cels: [Cel] = []
        var mult = 0.0
        while mult < 1.0 {
            let g = Grid(color: Globals.mod_color(color: color, mult: mult))
            var cel = Cel(grid: g)
            cel.time_msec = ZERO_TO_FULL_DELAY
            cels.append(cel)
            mult += 1 / Double(ZERO_TO_FULL_STEPS)
        }
        if oscillate {
            while mult > 0.0 {
                let g = Grid(color: Globals.mod_color(color: color, mult: mult))
                var cel = Cel(grid: g)
                cel.time_msec = ZERO_TO_FULL_DELAY
                cels.append(cel)
                mult -= 1 / Double(ZERO_TO_FULL_STEPS)
            }
        }
        
        return Animation(cels: cels, name: name, loop: loop)
    }
    
    func leftright() -> Animation {
        let DELAY = 35
        var cels: [Cel] = []
        for z in 0..<TBGB.XMAX {
            var cel = Cel(grid: Grid(color: TBGB.BLACK))
            for x in 0...z {
                for y in 0..<TBGB.YMAX {
                    cel.grid[x, y] = TBGB.INCANDESCENT
                }
            }
            cel.time_msec = DELAY
            cels.append(cel)
        }
        return Animation(cels: cels, name: "left right", pre_blackout: true)
    }
    
    // this is just for testing the pixel mapping
    func one_by_one() -> Animation {
        let DELAY = 250
        var cels: [Cel] = []
        for y in 0..<TBGB.YMAX {
            for x in 0..<TBGB.XMAX {
                if Letters.has_pixel(x: x, y: y) {
                    var cel = Cel(grid: Grid(color: TBGB.BLACK))
                    cel.grid[x, y] = TBGB.WHITE
                    cel.time_msec = DELAY
                    cels.append(cel)
                }
            }
        }
        return Animation(cels: cels, name: "one by one", pre_blackout: true)
    }
}
