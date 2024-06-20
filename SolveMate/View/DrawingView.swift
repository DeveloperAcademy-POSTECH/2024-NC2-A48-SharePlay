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
    
    func makeUIView(context: Context) -> PKCanvasView {
        drawingView.drawingPolicy = .anyInput
        drawingView.tool = isDraw ? ink : eraser
        drawingView.delegate = context.coordinator
        return drawingView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.tool = isDraw ? ink : eraser
        
        if let drawingData = self.canvasController.receivedDrawingData {
            if let drawing = try? PKDrawing(data: drawingData) {
                if uiView.drawing != drawing {
                    DispatchQueue.main.async {
                        uiView.drawing = drawing
                        print("view updated")
                    }
                }
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
        
        func canvasViewDrawingDidChange(_ drawingView: PKCanvasView) {
            let drawing = drawingView.drawing
            DispatchQueue.global(qos: .background).async {
                self.canvasController.sendDrawingData(drawing.dataRepresentation())
            }
        }
    }
}
