//
//  LetterModel.swift
//  TBGB Control
//
//  Created by John Scholvin on 4/28/22.
//

import Foundation
import SwiftUI
    
@MainActor class ViewModel: ObservableObject {
    // this is the trigger to repaint the view, increment when ready
    @Published var frames = 0
    
    private var _animations: [Animation]
    private var _current_anim: Int = 0
    private var _current_scene: Int = 0
    
    private var _task: Task<Void, Error>?
    
    private var _olamgr = OLAManager()
    private var _settings: Settings?
    
    let MILLION: UInt64 = 1_000_000
        
    init() {
        // constructs all the animations
        let _mgr = AnimationManager()
        self._animations = _mgr.animations()
        self._task = nil
    }
    
    // change to a new animation (task based)
    func change_animation(anim: Int, settings: Settings) {
        print("change_animation \(anim)")
        
        // a bit hacky - keep a copy of this guy here for the duration of this animation
        _settings = settings
        
        // cancel any existing timers
        if _task != nil {
            _task!.cancel()
            _task = nil
        }
        _current_scene = 0
        
        // pre-blackout?
        if (_animations[anim].pre_blackout) {
            _current_anim = 0
            render()
        }
        
        // paint first cel of new scene
        _current_anim = anim
        render()
        
        // if this is a multi-cel animation, schedule the next cel
        if _animations[_current_anim].cels.count > 1 {
            _task = Task {
                try await Task.sleep(nanoseconds: UInt64(_animations[_current_anim].cels[_current_scene].time_msec) * MILLION)
                self.change_scene()
            }
        }
    }
    
    func change_scene() {
        // go to the next cel and paint it, if there is a next cel
        print("change_scene \(_current_scene)")
        _current_scene += 1
        
        if _current_scene == _animations[_current_anim].cels.count {
            // we've gone past the last scene
            _current_scene = 0
            // do we keep animating?
            if !_animations[_current_anim].loop {
                print("not a looper")
                return
            }
        }
        
        render()
        
        // check to see if we should schedule the next cel, because the animation could have changed while we were sleeping
        if _animations[_current_anim].cels.count > 1 {
            print("reposting")
            _task = Task {
                try await Task.sleep(nanoseconds: UInt64(_animations[_current_anim].cels[_current_scene].time_msec) * 1000000)
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
    
    func render()
    {
        if _settings != nil && _settings!.olaEnabled {
            let universes = _olamgr.render(grid())
            print(universes[0])
        }
        frames += 1
    }
}
