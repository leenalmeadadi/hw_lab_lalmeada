import SwiftUI

struct BookDetailView: View {
    var book: Book

    var body: some View {
        VStack {
            Text(book.title)
                .font(.title)
                .fontWeight(.black)
                .padding([.top], 40)

            Text("Author: \(book.author)")
                .font(.title3)
                .fontWeight(.bold)
                .padding(5)

            Text("Author Gender: \(book.gender)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .padding(20)
        }
        .navigationBarTitle(
            Text("Book Details"),
            displayMode: .inline
        )

        Spacer() 
    }
}
