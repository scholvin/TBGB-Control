//
//  LetterModel.swift
//  TBGB Control
//
//  Created by John Scholvin on 4/28/22.
//

import Foundation
import SwiftUI
    
class ViewModel: ObservableObject {
    // this is the trigger to repaint the view, increment when ready
    @Published var frames = 0
    
    private var _animations: [Animation]
    private var _current_anim: Int = 0
    private var _current_scene: Int = 0
        
    init() {
        // constructs all the animations
        let _mgr = AnimationManager()
        self._animations = _mgr.animations()
    }
    
    // change to a new animation
    func change_animation(anim: Int)
    {
        print("change_animation \(anim)")
        _current_scene = 0
        
        // pre-blackout?
        if (_animations[anim].pre_blackout) {
            _current_anim = 0
            frames += 1
        }

        // paint first cel of new scene
        _current_anim = anim
        frames += 1

        // if this is an animation, schedule the next cel
        if _animations[_current_anim].cels.count > 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(_animations[_current_anim].cels[_current_scene].time_msec) / 1000.0)
            {
                self.change_scene()
            }
        }
    }
                           
    // change the scene within the given animation (should be called only from timer)
    func change_scene() {
        // go to the next cel and paint it
        _current_scene += 1
        if _current_scene >= _animations[_current_anim].cels.count {
            _current_scene = 0
        }
        print("change_scene \(_current_scene)")
        frames += 1
        
        // check to see if we should schedule the nexce cel, because the animation could have changed while we were sleeping
        if _animations[_current_anim].cels.count > 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(_animations[_current_anim].cels[_current_scene].time_msec) / 1000.0)
            {
                self.change_scene()
            }
        }
    }
    
    // return the name of the specified animation
    func anim_name(num: Int) -> String {
        if num < 0 || num >= _animations.count {
            return "<future>"
        }
        return _animations[num].name
    }
    
    // return the name of the current animation
    func anim_current() -> String {
        return _animations[_current_anim].name
    }
    
    // return the total number of animations coded so far
    func anim_count() -> Int {
        return _animations.count
    }
    
    // return the current grid, for painting
    func grid() -> Grid {
        return _animations[_current_anim].cels[_current_scene].grid
    }
    
    // return the power usage of the current cel
    func power() -> Double {
        return _animations[_current_anim].cels[_current_scene].power()
    }
}
