import Foundation
/*
 apiKeys
 - У айпишки есть лимиты, если закончились нужно взять другой ключ и вставить в 30 строчку
 b9e85d45eda94863a282b34a1e062e3c
 97a409595ba344a8a4de398e65af03ce
 125ee6a08620428c805b0ede9178afdb
 */

protocol NetworkServiceProtocol {
  func request(path: String, params: [String: String], searchTerm: String?, completion: @escaping (Data?, Error?) -> Void)
}

class NetworkService: NetworkServiceProtocol {
  
  func request(path: String, params: [String: String], searchTerm: String?, completion: @escaping (Data?, Error?) -> Void) {
    let parameters = self.prepareParametrs(searchTerm: searchTerm, params: params)
    let url = self.url(from: path, params: parameters)
    var request = URLRequest(url: url)
    request.httpMethod = "get"
    let task = createDataTask(from: request, completion: completion)
    print(request)
    task.resume()
  }
  
  private func prepareParametrs(searchTerm: String?, params: [String: String]) -> [String: String] {
    var parameters = params
    parameters["query"] = searchTerm
    parameters["apiKey"] = "97a409595ba344a8a4de398e65af03ce"
    parameters["number"] = String(10)
    return parameters
  }
  
  private func url(from path: String, params: [String: String]) -> URL {
    var components = URLComponents()
    components.scheme = API.scheme
    components.host = API.host
    components.path = path
    components.queryItems = params.map { URLQueryItem(name: $0, value: $1)}
    return components.url!
  }
  
  private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
    return URLSession.shared.dataTask(with: request) { data, responce, error in
      DispatchQueue.main.async {
        completion(data, error)
      }
    }
  }
  
}

