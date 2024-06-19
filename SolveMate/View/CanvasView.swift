import SwiftUI
import PencilKit
import GroupActivities

//var undoBarButtonitem: UIBarButtonItem!
//var redoBarButtonItem: UIBarButtonItem!

struct CanvasView: View {
    var body: some View {
        Home()
    }
}

struct Home : View {
    @StateObject var canvas = CanvasController()
    @State private var drawingView = PKCanvasView()
    @StateObject var groupStateObserver = GroupStateObserver()
    
    @State var isDraw = true
    @State var color : Color = .black
    @State var type : PKInkingTool.InkType = .pencil
    @State var colorpicker = false
    @State var thickness: CGFloat = 1.0
    @State var selectedTool: ToolType = .pencil
    @State var selectedThickness: CGFloat = 1.0
    
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

                    Button {
                        // SharePlay 실행 테스크
                        Task {
                            do {
                                _ = try await SharePlay().activate()
                            } catch {
                                print("Failed to activate SharePlay activity: \(error)")
                            }
                        }
                    } label: {
                        Image(systemName: "shareplay")
                            .font(.title)
                    }
                }
                .task {
                    for await session in SharePlay.sessions() {
                        canvas.configureGroupSession(session)
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
                    ToolButton(icon: "eraser", tool: .eraser, selectedTool: $selectedTool) {
                        isDraw = false
                    }
                    .padding(.trailing, 32)
                    
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
                
                DrawingView(drawingView: $drawingView, canvasController: canvas, isDraw: $isDraw, type: $type, color: $color, thickness: $thickness)
            }
        }
    }
    
    //Control thikness
    func setToolThickness(_ thickness: CGFloat) {
        self.thickness = thickness
        if isDraw {
            drawingView.tool = PKInkingTool(type, color: UIColor(color), width: thickness)
        } else {
            drawingView.tool = PKEraserTool(.bitmap, width: thickness)
        }
    }
}

enum ToolType {
    case pencil, pen, marker, eraser
}


struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView()
    }
}

