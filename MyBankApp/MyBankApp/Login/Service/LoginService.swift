import Foundation

protocol LoginServiceProtocol {
    func login(user: String, password: String, completion: @escaping (Result<LoginResponse, NetworkError>) -> Void)
}

final class LoginService: LoginServiceProtocol {
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkServiceImpl()) {
        self.networkService = networkService
    }
    
    func login(
        user: String,
        password: String,
        completion: @escaping (Result<LoginResponse, NetworkError>) -> Void
    ) {
        guard let url = URL(string: "https://6092aef785ff5100172136c2.mockapi.io/api/login") else {
            completion(.failure(.invalidResponse))
            return
        }
        
        let bodyParameters = ["user": user, "password": password]
        
        networkService.request(
            url: url,
            method: .post,
            bodyParameters: bodyParameters
        ) { (result: Result<LoginResponse, NetworkError>) in
            completion(result)
        }
    }
}
