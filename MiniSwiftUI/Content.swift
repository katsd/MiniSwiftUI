//
// Created by Katsu Matsuda on 2022/07/19.
//

import Foundation

struct Counter: View {
    @State var count = 0

    var body: some View {
        VStack {
            Text("\(count)")
                .padding(20)

            HStack {
                Button(action: { count -= 1 }) {
                    Color.blue
                        .cornerRadius(10)
                        .overlay(Text("Decrement"))

                }
                    .padding(10)

                Button(action: { count += 1 }) {
                    Color.blue
                        .cornerRadius(10)
                        .overlay(Text("Increment"))
                }
                    .padding(10)
            }
                .frame(height: 60)
        }
    }
}
