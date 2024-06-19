import SwiftUI
import PencilKit
import GroupActivities

struct DrawingView : UIViewRepresentable {
    @Binding var drawingView: PKCanvasView
    @ObservedObject var canvasController: CanvasController
    @Binding var isDraw : Bool
    @Binding var type : PKInkingTool.InkType
    @Binding var color : Color
    @Binding var thickness: CGFloat
    
    var ink : PKInkingTool{
        PKInkingTool(type, color: UIColor(color), width: thickness)
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
