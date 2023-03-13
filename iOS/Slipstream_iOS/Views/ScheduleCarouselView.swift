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

        ScheduleCarouselComponentView(viewModel: ScheduleCarouselViewModel.mockUpcoming)
        
        ScheduleCarouselComponentView(viewModel: ScheduleCarouselViewModel.mockLive)
        
        ScheduleCarouselComponentView(viewModel: ScheduleCarouselViewModel.mockLiveEvent)
        
        ScheduleCarouselComponentView(viewModel: ScheduleCarouselViewModel.mockFinished)
    }
}
