import SwiftUI

struct ScheduleCarouselComponentView<ViewModel: ScheduleCarouselViewModelRepresentable>: View {

    private let viewModel: ViewModel
    private var eventStatusBackgroundStyler: EventStatusBackgroundStyler

    init(viewModel: ViewModel) {

        self.viewModel = viewModel
        self.eventStatusBackgroundStyler = EventStatusBackgroundStyler(grandPrixCardStatus: viewModel.eventStatus)
    }


    var body: some View {

        HStack(alignment: .center, spacing: Constants.Card.horizontalSpacing) {

            VStack {
                Text(viewModel.round.description)
                    .font(.largeTitle)
                .bold()
            }

            VStack(alignment: .leading, spacing: Constants.Card.verticalSpacing) {
                Text(viewModel.title)
                    .font(.title3)
                    .bold()

                EventComponentView(eventStatus: viewModel.eventStatus)
            }
        }
        .frame(height: Constants.Card.height)
        .padding(.vertical, Constants.Card.verticalPadding)
        .padding(.horizontal, Constants.Card.horizontalPadding)
        .background(
            RoundedRectangle(cornerRadius: Constants.Card.cornerRadius)
                .fill(eventStatusBackgroundStyler.color)
        )
    }
}

fileprivate enum Constants {

    enum Card {

        static let horizontalSpacing: CGFloat = 20
        static let verticalSpacing: CGFloat = 3
        static let height: CGFloat = 60
        static let verticalPadding: CGFloat = 5
        static let horizontalPadding: CGFloat = 15
        static let cornerRadius: CGFloat = 10
    }
}

struct ScheduleCarouselView_Previews: PreviewProvider {
    static var previews: some View {

        ScheduleCarouselComponentView(
            viewModel: ScheduleCarouselViewModel(
                round: 13,
                title: "Spa-Francorchamps",
                grandPrixDate: "24-27 Set",
                eventStatus: .upcoming(details: "05-07 MAY")
            )
        )

        ScheduleCarouselComponentView(
            viewModel: ScheduleCarouselViewModel(
                round: 13,
                title: "Spa-Francorchamps",
                grandPrixDate: "24-27 Set",
                eventStatus: .current(
                    title: "FP1",
                    details: "10:30h until start"
                )
            )
        )

        ScheduleCarouselComponentView(
            viewModel: ScheduleCarouselViewModel(
                round: 13,
                title: "Spa-Francorchamps",
                grandPrixDate: "24-27 Set",
                eventStatus: .live(
                    title: "Race",
                    details: "Lap 22 of 52"
                )
            )
        )

        ScheduleCarouselComponentView(
            viewModel: ScheduleCarouselViewModel(
                round: 13,
                title: "Spa-Francorchamps",
                grandPrixDate: "24-27 Set",
                eventStatus: .finished(
                    drivers: [
                        .init(driverTicker: "HAM", value: .first),
                        .init(driverTicker: "LEC", value: .second),
                        .init(driverTicker: "VER", value: .third)
                    ]
                )
            )
        )
    }
}
