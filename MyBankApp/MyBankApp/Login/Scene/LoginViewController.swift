import UIKit

class LoginViewController: UIViewController {
    var interactor: LoginBusinessLogic?
    var router: (NSObjectProtocol & LoginRoutingLogic & LoginDataPassing)?
    private var dispatchQueue: DispatchQueueProtocol
    
    // MARK: UI Elements
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bankLogo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init(
        interactor: LoginBusinessLogic? = nil,
        router: LoginRouter? = nil,
        dispatchQueue: DispatchQueueProtocol = MainDispatchQueueWrapper()
    ) {
        self.interactor = interactor
        self.router = router
        self.dispatchQueue = dispatchQueue
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        addSubviews()
        setupImageViewConstraints()
        setupStackViewConstraints()
        setupLoginButtonConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
    }
    
    private func setupImageViewConstraints() {
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 65).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupStackViewConstraints() {
        usernameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [usernameTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupLoginButtonConstraints() {
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 185).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
    }
    
    // MARK: Actions
    @objc func loginButtonTapped() {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text,
              !username.isEmpty,
              !password.isEmpty,
              validateForm()
        else {
            displayLoginError(message: "Please fill user and password fields correctly!")
            return
        }
        let request = LoginRequest(username: username, password: password)
        interactor?.login(request: request)
    }
    
    private func validateUserTextField() -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let numberRegex = "^\\d{11}$"
        let userText = usernameTextField.text ?? ""
        
        if userText.isValidEmail() {
            return true
        } else if userText.isValidCPF() {
            return true
        } else {
            return false
        }
    }
    
    private func validatePasswordTextField() -> Bool {
        let password = passwordTextField.text ?? ""
        return password.count >= 3 && password.containsUppercaseLetter && password.containsSpecialCharacter
    }
    
    private func validateForm() -> Bool {
        let isUserValid = validateUserTextField()
        let isPasswordValid = validatePasswordTextField()
        
        return isUserValid && isPasswordValid
    }
}

extension LoginViewController: LoginDisplayLogic {
    func displayLoginSuccess() {
        router?.routeToHome()
    }
    
    func displayLoginError(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        dispatchQueue.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }
}
