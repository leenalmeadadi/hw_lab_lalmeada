
import SwiftUI

struct TasksView: View {
    @Environment(TasksViewModel.self) private var viewModel
    @State private var showingNewTask = false

    var body: some View {
        List {
            ForEach(viewModel.tasks) { task in
                NavigationLink(value: task) {
                    TaskRowView(task: task)
                }
            }
            .onDelete(perform: deleteTask)
        }
        .navigationTitle("Arbeit")


        .navigationDestination(for: TaskItem.self) { task in
            TaskDetailsView(task: task)
        }
    }

    // Deletes selected tasks
    private func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            viewModel.destroy(viewModel.tasks[index])
        }
    }
}
