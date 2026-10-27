
import SwiftUI
import SwiftData

struct PeopleView: View {
    @Environment(\.modelContext) var modelContext
    @Query var people: [Person]

    var body: some View {
        List {
            ForEach(people) { person in
                NavigationLink(value: person) {
                    Text(person.name.isEmpty ? "New Person" : person.name)
                }
            }
            .onDelete(perform: deletePeople)
        }
    }

    init(
        searchString: String = "",
        sortOrder: [SortDescriptor<Person>] = []
    ) {
        _people = Query(
            filter: #Predicate { person in
                if searchString.isEmpty {
                    true
                } else {
                    person.name.localizedStandardContains(searchString)
                }
            },
            sort: sortOrder
        )
    }

    func deletePeople(at offsets: IndexSet) {
        for offset in offsets {
            let person = people[offset]
            modelContext.delete(person)
        }
    }
}
