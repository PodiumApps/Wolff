import SwiftUI

struct InfiniteScroller<Content: View>: View {
    var contentHeight: CGFloat
    var content: (() -> Content)
    
    @State var yOffset: CGFloat = 0

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            content()
                .offset(y: yOffset == 0 ? -contentHeight : yOffset)
        }
        .disabled(true)
        .onAppear {
            withAnimation(.linear(duration: 10).delay(3).repeatForever(autoreverses: false)) {
                yOffset = contentHeight
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
