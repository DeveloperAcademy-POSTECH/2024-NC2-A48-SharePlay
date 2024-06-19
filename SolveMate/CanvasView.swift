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
    @State var selectedTool: ToolType = .pencil
    @State var selectedThickness: CGFloat = 1.0
    
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
                HStack(spacing: 0) {
                    Spacer()
                    
                    //Undo & Redo
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "arrow.uturn.backward")
                            .font(.title)
                    })
                    .padding(.trailing, 16)
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "arrow.uturn.forward")
                            .font(.title)
                    })
                    .padding(.trailing, 32)
                    
                    //changing type...
                    ToolButton(icon: "pencil", tool: .pencil, selectedTool: $selectedTool) {
                        isDraw = true
                        type = .pencil
                    }
                    .padding(.trailing, 4)
                    ToolButton(icon: "pencil.tip", tool: .pen, selectedTool: $selectedTool) {
                        isDraw = true
                        type = .pen
                    }
                    .padding(.trailing, 4)
                    ToolButton(icon: "highlighter", tool: .marker, selectedTool: $selectedTool) {
                        isDraw = true
                        type = .marker
                    }
                    
                    ToolButton(icon: "eraser", tool: .eraser, selectedTool: $selectedTool) {             //erase tool...
                        isDraw = false
                    }
                    .padding(.trailing, 32)
                    
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
                        .padding(.trailing, 32)
                    
                    //Control thickness
                    ThicknessButton(thickness: 1.0, selectedThickness: $selectedThickness, width: 12) {
                        setToolThickness(1.0)
                    }
                    .padding(.trailing, 16)
                    ThicknessButton(thickness: 5.0, selectedThickness: $selectedThickness, width: 16) {
                        setToolThickness(5.0)
                    }
                    .padding(.trailing, 16)
                    ThicknessButton(thickness: 10.0, selectedThickness: $selectedThickness, width: 20) {
                        setToolThickness(10.0)
                    }
                    .padding(.trailing, 16)
                    
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

enum ToolType {
    case pencil, pen, marker, eraser
}

struct ToolButton: View {
    let icon: String
    let tool: ToolType
    @Binding var selectedTool: ToolType
    var action: () -> Void
    
    var body: some View {
        Button(action:{
            selectedTool = tool
            action()
        }) {
            Image(systemName: icon)
                .font(.title)
                .frame(width: 44, height: 44)
                .background(selectedTool == tool ? Color("backgroundColor") : Color.white)
                .cornerRadius(8)
        }
    }
}

struct ThicknessButton: View {
    let thickness: CGFloat
    @Binding var selectedThickness: CGFloat
    let width: CGFloat
    var action: () -> Void
    
    var body: some View {
        Button(action: {
                    selectedThickness = thickness
                    action()
                }) {
                    Circle()
                        .stroke(selectedThickness == thickness ? Color.black : Color.gray, lineWidth: 2)
                        .foregroundColor(.white)
                        .frame(width: width)
                }
    }
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

