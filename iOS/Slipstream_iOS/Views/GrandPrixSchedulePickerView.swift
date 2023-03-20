//
//  GrandPrixSchedulePickerView.swift
//  Slipstream_iOS
//
//  Created by Tomás Mamede on 24/02/2023.
//

import SwiftUI

struct GrandPrixSchedulePickerView<ViewModel: GrandPrixSchedulePickerViewModelRepresentable>: View {

    @State private var offset: CGPoint = .zero
    @State private var position = 0
    @State private var cardHorizontalSize: CGFloat = 0

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        VStack {
            Text("\(offset.x), \(offset.y)")
            HStack {

                ScrollViewReader { proxy in

                    Button(action: {

                    }, label: {
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.title)
                            .foregroundColor(.black)
                    })

                    ScrollView(.horizontal, showsIndicators: false) {

                        LazyHStack {
                            ForEach(0 ..< viewModel.scheduleCarouselComponents.count, id: \.self) { index in
                                ScheduleCarouselComponentView(
                                    viewModel: viewModel.scheduleCarouselComponents[index]
                                )
                            }
                        }
                        .readingScrollView(from: "scroll", into: $offset)
                    }
                    .coordinateSpace(name: "scroll")

                    Button(action: {

                    }, label: {
                        Image(systemName: "chevron.right.circle.fill")
                            .font(.title)
                            .foregroundColor(.black)
                    })
                }
            }
            .padding(.horizontal)
        }
    }
}

struct ScrollViewOffsetPreferenceKey: PreferenceKey {

    typealias Value = CGPoint

    static var defaultValue: CGPoint = .zero

    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
        print("Value = \(value)")
    }
}

struct ScrollViewOffsetModifier: ViewModifier {

    let coordinateSpace: String

    @Binding var offset: CGPoint

    func body(content: Content) -> some View {

        ZStack {
            content

            GeometryReader { proxy in

                let x = proxy.frame(in: .named(coordinateSpace)).minX
                let y = proxy.frame(in: .named(coordinateSpace)).minY

                Color.clear.preference(
                    key: ScrollViewOffsetPreferenceKey.self,
                    value: CGPoint(x: x * -1, y: y * -1)
                )
            }
        }
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
            offset = value
        }
    }
}

extension View {

    func readingScrollView(from coordinateSpace: String, into binding: Binding<CGPoint>) -> some View {

        modifier(ScrollViewOffsetModifier(coordinateSpace: coordinateSpace, offset: binding))
    }
}

struct GrandPrixSchedulePickerView_Previews: PreviewProvider {
    static var previews: some View {
        GrandPrixSchedulePickerView(
            viewModel: GrandPrixSchedulePickerViewModel(
                scheduleCarouselComponents: [
                    ScheduleCarouselViewModel.mockUpcoming,
                    ScheduleCarouselViewModel.mockLive,
                    ScheduleCarouselViewModel.mockFinished,
                    ScheduleCarouselViewModel.mockLiveEvent                ]
            )
        )
    }
}
