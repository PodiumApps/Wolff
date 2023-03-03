import SwiftUI

struct LiveSessionDriverDetailsSheet<ViewModel: LiveSessionDriverDetailsSheetViewModelRepresentable>: View {
    
    @ObservedObject private var viewModel: ViewModel
    private let constructorStyler: ConstructorStylerRepresentable
    
    init(viewModel: ViewModel) {
        
        self.viewModel = viewModel
        self.constructorStyler = ConstructorStyler(constructor: viewModel.constructor.constructorId)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(constructorStyler.constructor.color.gradient)
                .opacity(0.05)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.driver.fullName)
                            .font(.driverPositionFont)
                            .fontWeight(.semibold)
                        HStack {
                            Text(viewModel.constructor.name)
                                .fontWeight(.thin)
                        }
                    }
                    Spacer()
                    ZStack {
                        Image.racingCar
                            .resizable()
                            .scaledToFill()
                            .frame(width: 55, height: 15)
                            .foregroundColor(constructorStyler.constructor.color)
                            .offset(y: 10)
                        
                        Text("21")
                            .font(.footnote)
                            .foregroundColor(constructorStyler.constructor.color)
                            .padding(4)
                            .background(
                                Circle()
                                    .fill(.white)
                            )
                            .offset(x: -33, y: 2)
                    }
                }
                
                Divider()
                
//                HStack {
//                    Text("Provisional")
//                        .font(.eventTitleFont)
//                        .fontWeight(.medium)
//                    Text("1")
//                        .font(.liveTextFont)
//                        .fontWeight(.light)
//                    Image(systemName: "arrow.up.circle.fill")
//                        .foregroundColor(.green)
//                    
//                    Spacer()
//                    
////                    VStack {
////                        Text("Points")
////                        HStack {
////                            Text("\(viewModel.driver.points) pts")
////                            Image(systemName: "arrow.up.circle.fill")
////                                .foregroundColor(.green)
////                        }
////                    }
////
////                    Spacer()
////
////                    VStack {
////                        Text("Constructor")
////                        HStack {
////                            Text("\(viewModel.constructor.position)st - \(viewModel.constructor.points)pts")
////                        }
////                    }
//                }
                
                
                Spacer()
            }
            .padding()
        }
        .frame(height: 200)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 16)
        )
    }
}

struct LiveSessionDriverDetailsSheet_Previews: PreviewProvider {
    static var previews: some View {
        LiveSessionDriverDetailsSheet(
            viewModel: LiveSessionDriverDetailsSheetViewModel(
                driver: Driver.mockVertasppen,
                constructor: Constructor.mockFerrari
            )
        )
    }
}
