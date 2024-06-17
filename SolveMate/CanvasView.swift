//
//  ContentView.swift
//  SolveMate
//
//  Created by 박서현 on 6/17/24.
//

import SwiftUI
import PencilKit

var undoBarButtonitem: UIBarButtonItem!
var redoBarButtonItem: UIBarButtonItem!

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
    @State var thickness: CGFloat = 1.0
    
    //default is pen...
    
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 0) {
                //navigationbar
                HStack(spacing: 15) {
                    Button(action: {}, label: {
                        Image(systemName: "chevron.backward")
                            .font(.title)
                    })
                    
                    Spacer()
                    
                    Button(action: {}, label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title)
                    })

                    //SharePlay Button
                    Button {
                        // Start the activity.
                    } label: {
                        Image(systemName: "shareplay")
                            .font(.title)
                    }
                }
                .frame(height: 44)
                .padding(.horizontal, 20)
                
                //toolbar
                HStack(spacing: 15) {
                    Spacer()
                    
                    //Undo & Redo
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "arrow.uturn.backward")
                            .font(.title)
                    })
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "arrow.uturn.forward")
                            .font(.title)
                    })
                    .padding(.trailing, 30)
                    
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
                        Image(systemName: "eraser")
                            .font(.title)
                    }
                    .padding(.trailing, 15)
                    
                    //Change color buttons...
//                    Button(action: {color = .black
//                    }) {
//                        Circle()
//                            .foregroundColor(.black)
//                            .frame(width: 28, height: 28)
//                    }
//                    Button(action: {color = .red
//                    }) {
//                        Circle()
//                            .foregroundColor(.red)
//                            .frame(width: 28, height: 28)
//                    }
//                    Button(action: {color = .blue
//                    }) {
//                        Circle()
//                            .foregroundColor(.blue)
//                            .frame(width: 28, height: 28)
//                    }
                    
                    //ColorPicker
                    ColorPicker("", selection: $color)
                        .labelsHidden()
                        .padding(.trailing, 15)
                    
                    //Control thickness
                    Button(action: {
                        setToolThickness(1.0)
                    }) {
                        Circle()
                            .stroke(Color.gray, lineWidth: 2)
                            .foregroundColor(.white)
                            .frame(width: 12)
                    }
                    Button(action: {
                        setToolThickness(5.0)
                    }) {
                        Circle()
                            .stroke(Color.gray, lineWidth: 2)
                            .foregroundColor(.white)
                            .frame(width: 16)
                    }
                    Button(action: {
                        setToolThickness(10.0)
                    }) {
                        Circle()
                            .stroke(Color.gray, lineWidth: 2)
                            .foregroundColor(.white)
                            .frame(width: 20)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .frame(height: 44)
                
                Divider()
                    .padding(.top, 12)
                
                //Drawing View...
                DrawingView(canvas: $canvas, isDraw: $isDraw, type: $type, color: $color, thickness: $thickness)
            }
        }
    }
    //Control thikness
    func setToolThickness(_ thickness: CGFloat) {
        self.thickness = thickness
        if isDraw {
            canvas.tool = PKInkingTool(type, color: UIColor(color), width: thickness)
        } else {
            canvas.tool = PKEraserTool(.bitmap, width: thickness)
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
    @Binding var thickness: CGFloat
    
    //updating inkType...
    
    //    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    
    var ink : PKInkingTool{
        PKInkingTool(type, color: UIColor(color), width: thickness)
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

