
import Foundation
import Observation

// Connects the task screens to the repository
@Observable
class TasksViewModel {
    @ObservationIgnored private let repository: TaskRepository

    init(repository: TaskRepository = TaskRepository()) {
        self.repository = repository
    }

    // Gets the current list of tasks
    var tasks: [TaskItem] {
        repository.tasks
    }

    // Adds a task
    func add(_ task: TaskItem) {
        repository.create(task)
    }

    // Updates a task
    func update(_ task: TaskItem) {
        repository.update(task)
    }

    // Deletes a task
    func destroy(_ task: TaskItem) {
        repository.delete(task)
    }
}
