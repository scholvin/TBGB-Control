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
    
    func power() -> Double {
        
        /* get to this tomorrow - have to move has_pixel to some global thing
        var p: Double = 0
        for x in 0...Constants.TBGB_XMAX - 1 {
            for y in 0...Constants.TBGB_YMAX - 1 {
                if viewModel.has_pixel(x: x, y: y) {
                    let components = view
                }
            }
        }
         */
        return 0.4269
    }
}

// an Animation is a list of Scenes
// if the length of the list is longer than 1, this animation loops
struct Animation {
    var cels: [Cel]
    var name: String
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
        _animations.append(hardwhite())
    }
    
    // utility modify the input color by multiplying the RGB space by mult
    func mod_color(color: CGColor, mult: Double) -> CGColor {
        let components = color.components
        return CGColor(red: components![0] * mult, green: components![1] * mult, blue: components![2] * mult, alpha: components![3])
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
        let s = Cel(grid: Grid(color: mod_color(color: INCANDESCENT, mult: 0.25)))
        let a = Animation(cels: [s], name: "25% white")
        return a
    }
    
    func hardwhite() -> Animation {
        let s = Cel(grid: Grid(color: WHITE))
        let a = Animation(cels: [s], name: "hard white")
        return a
    }
}
