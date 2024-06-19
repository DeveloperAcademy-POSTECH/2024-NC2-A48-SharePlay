import SwiftUI
import PencilKit

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
