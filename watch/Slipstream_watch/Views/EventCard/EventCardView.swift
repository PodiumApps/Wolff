import SwiftUI

struct EventCardView: View {
    var body: some View {
        Button(action: {

        }) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            Text("Spa-Francorchamps")
                                .font(.system(size: 15, weight: .semibold))
                                .multilineTextAlignment(.leading)
                        }

                        HStack(alignment: .bottom, spacing: 7) {
                            HStack(alignment: .bottom){
                                Text("🇧🇪  Belgium")
                            }
                            .font(.system(size: 12, weight: .regular))

                            Text("Round 10")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(Color.red)
                        }
                    }

//                    HStack(alignment: .bottom) {
//                        Text("05-07 September")
//                            .font(.system(size: 12, weight: .regular))
//                    }

                    // MARK: - Finished

//                    HStack(spacing: 10) {
//                        HStack(alignment: .bottom, spacing: 3) {
//                            HStack(spacing: 0) {
//                                Text("1")
//                                    .font(.system(size: 10, weight: .regular))
//                                Text("st")
//                                    .font(.system(size: 7, weight: .regular))
//                                    .baselineOffset(4)
//                            }
//                            .foregroundColor(Color.yellow)
//
//                            Text("VER")
//                                .font(.system(size: 12, weight: .semibold))
//                        }
//
//                        HStack(alignment: .bottom, spacing: 3) {
//                            HStack(spacing: 0) {
//                                Text("2")
//                                    .font(.system(size: 10, weight: .regular))
//                                Text("nd")
//                                    .font(.system(size: 7, weight: .regular))
//                                    .baselineOffset(4)
//                            }
//                            .foregroundColor(Color.gray)
//
//                            Text("LEC")
//                                .font(.system(size: 12, weight: .semibold))
//                        }
//
//                        HStack(alignment: .bottom, spacing: 3) {
//                            HStack(spacing: 0) {
//                                Text("3")
//                                    .font(.system(size: 10, weight: .regular))
//                                Text("rd")
//                                    .font(.system(size: 7, weight: .regular))
//                                    .baselineOffset(4)
//                            }
//                            .foregroundColor(Color.brown)
//
//                            Text("ALO")
//                                .font(.system(size: 12, weight: .semibold))
//                        }
//                    }

                    // MARK: - Current / Upcoming

                    VStack(alignment: .leading) {
                        HStack {
                            HStack(alignment: .bottom, spacing: 2) {
                                Text("2")
                                    .font(.system(size: 12, weight: .semibold))
                                Text("HOURS")
                                    .font(.system(size: 10, weight: .regular))
                                    .foregroundColor(Color.gray)
                            }

                            HStack(alignment: .bottom, spacing: 2) {
                                Text("30")
                                    .font(.system(size: 12, weight: .semibold))
                                Text("MINUTES")
                                    .font(.system(size: 10, weight: .regular))
                                    .foregroundColor(Color.gray)
                            }
                        }

                        HStack(alignment: .bottom, spacing: 3) {
                            Text("TO")
                                .font(.system(size: 10, weight: .regular))
                                .foregroundColor(Color.gray)
                            Text("Qualifying")
                                .font(.system(size: 10, weight: .semibold))
                        }
                    }

//                    VStack(alignment: .leading, spacing: 0) {
//                        HStack {
//                            HStack(alignment: .bottom, spacing: 4) {
//                                Text("31")
//                                    .font(.system(size: 12, weight: .semibold))
//                                Text("August")
//                                    .font(.system(size: 10, weight: .regular))
//                                    .foregroundColor(Color.gray)
//                            }
//
//                            Text("-")
//
//                            HStack(alignment: .bottom, spacing: 4) {
//                                Text("02")
//                                    .font(.system(size: 12, weight: .semibold))
//                                Text("September")
//                                    .font(.system(size: 10, weight: .regular))
//                                    .foregroundColor(Color.gray)
//                            }
//                        }
//                    }

                    // MARK: - Live

//                    HStack(alignment: .bottom) {
//                        VStack(alignment: .leading) {
//                            HStack(spacing: 10) {
//                                Text("Race")
//                                    .font(.system(size: 12, weight: .semibold))
//
//                                HStack(spacing: 2) {
//                                    Text("Lap 27 of 52")
//                                }
//                                .font(.system(size: 10, weight: .semibold))
//                                .foregroundColor(Color.white)
//
//                            }
//                            Text("HAPPENING NOW")
//                                .font(.system(size: 10, weight: .regular))
//                                .foregroundColor(Color.red)
//
//                        }
//
//                        Spacer()
//                    }
                }

                Spacer()
            }
        }
        .buttonBorderShape(
            .roundedRectangle(radius: 8)
        )
//        .background(Color.red.opacity(isAnimationActive ? 0.35 : 0.15))
//        .animation(
//            .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
//            value: isAnimationActive
//        )
//        .onAppear {
//            isAnimationActive.toggle()
//        }
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
    }

    @State private var isAnimationActive = false
}

struct EventCardView_Previews: PreviewProvider {
    static var previews: some View {
        EventCardView()
    }
}
