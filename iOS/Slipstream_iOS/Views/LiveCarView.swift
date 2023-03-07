import SwiftUI

struct LiveCarView<ViewModel: LiveCarRepresentable>: View {
    
    private let viewModel: ViewModel
    
    @State private var offset: CGFloat = 0
    
    init(viewModel: ViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        ZStack {
            Image(viewModel.image)
                .foregroundColor(.white)
            
            VStack {
                VStack(spacing: 2) {
                    if viewModel.position == 1 {
                        Image.iconTrophy
                    } else {
                        Text("\(viewModel.position)")
                    }
                    Text(viewModel.label)
                        .font(.body)
                        .fontWeight(.bold)
                }
                .padding(14)
                .background(
                    Circle()
                        .fill(viewModel.position == 1 ? .yellow : .brown)
                )
                
                Spacer()
                
                if viewModel.time > 0 {
                    Text("+" + viewModel.time.roundedString)
                        .foregroundColor(.white)
                }
            }
        }
        .frame(height: 210)
        .offset(y: offset)
        .onChange(of: viewModel.offset) { value in
            withAnimation(Animation.spring(response: 0.2, dampingFraction: 0.8, blendDuration: 0.8).speed(0.3)) {
                offset = value
            }
        }
    }
}

struct LiveCarView_Previews: PreviewProvider {
    static var previews: some View {
        LiveCarView(
            viewModel: LiveCarViewModel(image: "Ferrari", position: 1, label: "VER", offset: 0, time: 0)
        )
    }
}
