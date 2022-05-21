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
    
    // RGB master dimmer multiplier
    @Published var master: Double = 1
    
    private var _animations: [Animation]
    private var _current_anim: Int = 0
    private var _current_scene: Int = 0
    
    private var _task: Task<Void, Error>?
    
    private var _olamgr = OLAManager()
    private var _settings: Settings?
    private var _url: URL?
    
    private var _http_render_elapsed: UInt64 = 0
    private var _http_render_count: UInt64 = 0
    
    private var _http_request_count: UInt64 = 0
    private var _http_request_ack: UInt64 = 0
    
    private var _view_render_elapsed: UInt64 = 0
    private var _view_render_count: UInt64 = 0
    
    let NANOS_PER_MILLI: UInt64 = 1_000_000
        
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
                try await Task.sleep(nanoseconds: UInt64(_animations[_current_anim].cels[_current_scene].time_msec) * NANOS_PER_MILLI)
                self.change_scene()
            }
        }
    }
    
    func change_scene() {
        // go to the next cel and paint it, if there is a next cel
        // print("change_scene \(_current_scene)")
        _current_scene += 1
        
        if _current_scene == _animations[_current_anim].cels.count {
            // we've gone past the last scene
            _current_scene = 0
            // do we keep animating?
            if !_animations[_current_anim].loop {
                // print("not a looper")
                return
            }
        }
        
        render()
        
        // check to see if we should schedule the next cel, because the animation could have changed while we were sleeping
        if _animations[_current_anim].cels.count > 1 {
            // print("reposting")
            _task = Task {
                try await Task.sleep(nanoseconds: UInt64(_animations[_current_anim].cels[_current_scene].time_msec) * NANOS_PER_MILLI)
                self.change_scene()
            }
        }
    }
    
    // if the URL changes in the Settings dialog, update it here
    func update_url()  // TODO: call this from somewhere and test it!
    {
        _url = URL(string: "http://" + _settings!.olaAddress + "/set_dmx")
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
    
    func get_http_render_time() -> String {
        if _http_render_count > 0 {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter.string(from: NSNumber(value: _http_render_elapsed / _http_render_count / 1000))! + "µs"
        }
        return "--"
    }
    
    func get_view_render_time() -> String {
        if _view_render_count > 0 {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter.string(from: NSNumber(value: _view_render_elapsed / _view_render_count / 1000))! + "µs"
        }
        return "--"
    }
    
    func get_http_stats() -> String {
        return String(_http_request_count) + "/" + String(_http_request_ack)
    }
    
    func update_view_stats(elapsed: UInt64) {
        _view_render_elapsed += elapsed
        _view_render_count += 1
    }
    
    func render()
    {
        // update the letters via HTTP POST to OLA
        if _settings != nil && _settings!.olaEnabled {
            
            // for timing
            var timebase_info = mach_timebase_info(numer: 0, denom: 0)
            mach_timebase_info(&timebase_info)
            let start_time: UInt64 = mach_absolute_time()
            
            // this guy was taking around 400µs
            let universes = _olamgr.render(grid: grid(), master: master)            
            
            if _url == nil {
                _url = URL(string: "http://" + _settings!.olaAddress + "/set_dmx")
            }
            
            // something is slow in here
            for i in 0...3 {
                var request = URLRequest(url: _url!)
                request.httpMethod = "POST"
                request.httpBody = universes[i].data(using: String.Encoding.utf8)
                _http_request_count += 1

                // create a dataTask, which includes a closure to process the response
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    // Check for Error
                    if let error = error {
                        print("Error took place \(error)")
                        return
                    }
                    
                    // Convert HTTP Response Data to a String
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        // print("response: \(dataString)")
                        if dataString == "ok" {
                            self._http_request_ack += 1 // TODO: update the view when these change (if we can do it without too much CPU)
                            // TODO: track latency
                        }
                    }
                }
                // launch the task (async)
                task.resume()
            }
            let elapsed: UInt64 = (mach_absolute_time() - start_time) * UInt64(timebase_info.numer / timebase_info.denom)
            _http_render_elapsed += elapsed
            _http_render_count += 1
        }
        
        // this updates the local view on the app
        frames += 1
    }
}
