//
//  OLAManager.swift
//  TBGB Control
//
//  Created by John Scholvin on 5/19/22.
//

import Foundation

class OLAManager {
    
    var pixlist_T1: [ (Int, Int) ]
    var pixlist_B2: [ (Int, Int) ]
    var pixlist_G3: [ (Int, Int) ]
    var pixlist_B4: [ (Int, Int) ]
    
    init() {
        self.pixlist_T1 = Array(repeating: (-1,-1), count: Letters.pixels_T)
        self.pixlist_B2 = Array(repeating: (-1,-1), count: Letters.pixels_B)
        self.pixlist_G3 = Array(repeating: (-1,-1), count: Letters.pixels_G)
        self.pixlist_B4 = Array(repeating: (-1,-1), count: Letters.pixels_B)
        
        for x in TBGB.T1_START..<(TBGB.T1_START + TBGB.LETTER_WIDTH) {
            let x0 = x
            for y in 0..<TBGB.YMAX {
                if Letters.has_pixel(x: x, y: y) {
                    pixlist_T1[Letters.pixmap_T[y][x0]] = (x, y)
                }
            }
        }
        
        for x in TBGB.B2_START..<(TBGB.B2_START + TBGB.LETTER_WIDTH) {
            let x0 = x - TBGB.B2_START
            for y in 0..<TBGB.YMAX {
                if Letters.has_pixel(x: x, y: y) {
                    pixlist_B2[Letters.pixmap_B[y][x0]] = (x, y)
                }
            }
        }
        
        for x in TBGB.G3_START..<(TBGB.G3_START + TBGB.LETTER_WIDTH) {
            let x0 = x - TBGB.G3_START
            for y in 0..<TBGB.YMAX {
                if Letters.has_pixel(x: x, y: y) {
                    pixlist_G3[Letters.pixmap_G[y][x0]] = (x, y)
                }
            }
        }
        
        for x in TBGB.B4_START..<(TBGB.B4_START + TBGB.LETTER_WIDTH) {
            let x0 = x - TBGB.B4_START
            for y in 0..<TBGB.YMAX {
                if Letters.has_pixel(x: x, y: y) {
                    pixlist_B4[Letters.pixmap_B[y][x0]] = (x, y)
                }
            }
        }
    }
    
    func render(grid: Grid) -> [String] {
        /*
           We need to build the four HTTP POST bodies, one for each letter,
           based on the RGB values in the grid. The strings are of the format:
         
             u=UNIVERSE&d=R0,G0,B0,R1,G1,B1...
         
         where:
         
           UNIVERSE is the DMX universe. The mapping T,B,G,B -> 0,1,2,3.
           Rn,Gn,Bn, is the RGB triple for pixel n. These are integers on the range [0,255].
         
         So for the T, where the first two pixels' RGB triples are (10,20,30) and (60,70,80),
         the string would be
         
           u=0&d=10,20,30,60,70,80,
         
         Note that the pixel order is defined by the way they are wired onto the boards. These
         are laid out in the data structures in Letters.pixmap_{T,B,G}. Since we need to assemble
         these strings very quickly, we will use the pixlist_{T,B,G} structures we built
         at construction of this object.
         
         I am worried about the time this will take. We may have to cache these in the Amination
         objects, but then we'd lose the master brightness slider, or have to come up with some
         other crafty way to cache the relevant data.
        */
        
        var timebase_info = mach_timebase_info(numer: 0, denom: 0)
        mach_timebase_info(&timebase_info)
        let start_time = mach_absolute_time()
        
        var T1 = "u=0&d="
        for coord in pixlist_T1 {
            let rgb = grid[coord.0, coord.1]!.components
            T1.append("\(Int(rgb![0]*255)),\(Int(rgb![1]*255)),\(Int(rgb![2]*255)),")
        }
        
        var B2 = "u=1&d="
        for coord in pixlist_B2 {
            let rgb = grid[coord.0, coord.1]!.components
            B2.append("\(Int(rgb![0]*255)),\(Int(rgb![1]*255)),\(Int(rgb![2]*255)),")
        }
        
        var G3 = "u=2&d="
        for coord in pixlist_G3 {
            let rgb = grid[coord.0, coord.1]!.components
            G3.append("\(Int(rgb![0]*255)),\(Int(rgb![1]*255)),\(Int(rgb![2]*255)),")
        }
        
        var B4 = "u=3&d="
        for coord in pixlist_B4 {
            let rgb = grid[coord.0, coord.1]!.components
            B4.append("\(Int(rgb![0]*255)),\(Int(rgb![1]*255)),\(Int(rgb![2]*255)),")
        }
        
        let elapsed = Double(mach_absolute_time() - start_time) * Double(timebase_info.numer) / Double(timebase_info.denom)
        print("elapsed: \(elapsed)ns")
        
        return [T1, B2, G3, B4]
    }
}
