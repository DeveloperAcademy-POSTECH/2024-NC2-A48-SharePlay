import SwiftUI

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
