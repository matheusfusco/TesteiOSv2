import XCTest
import SnapshotTesting
@testable import MyBankApp

final class LoginViewControllerTests: XCTestCase {

    private var sut: LoginViewController!
    private var interactorSpy: LoginBusinessLogicSpy!
    private var routerSpy: LoginRouterSpy!
    
    override func setUp() {
        super.setUp()
        interactorSpy = LoginBusinessLogicSpy()
        routerSpy = LoginRouterSpy()
        sut = LoginViewController(
            interactor: interactorSpy,
            router: routerSpy
        )
        isRecording = false
    }

    override func tearDown() {
        interactorSpy = nil
        routerSpy = nil
        sut = nil
        super.tearDown()
    }
    
    func test_viewDidLoad_shouldMatchSnapshot() {
        sut.viewDidLoad()
        
        assertSnapshot(matching: sut, as: .image)
    }

    func test_givenDisplayLoginSuccess_shouldRouteToHome() {
        sut.displayLoginSuccess()
        
        XCTAssertEqual(routerSpy.calledMethods, [.routeToHome])
    }
    
    func test_givenUserNameWithValidCPFlAndPasswordAreFilled_shouldCallInteractorLogin() {
        //Given
        sut.usernameTextField.text = "699.876.200-35"
        sut.passwordTextField.text = "T3st!ng"
        
        //When
        sut.loginButtonTapped()
        
        //Then
        XCTAssertEqual(interactorSpy.calledMethods, [.login(LoginRequest(username: "699.876.200-35", password: "T3st!ng"))])
    }
    
    func test_givenUserNameWithInvalidEmailAndPasswordAreFilled_shouldCallInteractorLogin() {
        //Given
        sut.usernameTextField.text = "test@testcom"
        sut.passwordTextField.text = "T3st!ng"
        
        //When
        sut.loginButtonTapped()
        
        //Then
        XCTAssertEqual(interactorSpy.calledMethods, [])
    }
    
    func test_givenUserNameAndPasswordAreFilled_shouldCallInteractorLogin() {
        //Given
        sut.usernameTextField.text = "test@test.com"
        sut.passwordTextField.text = "T3st!ng"
        
        //When
        sut.loginButtonTapped()
        
        //Then
        XCTAssertEqual(interactorSpy.calledMethods, [.login(LoginRequest(username: "699.876.200-35", password: "T3st!ng"))])
    }
    
    func test_givenUserNameOrPasswordAreNotFilled_shouldNotCallInteractorLogin() {
        //Given
        sut.usernameTextField.text = "test@test.com"
        sut.passwordTextField.text = ""
        
        //When
        sut.loginButtonTapped()
        
        //Then
        XCTAssertEqual(interactorSpy.calledMethods, [])
    }
}
