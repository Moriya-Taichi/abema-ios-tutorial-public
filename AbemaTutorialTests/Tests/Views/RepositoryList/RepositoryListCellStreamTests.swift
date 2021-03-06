import XCTest
import RxSwift
import RxTest

@testable import AbemaTutorial

final class RepositoryListCellStreamTests: XCTestCase {
    var dependency: Dependency!

    override func setUp() {
        super.setUp()
        dependency = Dependency()
    }

    func testTitleText() {
        let testTarget = dependency.testTarget

        let owner = User(id: 123, login: "owner")
        let repository = Repository(id: 123, name: "name", description: "description", owner: owner)

        let titleText = WatchStack(testTarget.output.titleText)

        testTarget.input.repository(repository)

        XCTAssertEqual(titleText.value, "owner / name")
    }

    func testDescriptionText() {
        let testTarget = dependency.testTarget

        let description = "description"
        let repository = Repository(id: 123,
                                    name: "name",
                                    description: description,
                                    owner: .init(id: 123, login: "owner"))
        let descriptionText = WatchStack(testTarget.output.descriptionText)

        testTarget.input.repository(repository)

        XCTAssertEqual(descriptionText.value, "description")
    }
}

extension RepositoryListCellStreamTests {
    struct Dependency {
        let testTarget: RepositoryListCellStream

        init() {
            testTarget = RepositoryListCellStream()
        }
    }
}
