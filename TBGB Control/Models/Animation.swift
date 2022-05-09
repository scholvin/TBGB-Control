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
        for x in 0...Constants.TBGB_XMAX - 1 {
            for y in 0...Constants.TBGB_YMAX - 1 {
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
// if the length of the list is longer than 1, this animation loops
struct Animation {
    var cels: [Cel]
    var name: String
    var pre_blackout: Bool = false
}

// this creates the list of all Animations for the application
class AnimationManager {
    // there is some way to do these named constants based on CGColor class variables, but swift makes no sense
    let BLACK = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    let WHITE = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
    let INCANDESCENT = CGColor(red: 1, green: 144.0/255.0, blue: 32.0/255.0, alpha: 1)
    
    var _animations: [Animation] = []
    
    init() {
        _animations.append(blackout())
        _animations.append(white100())
        _animations.append(white25())
        _animations.append(topdown())
        _animations.append(hardwhite())
    }
    
    // return all the animations we made
    func animations() -> [Animation] {
        return _animations
    }
    
    // --------------------------
    // individual animations below here
    
    func blackout() -> Animation {
        let s = Cel(grid: Grid(color: BLACK))
        let a = Animation(cels: [s], name: "blackout")
        return a
    }
    
    func white100() -> Animation {
        let s = Cel(grid: Grid(color: INCANDESCENT))
        let a = Animation(cels: [s], name: "100% white")
        return a
    }
    
    func white25() -> Animation {
        let s = Cel(grid: Grid(color: Globals.mod_color(color: INCANDESCENT, mult: 0.25)))
        let a = Animation(cels: [s], name: "25% white")
        return a
    }
    
    func hardwhite() -> Animation {
        let s = Cel(grid: Grid(color: WHITE))
        let a = Animation(cels: [s], name: "hard white")
        return a
    }
    
    func topdown() -> Animation {
        let delay = 50
        var cels: [Cel] = []
        for z in 0..<Constants.TBGB_YMAX {
            var cel = Cel(grid: Grid(color: BLACK))
            for y in 0...z {
                for x in 0..<Constants.TBGB_XMAX {
                    cel.grid[x, y] = INCANDESCENT
                }
            }
            cel.time_msec = delay
            cels.append(cel)            
        }
        return Animation(cels: cels, name: "top down", pre_blackout: true)
    }
    
    
    
}
