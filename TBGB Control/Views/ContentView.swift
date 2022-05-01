//
//  ContentView.swift
//  TBGB Control
//
//  Created by John Scholvin on 4/20/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: LetterModel
    
    struct AnimationButtonStyle : ButtonStyle {
        func makeBody(configuration: ButtonStyleConfiguration) -> some View {
            configuration.label
                .padding()
                .foregroundColor(.white)
                .background(Color.gray.cornerRadius(8))
                .scaleEffect(configuration.isPressed ? 0.95 : 1)
                .frame(width: 115)
        }
    }
    
    let frame_bg = Color(red: 0.07, green: 0.07, blue:0.07)
    let outline = Color.gray
    let pdiam = CGFloat(12)
    let margin = 0.05
    let b2_xoff = CGFloat(9.5)
    let b4_xoff = CGFloat(29.5)
    let b_yoff_upper = CGFloat(2.5)
    let b_yoff_lower = CGFloat(9.5)
    
    var body: some View {
        VStack() {
            Canvas { context, size in
                let xoff = CGFloat(size.width * margin)
                let yoff = CGFloat(size.height * margin)
                let dx = CGFloat((Float(size.width) * Float(1 - margin * 2) / Float(Constants.TBGB_XMAX - 1)))
                let dy = CGFloat((Float(size.height) * Float(1 - margin * 2) / Float(Constants.TBGB_YMAX - 1)))
                print("width: \(size.width) height: \(size.height) xoff: \(xoff) yoff: \(yoff) dx: \(dx) dy: \(dy)")
                
                for x in 0...Constants.TBGB_XMAX - 1 {
                    for y in 0...Constants.TBGB_YMAX - 1 {
                        if viewModel.has_pixel(x: x, y: y) {
                            context.fill(Path(ellipseIn: CGRect(x: xoff + CGFloat(x) * dx - pdiam / 2,
                                                                y: yoff + CGFloat(y) * dy - pdiam / 2,
                                                                width: pdiam, height:pdiam)),
                                         with: .color(viewModel.grid[y, x]!))
                        }
                    }
                }
                var t_out = Path()
                t_out.move(to: CGPoint(x: xoff + viewModel.outline_T[0].0 * dx,
                                       y: yoff + viewModel.outline_T[0].1 * dy))
                for i in viewModel.outline_T {
                    t_out.addLine(to: CGPoint(x: xoff + i.0 * dx,
                                              y: yoff + i.1 * dy))
                }
                t_out.closeSubpath()
                context.stroke(t_out, with: .color(outline))
                
                var b2_out = Path()
                b2_out.move(to: CGPoint(x: xoff + (viewModel.outline_B_outer[0].0 + b2_xoff) * dx,
                                        y: yoff + viewModel.outline_B_outer[0].1 * dy))
                for i in viewModel.outline_B_outer {
                    b2_out.addLine(to: CGPoint(x: xoff + (i.0 + b2_xoff) * dx,
                                               y: yoff + i.1 * dy))
                }
                b2_out.closeSubpath()
                context.stroke(b2_out, with: .color(outline))
                var b2_in_upper = Path()
                b2_in_upper.move(to: CGPoint(x: xoff + (viewModel.outline_B_inner[0].0 + b2_xoff) * dx,
                                             y: yoff + (viewModel.outline_B_inner[0].1 + b_yoff_upper) * dy))
                for i in viewModel.outline_B_inner {
                    b2_in_upper.addLine(to: CGPoint(x: xoff + (i.0 + b2_xoff) * dx,
                                                    y: yoff + (i.1 + b_yoff_upper) * dy))
                }
                b2_in_upper.closeSubpath()
                context.stroke(b2_in_upper, with: .color(outline))
                var b2_in_lower = Path()
                b2_in_lower.move(to: CGPoint(x: xoff + (viewModel.outline_B_inner[0].0 + b2_xoff) * dx,
                                             y: yoff + (viewModel.outline_B_inner[0].1 + b_yoff_lower) * dy))
                for i in viewModel.outline_B_inner {
                    b2_in_lower.addLine(to: CGPoint(x: xoff + (i.0 + b2_xoff) * dx,
                                                    y: yoff + (i.1 + b_yoff_lower) * dy))
                }
                b2_in_lower.closeSubpath()
                context.stroke(b2_in_lower, with: .color(outline))
                
                var g_out = Path()
                g_out.move(to: CGPoint(x: xoff + viewModel.outline_G_outer[0].0 * dx,
                                       y: yoff + viewModel.outline_G_outer[0].1 * dy))
                for i in viewModel.outline_G_outer {
                    g_out.addLine(to: CGPoint(x: xoff + i.0 * dx,
                                              y: yoff + i.1 * dy))
                }
                g_out.closeSubpath()
                context.stroke(g_out, with: .color(outline))
                
                var b4_out = Path()
                b4_out.move(to: CGPoint(x: xoff + (viewModel.outline_B_outer[0].0 + b4_xoff) * dx,
                                        y: yoff + viewModel.outline_B_outer[0].1 * dy))
                for i in viewModel.outline_B_outer {
                    b4_out.addLine(to: CGPoint(x: xoff + (i.0 + b4_xoff) * dx,
                                               y: yoff + i.1 * dy))
                }
                b4_out.closeSubpath()
                context.stroke(b4_out, with: .color(outline))
                var b4_in_upper = Path()
                b4_in_upper.move(to: CGPoint(x: xoff + (viewModel.outline_B_inner[0].0 + b4_xoff) * dx,
                                             y: yoff + (viewModel.outline_B_inner[0].1 + b_yoff_upper) * dy))
                for i in viewModel.outline_B_inner {
                    b4_in_upper.addLine(to: CGPoint(x: xoff + (i.0 + b4_xoff) * dx,
                                                    y: yoff + (i.1 + b_yoff_upper) * dy))
                }
                b4_in_upper.closeSubpath()
                context.stroke(b4_in_upper, with: .color(outline))
                var b4_in_lower = Path()
                b4_in_lower.move(to: CGPoint(x: xoff + (viewModel.outline_B_inner[0].0 + b4_xoff) * dx,
                                             y: yoff + (viewModel.outline_B_inner[0].1 + b_yoff_lower) * dy))
                for i in viewModel.outline_B_inner {
                    b4_in_lower.addLine(to: CGPoint(x: xoff + (i.0 + b4_xoff) * dx,
                                                    y: yoff + (i.1 + b_yoff_lower) * dy))
                }
                b4_in_lower.closeSubpath()
                context.stroke(b4_in_lower, with: .color(outline))
                
            }
            .frame(height: 750)
            .border(outline)
            .background(frame_bg)
        
            HStack() {
                VStack() { // button rows
                    HStack() {
                        Button(action: { tbgb(anim: 0) }) {
                            Text("Button 00")
                        }
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: { tbgb(anim: 1) }) {
                            Text("Button 01")
                        }
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: { tbgb(anim: 2) }) {
                            Text("Button 02")
                        }
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: { tbgb(anim: 3) }) {
                            Text("Button 03")
                        }
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: { tbgb(anim: 4) }) {
                            Text("Button 04")
                        }
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: { tbgb(anim: 5) }) {
                            Text("Button 05")
                        }
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: { tbgb(anim: 6) }) {
                            Text("Button 06")
                        }
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: { tbgb(anim: 7) }) {
                            Text("Button 07")
                        }
                        .buttonStyle(AnimationButtonStyle())
                    }
                    .padding(.leading)
                    HStack() { // row 2
                        Button(action: { tbgb(anim: 8) }) {
                            Text("Button 08")
                        }
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: { tbgb(anim: 9) }) {
                            Text("Button 09")
                        }
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: { tbgb(anim: 10) }) {
                            Text("Button 10")
                        }
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: { tbgb(anim: 11) }) {
                            Text("Button 11")
                        }
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: { tbgb(anim: 12) }) {
                            Text("Button 12")
                        }
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: { tbgb(anim: 13) }) {
                            Text("Button 13")
                        }
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: { tbgb(anim: 14) }) {
                            Text("Button 14")
                        }
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: { tbgb(anim: 15) }) {
                            Text("Button 15")
                        }
                        .buttonStyle(AnimationButtonStyle())
                    }
                    .padding(.leading)
                    HStack() { // row 3
                        Button(action: { tbgb(anim: 16) }) {
                            Text("Button 16")
                        }
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: { tbgb(anim: 17) }) {
                            Text("Button 17")
                        }
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: { tbgb(anim: 18) }) {
                            Text("Button 18")
                        }
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: { tbgb(anim: 19) }) {
                            Text("Button 19")
                        }
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: { tbgb(anim: 20) }) {
                            Text("Button 20")
                        }
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: { tbgb(anim: 21) }) {
                            Text("Button 21")
                        }
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: { tbgb(anim: 22) }) {
                            Text("Button 22")
                        }
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: { tbgb(anim: 23) }) {
                            Text("Button 23")
                        }
                        .buttonStyle(AnimationButtonStyle())
                    }
                    .padding(.leading)
                    
                }
                Spacer() // this is where the status window will go
            }
            Spacer()
        }
    }
    
    func tbgb(anim: Int) {
        print("button \(anim) invoked")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(LetterModel())
    }
}
