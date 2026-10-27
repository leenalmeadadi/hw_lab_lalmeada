
import SwiftUI

struct AppView: View {
    @State private var tasksViewModel = TasksViewModel()

    var body: some View {
        TabView {
            NavigationStack {
                TasksView()
            }
            .tabItem {
                Image(systemName: "checkmark.rectangle.stack.fill")
                Text("Tasks")
            }

            NavigationStack {
                NewTaskView()
            }
            .tabItem {
                Image(systemName: "plus.app.fill")
                Text("New Task")
            }
        }
        .environment(tasksViewModel)
    }
}
