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
    
    func change_animation(anim: Int)
    {
        print("button \(anim) invoked")
        if anim >= 0 && anim < _animations.count {
            _current_anim = anim
            _current_scene = 0
            frames += 1 // this triggers the repaint
        }
    }
    
    func anim_name(num: Int) -> String {
        if num < 0 || num >= _animations.count {
            return "<future>"
        }
        return _animations[num].name
    }
    
    func anim_count() -> Int {
        return _animations.count
    }
    
    // current grid, for painting
    func grid() -> Grid {
        return _animations[_current_anim].cels[_current_scene].grid
    }
    
    func animation() -> String {
        return _animations[_current_anim].name
    }
    
    func power() -> Double {
        return _animations[_current_anim].cels[_current_scene].power()
    }
    
    
}
