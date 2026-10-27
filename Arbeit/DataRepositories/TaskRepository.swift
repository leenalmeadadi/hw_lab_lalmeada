
import Foundation
import Observation
import FirebaseFirestore

// Handles tasks stored in Firestore
@Observable
class TaskRepository {
    @ObservationIgnored private let path = "tasks"
    @ObservationIgnored private let store = Firestore.firestore()
    @ObservationIgnored private var listener: ListenerRegistration?

    var tasks: [TaskItem] = []

    init() {
        get()
    }

    deinit {
        listener?.remove()
    }

    // Gets tasks and listens for database changes
    func get() {
        listener = store.collection(path)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("Error getting tasks: \(error.localizedDescription)")
                    return
                }

                self.tasks = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: TaskItem.self)
                } ?? []
            }
    }

    // Adds a new task
    func create(_ task: TaskItem) {
        do {
            _ = try store.collection(path).addDocument(from: task)
        } catch {
            print("Error creating task: \(error.localizedDescription)")
        }
    }

    // Saves changes to an existing task
    func update(_ task: TaskItem) {
        guard let taskId = task.id else {
            print("Error updating task: Task ID is missing")
            return
        }

        do {
            try store.collection(path).document(taskId).setData(from: task)
        } catch {
            print("Error updating task: \(error.localizedDescription)")
        }
    }

    // Deletes a task
    func delete(_ task: TaskItem) {
        guard let taskId = task.id else {
            print("Error deleting task: Task ID is missing")
            return
        }

        store.collection(path).document(taskId).delete { error in
            if let error = error {
                print("Error deleting task: \(error.localizedDescription)")
            }
        }
    }
}
