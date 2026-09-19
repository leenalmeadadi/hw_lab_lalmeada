import SwiftUI

struct BookRowView: View {
    var book: Book

    var body: some View {
        NavigationLink(
            destination: BookDetailView(book: book),
            label: {
                Text(book.title)
                    .fontWeight(.bold)
                    .font(.body)
            }
        )
    }
}
