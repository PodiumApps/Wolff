import SwiftUI

struct LiveView<ViewModel: LiveRepresentable>: View {
    
    @ObservedObject private var viewModel: ViewModel
    
    private let columns = [GridItem(.fixed(80)), GridItem(.fixed(80))]
    
    init(viewModel: ViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        switch viewModel.state {
            
        case .loading(let sessionResults), .results(let sessionResults):
            ZStack {
                Image.liveBackground
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                GeometryReader { geometry in
                    InfiniteScroller(contentHeight: geometry.size.height) {
                        Image.liveSideBarBackground
                            .resizable()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .aspectRatio(contentMode: .fill)
                    }
                }
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    if let firstResult = sessionResults.first {
                        HStack {
                            Spacer()
                            Text("Lap \(firstResult.lap)/\(firstResult.session.laps)")
                                .foregroundColor(.white)
                        }
                        HStack {
                            Spacer()
                            Text("Fastest lap: 1:23:204")
                                .foregroundColor(.white)
                        }
                    }
                    scrollView(for: sessionResults)
                }
                .padding(.horizontal, 20)
                .padding(.top, 80)
            }
        }
    }
    
    private func calculateOffset(for time: Double, index: Int) -> CGFloat {
        
        var calc: CGFloat = 110
        
        if time > 0 {
            calc += CGFloat(time * 80)
        }
        
        if index > 0 {
            calc -= 140
        }
        
        return calc
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LiveView(viewModel: LiveViewModel())
    }
}

private extension LiveView {
    
    func scrollView(for sessionResults: [SessionResult]) -> some View {
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(Array(sessionResults.enumerated()), id: \.offset) { (index, result) in
                    LiveCarView(
                        viewModel:
                            LiveCarViewModel(
                                image: result.driver.constructor.name,
                                position: index + 1,
                                label: result.driver.codeName,
                                offset: calculateOffset(for: result.time, index: index),
                                time: result.time
                            )
                    )
                    .redacted(reason: viewModel.state == .loading(SessionResult.mock) ? .placeholder : [])
                }
            }
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
                    viewModel.checkPositions()
                }
            }
        }
    }
}
