
import SwiftUI

struct TaskRowView: View {
    let task: TaskItem

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                // Show the task name
                Text(task.name)
                    .font(.headline)
                    .strikethrough(task.completed)

                // Show who the task is assigned to
                Text("Assigned to: \(task.assignedTo)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // Show the due date
                Text("Due: \(task.dueDate, style: .date)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Show a checkmark if the task is completed
            if task.completed {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 4)
    }
}
