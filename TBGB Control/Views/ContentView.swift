//
//  ContentView.swift
//  TBGB Control
//
//  Created by John Scholvin on 4/20/22.
//

import SwiftUI
import CoreFoundation

struct ContentView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    struct AnimationButtonStyle : ButtonStyle {
        func makeBody(configuration: ButtonStyleConfiguration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.85 : 1)
                .background(configuration.isPressed ? Color.blue.cornerRadius(8) : Color.gray.cornerRadius(8))
            // TODO: make the whole button blue on press, not just the text part
        }
    }
    
    struct StatusText : View {
        private let text: String
        
        private let sfont = Font
            .system(size: 14)
            .monospaced()
        
        init(_ text: String) {
            self.text = text
        }
        
        var body: some View {
            Text(text)
                .font(sfont)
                .foregroundColor(.white)
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
    let button_rows = 3
    let button_cols = 8
    
    var timebase_info = mach_timebase_info(numer: 0, denom: 0)
    @State private var elapsed: Double = 0 // TODO: state problem
    @State private var master: Double = 1 // RGB multiplier
    
    init() {
        mach_timebase_info(&timebase_info)
    }
    
    var body: some View {
        VStack() {
            Canvas { context, size in
                // let start_time = mach_absolute_time() TODO: state problem
                let xoff = CGFloat(size.width * margin)
                let yoff = CGFloat(size.height * margin)
                let dx = CGFloat((Float(size.width) * Float(1 - margin * 2) / Float(TBGB.XMAX - 1)))
                let dy = CGFloat((Float(size.height) * Float(1 - margin * 2) / Float(TBGB.YMAX - 1)))
                //print("width: \(size.width) height: \(size.height) xoff: \(xoff) yoff: \(yoff) dx: \(dx) dy: \(dy)")
                
                for x in 0...TBGB.XMAX - 1 {
                    for y in 0...TBGB.YMAX - 1 {
                        if Letters.has_pixel(x: x, y: y) {
                            let pixel = Globals.mod_color(color: viewModel.grid()[x, y]!, mult: master)
                            context.fill(Path(ellipseIn: CGRect(x: xoff + CGFloat(x) * dx - pdiam / 2,
                                                                y: yoff + CGFloat(y) * dy - pdiam / 2,
                                                                width: pdiam, height:pdiam)),
                                         with: .color(Color(pixel)))
                        }
                    }
                }
                var t_out = Path()
                t_out.move(to: CGPoint(x: xoff + Letters.outline_T[0].0 * dx,
                                       y: yoff + Letters.outline_T[0].1 * dy))
                for i in Letters.outline_T {
                    t_out.addLine(to: CGPoint(x: xoff + i.0 * dx,
                                              y: yoff + i.1 * dy))
                }
                t_out.closeSubpath()
                context.stroke(t_out, with: .color(outline))
                
                var b2_out = Path()
                b2_out.move(to: CGPoint(x: xoff + (Letters.outline_B_outer[0].0 + b2_xoff) * dx,
                                        y: yoff + Letters.outline_B_outer[0].1 * dy))
                for i in Letters.outline_B_outer {
                    b2_out.addLine(to: CGPoint(x: xoff + (i.0 + b2_xoff) * dx,
                                               y: yoff + i.1 * dy))
                }
                b2_out.closeSubpath()
                context.stroke(b2_out, with: .color(outline))
                var b2_in_upper = Path()
                b2_in_upper.move(to: CGPoint(x: xoff + (Letters.outline_B_inner[0].0 + b2_xoff) * dx,
                                             y: yoff + (Letters.outline_B_inner[0].1 + b_yoff_upper) * dy))
                for i in Letters.outline_B_inner {
                    b2_in_upper.addLine(to: CGPoint(x: xoff + (i.0 + b2_xoff) * dx,
                                                    y: yoff + (i.1 + b_yoff_upper) * dy))
                }
                b2_in_upper.closeSubpath()
                context.stroke(b2_in_upper, with: .color(outline))
                var b2_in_lower = Path()
                b2_in_lower.move(to: CGPoint(x: xoff + (Letters.outline_B_inner[0].0 + b2_xoff) * dx,
                                             y: yoff + (Letters.outline_B_inner[0].1 + b_yoff_lower) * dy))
                for i in Letters.outline_B_inner {
                    b2_in_lower.addLine(to: CGPoint(x: xoff + (i.0 + b2_xoff) * dx,
                                                    y: yoff + (i.1 + b_yoff_lower) * dy))
                }
                b2_in_lower.closeSubpath()
                context.stroke(b2_in_lower, with: .color(outline))
                
                var g_out = Path()
                g_out.move(to: CGPoint(x: xoff + Letters.outline_G_outer[0].0 * dx,
                                       y: yoff + Letters.outline_G_outer[0].1 * dy))
                for i in Letters.outline_G_outer {
                    g_out.addLine(to: CGPoint(x: xoff + i.0 * dx,
                                              y: yoff + i.1 * dy))
                }
                g_out.closeSubpath()
                context.stroke(g_out, with: .color(outline))
                
                var b4_out = Path()
                b4_out.move(to: CGPoint(x: xoff + (Letters.outline_B_outer[0].0 + b4_xoff) * dx,
                                        y: yoff + Letters.outline_B_outer[0].1 * dy))
                for i in Letters.outline_B_outer {
                    b4_out.addLine(to: CGPoint(x: xoff + (i.0 + b4_xoff) * dx,
                                               y: yoff + i.1 * dy))
                }
                b4_out.closeSubpath()
                context.stroke(b4_out, with: .color(outline))
                var b4_in_upper = Path()
                b4_in_upper.move(to: CGPoint(x: xoff + (Letters.outline_B_inner[0].0 + b4_xoff) * dx,
                                             y: yoff + (Letters.outline_B_inner[0].1 + b_yoff_upper) * dy))
                for i in Letters.outline_B_inner {
                    b4_in_upper.addLine(to: CGPoint(x: xoff + (i.0 + b4_xoff) * dx,
                                                    y: yoff + (i.1 + b_yoff_upper) * dy))
                }
                b4_in_upper.closeSubpath()
                context.stroke(b4_in_upper, with: .color(outline))
                var b4_in_lower = Path()
                b4_in_lower.move(to: CGPoint(x: xoff + (Letters.outline_B_inner[0].0 + b4_xoff) * dx,
                                             y: yoff + (Letters.outline_B_inner[0].1 + b_yoff_lower) * dy))
                for i in Letters.outline_B_inner {
                    b4_in_lower.addLine(to: CGPoint(x: xoff + (i.0 + b4_xoff) * dx,
                                                    y: yoff + (i.1 + b_yoff_lower) * dy))
                }
                b4_in_lower.closeSubpath()
                context.stroke(b4_in_lower, with: .color(outline))
                // TODO: state problem
                // can't modify state during view update
                // viewModel.elapsed = Double(mach_absolute_time() - start_time) * Double(timebase_info.numer) / Double(timebase_info.denom)
            }
            .frame(height: 750)
            .border(outline)
            .background(frame_bg)
        
            HStack() {
                VStack() { // button rows
                    ForEach(0..<button_rows, id: \.self) { row in
                        HStack() {
                            ForEach(0..<button_cols, id: \.self) { col in
                                let but = row * button_cols + col
                                Button(action: { tbgb(anim: but) }) {
                                    Text(viewModel.anim_name(num: but))
                                        .padding(EdgeInsets(top: 18, leading: 10, bottom: 18, trailing: 10))
                                }
                                .frame(width: 125)
                                .foregroundColor(but < viewModel.anim_count() ? .white : .black)
                                .background(Color.gray.cornerRadius(8))
                                .buttonStyle(AnimationButtonStyle()) // TODO: do this without a style, and only for the button
                                .disabled(but >= viewModel.anim_count())

                            }
                        }
                       .padding(.leading)
                    }
                }
                VStack() {
                    HStack() { // status area
                        VStack(alignment: .trailing) {
                            StatusText("animation:")
                            // Text("render time:").font(sfont) TODO: state problem
                            StatusText("power:")
                            StatusText("frames:")
                            StatusText("live:")
                            StatusText("sent/acked:")
                            StatusText("latency:")
                        }
                        .padding(5)
                        VStack(alignment: .leading) {
                            StatusText(viewModel.anim_current().padding(toLength: 15, withPad: " ", startingAt: 0))
                            //Text(String(format: "%.2fms", viewModel.elapsed / 1000000)).font(sfont) TODO: state problem
                            StatusText(String(format: "%.2f%%", viewModel.power() * master * 100))
                            StatusText("\(viewModel.frames)")
                            StatusText("no")
                            StatusText("xx/yy")
                            StatusText("nnn")
                        }
                        .padding(5)
                    }
                    .border(outline)
                    Slider(value: $master, in: 0...1)
                    Text(String(format: "master: %d%%", Int(master * 100))).foregroundColor(Color.white)
                    HStack() {
                        Spacer()
                        Button(action: {
                            print("settings")
                        }) {
                            // see SF Symbols app for more
                            Image(systemName: "gearshape.fill")
                                .imageScale(.large)
                        }
                        .foregroundColor(Color.white)
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .background(frame_bg)
    }
    
    func tbgb(anim: Int) {
        viewModel.change_animation(anim: anim)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(ViewModel())
    }
}
