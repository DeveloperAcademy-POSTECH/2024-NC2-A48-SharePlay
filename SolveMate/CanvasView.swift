import SwiftUI
import GroupActivities
import PencilKit

struct CanvasView: View {
    var body: some View {
        Home()
    }
}

struct Home : View {
    @StateObject var canvas = CanvasController()
    @State private var drawingView = PKCanvasView()
    @State var isDraw = true
    @State var color : Color = .black
    @State var type : PKInkingTool.InkType = .pencil
    @State var colorpicker = false
    @StateObject var groupStateObserver = GroupStateObserver()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 15) {
                    ColorPicker("", selection: $color)
                    
                    Button(action: {
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
                        isDraw = false
                    }) {
                        Image(systemName: "eraser.fill")
                            .font(.title)
                    }
                    
                    Spacer()
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
                    }
                    .buttonStyle(.borderedProminent)
                }
                .task {
                    for await session in SharePlay.sessions() {
                        canvas.configureGroupSession(session)
                    }
                }
                .padding(.horizontal, 20)
                
                Divider()
                    .padding(.top, 12)
                
                DrawingView(drawingView: $drawingView, canvasController: canvas, isDraw: $isDraw, type: $type, color: $color)
            }
        }
    }
}

// View를 그리고, UIKit 코드를 swiftUI 뷰에 적용시킬 수 있게 한다.
struct DrawingView : UIViewRepresentable {
    @Binding var drawingView: PKCanvasView
    @ObservedObject var canvasController: CanvasController
    @Binding var isDraw : Bool
    @Binding var type : PKInkingTool.InkType
    @Binding var color : Color
    
    var ink : PKInkingTool{
        PKInkingTool(type, color: UIColor(color))
    }
    
    let eraser = PKEraserTool(.bitmap)
    
    // 처음 뷰가 생성될 때 적용되는 데이터들
    func makeUIView(context: Context) -> PKCanvasView {
        drawingView.drawingPolicy = .anyInput
        drawingView.tool = isDraw ? ink : eraser
        drawingView.delegate = context.coordinator
        return drawingView
    }
    
    // 상위 뷰의 state 값이 변화할 때 업데이트가 필요한 데이터들
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.tool = isDraw ? ink : eraser
//        print("canvasController.receivedDrawingData= \(canvasController.receivedDrawingData)")
        
        // 상대방의 drawingData를 받아서 뷰를 업데이트한다.
        if let drawingData = canvasController.receivedDrawingData {
            if let drawing = try? PKDrawing(data: drawingData) {
                uiView.drawing = drawing
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self, canvasController: canvasController)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var drawingView: DrawingView
        var canvasController: CanvasController
        
        init(_ drawingView: DrawingView, canvasController: CanvasController) {
            self.drawingView = drawingView
            self.canvasController = canvasController
        }
        
        // 캔버스의 변화를 감지하고 변화된 strokes의 데이터를 보낸다.
        func canvasViewDrawingDidChange(_ drawingView: PKCanvasView) {
            let drawing = drawingView.drawing
            if let drawingData = try? drawing.dataRepresentation() {
                canvasController.sendDrawingData(drawingData)
            }
        }
        
    }
    
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView()
    }
}
