
import Testing
import Foundation
@testable import Arbeit

@MainActor
struct TaskItemTests {
    private static let fixedDate = Date(timeIntervalSince1970: 1_700_000_000)

    // Creates a sample task for testing
    private func sample(
        name: String = "Write lab",
        assignedTo: String = "Prof H",
        dueDate: Date = TaskItemTests.fixedDate
    ) -> TaskItem {
        TaskItem(
            name: name,
            assignedTo: assignedTo,
            dueDate: dueDate,
            dateAdded: TaskItemTests.fixedDate,
            completed: false
        )
    }

    // Tests that an empty name is rejected
    @Test func validationRejectsEmptyName() {
        #expect(TaskItem.isValid(name: "", assignedTo: "someone") == false)
    }

    // Tests that an empty assignee is rejected
    @Test func validationRejectsEmptyAssignee() {
        #expect(TaskItem.isValid(name: "something", assignedTo: "") == false)
    }

    // Tests that valid fields are accepted
    @Test func validationAcceptsBothPresent() {
        #expect(TaskItem.isValid(name: "something", assignedTo: "someone") == true)
    }

    // Tests equality when IDs and completion differ
    @Test func equalityIgnoresIdAndCompletion() {
        var a = sample()
        var b = sample()
        a.id = "abc"
        b.id = "xyz"
        b.completed = true
        #expect(a == b)
    }

    // Tests sorting tasks alphabetically by name
    @Test func sortsByName() {
        let apple = sample(name: "Apple")
        let banana = sample(name: "Banana")
        let cherry = sample(name: "Cherry")
        let sorted = [cherry, apple, banana].sorted()
        #expect(sorted.map(\.name) == ["Apple", "Banana", "Cherry"])
    }
}
