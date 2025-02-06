import SwiftUI

struct CardView: View {
    let card: Card
    var body: some View {
        VStack {
            Text("\(card.rank.rawValue)")
                .font(.largeTitle)
            Text(card.suit.rawValue)
                .font(.caption)
        }
        .frame(width: 60, height: 90)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
        .padding(4)
    }
}