
import Testing
import Foundation
import SwiftData
@testable import SimpleContacts

@MainActor
struct PersonTests {
    // Creates a fresh in-memory container for each test.
    private func makeInMemoryContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: Person.self, configurations: config)
    }

    @Test func personInitializesWithDefaults() {
        let person = Person(
            name: "Alex Heimann",
            email: "alex@example.com",
            details: "Friend"
        )

        #expect(person.name == "Alex Heimann")
        #expect(person.email == "alex@example.com")
        #expect(person.details == "Friend")
        #expect(person.photo == nil)
    }

    @Test func insertingPersistsInContext() throws {
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)

        let person = Person(
            name: "An Heimann",
            email: "an@example.com",
            details: "Wife"
        )

        context.insert(person)
        try context.save()

        let descriptor = FetchDescriptor<Person>()
        let all = try context.fetch(descriptor)

        #expect(all.count == 1)
        #expect(all.first?.name == "An Heimann")
    }

    @Test func deleteRemovesFromContext() throws {
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)

        let person = Person(
            name: "Tim Daigle",
            email: "tim@example.com",
            details: ""
        )

        context.insert(person)
        try context.save()

        context.delete(person)
        try context.save()

        let all = try context.fetch(FetchDescriptor<Person>())
        #expect(all.isEmpty)
    }

    @Test func sortDescriptorOrdersByName() throws {
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)

        context.insert(Person(name: "Tom Brady", email: "", details: ""))
        context.insert(Person(name: "Alex Heimann", email: "", details: ""))
        context.insert(Person(name: "Tim Daigle", email: "", details: ""))
        try context.save()

        var descriptor = FetchDescriptor<Person>()
        descriptor.sortBy = [SortDescriptor(\.name)]
        let sorted = try context.fetch(descriptor)

        #expect(sorted.map(\.name) == [
            "Alex Heimann",
            "Tim Daigle",
            "Tom Brady"
        ])
    }

    @Test func searchPredicateMatchesSubstring() throws {
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)

        context.insert(Person(name: "Alex Heimann", email: "", details: ""))
        context.insert(Person(name: "An Heimann", email: "", details: ""))
        context.insert(Person(name: "Tom Brady", email: "", details: ""))
        try context.save()

        let needle = "heim"
        let descriptor = FetchDescriptor<Person>(
            predicate: #Predicate {
                $0.name.localizedStandardContains(needle)
            }
        )

        let matches = try context.fetch(descriptor)

        #expect(matches.count == 2)
        #expect(matches.allSatisfy {
            $0.name.localizedStandardContains("heim")
        })
    }
}
