
import Foundation
import Observation

@Observable
class RepositoryViewModel {
    var repos: [Repository] = []
    var searchText: String = ""

    var filteredRepos: [Repository] {
        guard !searchText.isEmpty else { return repos }
        return repos.filter { repo in
            repo.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    @ObservationIgnored private let parser = Parser()

    func loadRepositories() {
        parser.fetchRepositories { [weak self] repos in
            self?.repos = repos
        }
    }
}
