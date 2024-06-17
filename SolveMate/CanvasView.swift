//
//  ContentView.swift
//  SolveMate
//
//  Created by 박서현 on 6/17/24.
//

import SwiftUI
import PencilKit

struct CanvasView: View {
    var body: some View {
        Home()
    }
}

struct Home : View {
    
    @State var canvas = PKCanvasView()
    @State var isDraw = true
    @State var color : Color = .black
    @State var type : PKInkingTool.InkType = .pencil
    @State var colorpicker = false
    
    //default is pen...
    
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 0) {
                HStack(spacing: 15) {
                    //                    Spacer()
                    ColorPicker("", selection: $color)
                    
                    Button(action: {
                        //changing type...
                        isDraw = true
                        type = .pencil
                        
                    }) {
                        Label{
                        } icon: {
                            Image(systemName: "pencil")
                                .font(.title)
                        }
                    }
                    
                    Button(action: {
                        isDraw = true
                        type = .pen
                    }) {
                        Label{
                        } icon: {
                            Image(systemName: "pencil.tip")
                                .font(.title)
                        }
                    }
                    
                    Button(action: {
                        isDraw = true
                        type = .marker
                    }) {
                        Label{
                        } icon: {
                            Image(systemName: "highlighter")
                                .font(.title)
                        }
                    }
                    
                    Button(action: {
                        //erase tool...
                        isDraw = false
                        
                    }) {
                        Image(systemName: "eraser.fill")
                            .font(.title)
                    }
                    
                    Spacer()
                    
                    //SharePlay Button
                    Button {
                        // Start the activity.
                    } label: {
                        Image(systemName: "shareplay")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal, 20)
                Divider()
                    .padding(.top, 12)
                
                //Drawing View...
                DrawingView(canvas: $canvas, isDraw: $isDraw, type: $type, color: $color)
            }
        }
    }
    
    //    func SaveImage(){
    //        //getting image from cavas...
    //        let Image = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
    //
    //        //saving to albums...
    //
    //
    //    }
}

struct DrawingView : UIViewRepresentable {
    
    // to capture drawing for saving into albums...
    
    @Binding var canvas : PKCanvasView
    @Binding var isDraw : Bool
    @Binding var type : PKInkingTool.InkType
    @Binding var color : Color
    
    //updating inkType...
    
    //    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    
    var ink : PKInkingTool{
        PKInkingTool(type, color: UIColor(color))
    }
    
    let eraser = PKEraserTool(.bitmap)
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        
        canvas.tool = isDraw ? ink : eraser
        
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
        //updating tool when ever main view updates...
        
        uiView.tool = isDraw ? ink : eraser
        
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView()
    }
}
