//
//  GameViewModelTests.swift
//  EmojiHunterTests
//

import Testing
@testable import EmojiHunter

// Tests for the game logic in GameViewModel.
// @MainActor because the project uses main-actor isolation by default.
@MainActor
struct GameViewModelTests {

    @Test func startingStateIsSearching() {
        let vm = GameViewModel()
        #expect(vm.emojiStatus == .searching)
        #expect(vm.currentLevel == 0)
        #expect(vm.timeRemaining == GameViewModel.roundDuration)
    }

    @Test func adjustTimeDecrementsWhileSearching() {
        let vm = GameViewModel()
        let startingTime = vm.timeRemaining
        vm.adjustTime()
        #expect(vm.timeRemaining == startingTime - 1)
    }

    @Test func adjustTimeMarksNotFoundWhenTimeExpires() {
        let vm = GameViewModel()
        vm.timeRemaining = 0
        vm.adjustTime()
        #expect(vm.emojiStatus == .notFound)
        #expect(vm.showNext == true)
    }

    @Test func adjustTimeResetsWhenFound() {
        let vm = GameViewModel()
        vm.emojiStatus = .found
        vm.timeRemaining = 3
        vm.adjustTime()
        #expect(vm.timeRemaining == GameViewModel.roundDuration)
    }

    @Test func startSearchAdvancesLevel() {
        let vm = GameViewModel()
        let starting = vm.currentLevel
        vm.startSearch()
        // Only asserts advancement if we're not at the last level
        if starting < emojiObjects.count - 1 {
            #expect(vm.currentLevel == starting + 1)
            #expect(vm.emojiStatus == .searching)
        }
    }

    @Test func restartGameResetsLevel() {
        let vm = GameViewModel()
        vm.currentLevel = 3
        vm.restartGame()
        #expect(vm.currentLevel == 0)
        #expect(vm.emojiStatus == .searching)
    }
}
