
import Foundation
import FirebaseFirestore

// Stores the information for one task
struct TaskItem: Identifiable, Comparable, Codable, Hashable {
    @DocumentID var id: String?
    var name: String
    var assignedTo: String
    var dueDate: Date
    var dateAdded: Date
    var completed: Bool

    // Fields saved in Firestore
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case assignedTo
        case dueDate
        case dateAdded
        case completed
    }

    // Checks if two tasks are the same
    static func == (lhs: TaskItem, rhs: TaskItem) -> Bool {
        return lhs.name == rhs.name &&
            lhs.assignedTo == rhs.assignedTo &&
            lhs.dueDate == rhs.dueDate
    }

    // Sorts tasks by name
    static func < (lhs: TaskItem, rhs: TaskItem) -> Bool {
        return lhs.name < rhs.name
    }

    // Used to compare tasks
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(assignedTo)
        hasher.combine(dueDate)
    }

    // Checks that the required fields are filled in
    static func isValid(name: String, assignedTo: String) -> Bool {
        return !name.isEmpty && !assignedTo.isEmpty
    }
}
