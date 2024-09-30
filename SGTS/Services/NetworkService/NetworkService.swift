//
//  NetworkService+Mail.swift
// 11.07.2024.
//

import Alamofire

protocol NetworkServicing: AuthNetworkServicing,
                           MailNetworkServicing {}

public enum NetworkError: Error {
    case unknown
}

public class NetworkService: NetworkServicing {
    
    enum Constants {
        static let timeout = TimeInterval(45)
        static let httpMaximumConnectionsPerHost = 3
        static let baseAPIURL = URL(string: secretStorage.baseURLString)!
        static let authAPIURL = URL(string: "")!
        static let bearerKey = ""
        static let idString = "{id}"
        static let guidString = "{guid}"
        static let objectIdString = "{objectId}"
    }
    
    static let secretStorage = DIManager.shared.container.resolve(SecretStorageProtocol.self)!
    internal let secretStorage = DIManager.shared.container.resolve(SecretStorageProtocol.self)!
    
    static let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = Constants.timeout
        configuration.httpMaximumConnectionsPerHost = Constants.httpMaximumConnectionsPerHost
        configuration.httpShouldUsePipelining = true
        
        
        let serverTrustManager = ServerTrustManager(evaluators: [secretStorage.serverTrustManagerEvaluators : DisabledTrustEvaluator()])

        return  Session(serverTrustManager: serverTrustManager)
    }()
    
// MARK: - Load
    
    func loadJSON<T: Decodable>(_ endpointName: String,
                                completion: @escaping (Result<T, Error>) -> Void) {
        Log.i("loadJSONRequest " + endpointName)
        let url = Constants.baseAPIURL.appendingPathComponent(endpointName)
        NetworkService.sessionManager.request(url)
            .responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(T.self, from: data)
                    Log.i("success " + String(describing: jsonData))
                    completion(.success(jsonData))
                } catch {
                    Log.e("failure " + error.localizedDescription)
                    completion(.failure(error))
                }
            case .failure(let error):
                Log.e("failure " + error.localizedDescription)
                if let responseCode = error.asAFError?.responseCode {
                    Log.e(" responseCode: " + String(responseCode))
                }
                completion(.failure(error))
            }
        }
    }

// MARK: - PUT
    
    func putRequestWithOAuth(_ endpointName: String,
                                   urlParameters: Parameters? = nil,
                                   additionalHeaders: HTTPHeaders? = nil,
                                   accessToken: String,
                                   completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.i("putRequest " + endpointName)
        urlParameters?.forEach({ Log.i("urlParameters key: " + $0.key + " value: " + (($0.value as? String) ?? "nil")) })

        var url = Constants.baseAPIURL.appendingPathComponent(endpointName)
        if let urlParameters = urlParameters,
           let newUrl = url.appending(urlParameters) {
            url = newUrl
        }
        Log.i("URL " + url.absoluteString)

        var headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        additionalHeaders?.forEach { headers[$0.name] = $0.value }

        NetworkService.sessionManager.request(url,
                                              method: .put,
                                              headers: headers)
        .validate(statusCode: 200..<300)
        .response { response in
            switch response.result {
            case .success:
                Log.i("success")
                completion(.success(response.data))
            case .failure(let error):
                if let responseCode = error.asAFError?.responseCode {
                    Log.e(" responseCode: " + String(responseCode))
                    if responseCode == 401 {
                        Log.e("401 Unauthorized")
                    }
                }
                completion(.failure(error))
            }
        }
    }
    
    func putRequestWithOAuth<P: Encodable, R: Decodable>(_ endpointName: String,
                                                          parameters: P? = nil,
                                                          urlParameters: Parameters? = nil,
                                                          additionalHeaders: HTTPHeaders? = nil,
                                                          accessToken: String,
                                                          encoder: ParameterEncoder = JSONParameterEncoder.default,
                                                          completion: @escaping (Result<R, Error>) -> Void) {
        Log.i("putRequest " + endpointName)
        urlParameters?.forEach({ Log.i("urlParameters key: " + $0.key + " value: " + (($0.value as? String) ?? "nil")) })
        Log.i("parameters " + String(describing: parameters))
        
        var url = Constants.baseAPIURL.appendingPathComponent(endpointName)
        if let urlParameters = urlParameters,
           let newUrl = url.appending(urlParameters) {
            url = newUrl
        }
        Log.i("URL " + url.absoluteString)

        // Создание заголовка для OAuth 2.0 аутентификации
        var headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        // Добавление дополнительных заголовков
        additionalHeaders?.forEach { headers[$0.name] = $0.value }

        // Отправка запроса
        NetworkService.sessionManager.request(url,
                                              method: .put,
                                              parameters: parameters,
                                              encoder: encoder,
                                              headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: R.self) { response in
            switch response.result {
            case .success(let reply):
                Log.i("success " + String(describing: reply))
                completion(.success(reply))
            case .failure(let error):
                Log.e("failure " + error.localizedDescription)
                completion(.failure(error))
            }
        }
    }

    
// MARK: - POST
    
    func postTextRequest<R: Decodable>(_ endpointName: String,
                                       bodyText: String,
                                       urlParameters: Parameters? = nil,
                                       headers: HTTPHeaders? = nil,
                                       completion: @escaping (Result<R, Error>) -> Void) {
        Log.i("postTextRequest " + endpointName)
        urlParameters?.forEach { Log.i("urlParameters key: " + $0.key + " value: " + (($0.value as? String) ?? "nil")) }
        Log.i("bodyText " + bodyText)
        
        var url = Constants.baseAPIURL.appendingPathComponent(endpointName)
        if let urlParameters = urlParameters,
           let newUrl = url.appending(urlParameters) {
            url = newUrl
        }
        Log.i("URL " + url.absoluteString)
        headers?.forEach { Log.i("headers name: " + $0.name + " value: " + $0.value) }
        
        let requestHeaders: HTTPHeaders = {
            var headers = headers ?? HTTPHeaders()
            headers.add(.contentType("text/plain"))
            return headers
        }()
        
        NetworkService.sessionManager.request(url,
                                              method: .post,
                                              parameters: nil,
                                              encoding: URLEncoding.default,
                                              headers: requestHeaders)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: R.self) { response in
                switch response.result {
                case .success(let reply):
                    Log.i("success " + String(describing: reply))
                    completion(.success(reply))
                case .failure(let error):
                    Log.e("failure " + error.localizedDescription)
                    if let responseCode = error.asAFError?.responseCode {
                        Log.e("responseCode: " + String(responseCode))
                    }
                    completion(.failure(error))
                }
            }
    }

    func postTextRequest(_ endpointName: String,
                         bodyText: String,
                         urlParameters: Parameters? = nil,
                         headers: HTTPHeaders? = nil,
                         completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.i("postTextRequest " + endpointName)
        urlParameters?.forEach { Log.i("urlParameters key: " + $0.key + " value: " + (($0.value as? String) ?? "nil")) }
        Log.i("bodyText " + bodyText)
        
        var url = Constants.baseAPIURL.appendingPathComponent(endpointName)
        if let urlParameters = urlParameters,
           let newUrl = url.appending(urlParameters) {
            url = newUrl
        }
        Log.i("URL " + url.absoluteString)
        headers?.forEach { Log.i("headers name: " + $0.name + " value: " + $0.value) }
        
        let requestHeaders: HTTPHeaders = {
            var headers = headers ?? HTTPHeaders()
            headers.add(.contentType("text/plain"))
            return headers
        }()
        
        // Создание URLRequest для отправки текстовых данных в теле
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.headers = requestHeaders
        urlRequest.httpBody = bodyText.data(using: .utf8)
        
        NetworkService.sessionManager.request(urlRequest)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    Log.i("success")
                    completion(.success(response.data))
                case .failure(let error):
                    Log.e("failure " + error.localizedDescription)
                    if let responseCode = error.asAFError?.responseCode {
                        Log.e("responseCode: " + String(responseCode))
                    }
                    completion(.failure(error))
                }
            }
    }
    
    func postRequest<P: Encodable, R: Decodable>(_ endpointName: String,
                                                 parameters: P,
                                                 urlParameters: Parameters? = nil,
                                                 headers: HTTPHeaders? = nil,
                                                 encoder: ParameterEncoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(boolEncoding: .literal)),
                                                 completion: @escaping (Result<R, Error>) -> Void) {
        Log.i("postRequest " + endpointName)
        urlParameters?.forEach({ Log.i("urlParameters key: " + $0.key + " value: " + (($0.value as? String) ?? "nil")) })
        Log.i("parameters " + String(describing: parameters))
        var url = Constants.baseAPIURL.appendingPathComponent(endpointName)
        if let urlParameters = urlParameters,
           let newUrl = url.appending(urlParameters) {
            url = newUrl
        }
        Log.i("URL " + url.absoluteString)
        headers?.forEach({ Log.i("headers name: " + $0.name + " value: " + $0.value) })
        NetworkService.sessionManager.request(url,
                                              method: .post,
                                              parameters: parameters,
                                              encoder: encoder,
                                              headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: R.self) { response in
            switch response.result {
            case .success(let reply):
                Log.i("success " + String(describing: reply))
                completion(.success(reply))
            case .failure(let error):
                Log.e("failure " + error.localizedDescription)
                if let responseCode = error.asAFError?.responseCode {
                    Log.e(" responseCode: " + String(responseCode))
                }
                completion(.failure(error))
            }
        }
    }
    
    
    func postRequest<P: Encodable>(_ endpointName: String,
                                   parameters: P,
                                   urlParameters: Parameters? = nil,
                                   headers: HTTPHeaders? = nil,
                                   encoder: ParameterEncoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(boolEncoding: .literal)),
                                   completion: @escaping (Result<Data, Error>) -> Void) {
        Log.i("postRequest " + endpointName)
        urlParameters?.forEach({ Log.i("urlParameters key: " + $0.key + " value: " + (($0.value as? String) ?? "nil")) })

        Log.i("parameters " + String(describing: parameters))
        
        var url = Constants.baseAPIURL.appendingPathComponent(endpointName)
        if let urlParameters = urlParameters,
           let newUrl = url.appending(urlParameters) {
            url = newUrl
        }
        Log.i("URL " + url.absoluteString)
        headers?.forEach({ Log.i("headers name: " + $0.name + " value: " + $0.value) })
        NetworkService.sessionManager.request(url,
                                              method: .post,
                                              parameters: parameters,
                                              encoder: encoder,
                                              headers: headers).responseData { response in
            switch response.result {
            case .success(let reply):
                Log.i("success + data")
                completion(.success(reply))
            case .failure(let error):
                Log.e("failure " + error.localizedDescription)
                if let responseCode = error.asAFError?.responseCode {
                    Log.e(" responseCode: " + String(responseCode))
                }
                completion(.failure(error))
            }
        }
    }
    
    func postRequestWithBasicAuth<P: Encodable, R: Decodable>(_ endpointName: String,
                                                              parameters: P,
                                                              urlParameters: Parameters? = nil,
                                                              additionalHeaders: HTTPHeaders? = nil,
                                                              username: String,
                                                              password: String,
                                                              encoder: ParameterEncoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(boolEncoding: .literal)),
                                                              completion: @escaping (Result<R, Error>) -> Void) {
        Log.i("postRequest " + endpointName)
        urlParameters?.forEach({ Log.i("urlParameters key: " + $0.key + " value: " + (($0.value as? String) ?? "nil")) })
        Log.i("parameters " + String(describing: parameters))
        var url = Constants.baseAPIURL.appendingPathComponent(endpointName)
        if let urlParameters = urlParameters,
           let newUrl = url.appending(urlParameters) {
            url = newUrl
        }
        Log.i("URL " + url.absoluteString)
        // Создание заголовка для базовой аутентификации
        let credentialData = "\(username):\(password)".data(using: .utf8)
        let base64Credentials = credentialData?.base64EncodedString() ?? ""
        // Создание и настройка HTTP заголовков
        var headers: HTTPHeaders = [
            "Authorization": "Basic \(base64Credentials)"
        ]
        // Добавление дополнительных заголовков
        additionalHeaders?.forEach { headers[$0.name] = $0.value }
        // Отправка запроса
        NetworkService.sessionManager.request(url,
                                              method: .post,
                                              parameters: parameters,
                                              encoder: encoder,
                                              headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: R.self) { response in
            switch response.result {
            case .success(let reply):
                Log.i("success " + String(describing: reply))
                completion(.success(reply))
            case .failure(let error):
                Log.e("failure " + error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func prettyPrintedJSONString(from jsonString: String) -> String? {
        guard let data = jsonString.data(using: .utf8) else { return nil }

        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            return String(decoding: prettyData, as: UTF8.self)
        } catch {
            print("Error while formatting JSON: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    
    func postRequestWithOAuth<P: Encodable, R: Decodable>(_ endpointName: String,
                                                          parameters: P? = nil,
                                                          urlParameters: Parameters? = nil,
                                                          additionalHeaders: HTTPHeaders? = nil,
                                                          accessToken: String,
                                                          encoder: ParameterEncoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(boolEncoding: .literal)),
                                                          completion: @escaping (Result<R, Error>) -> Void) {
        Log.i("postRequest " + endpointName)
        urlParameters?.forEach({ Log.i("urlParameters key: " + $0.key + " value: " + (($0.value as? String) ?? "nil")) })
        Log.i("parameters " + String(describing: parameters))
        
        var url = Constants.baseAPIURL.appendingPathComponent(endpointName)
        if let urlParameters = urlParameters,
           let newUrl = url.appending(urlParameters) {
            url = newUrl
        }
        Log.i("URL " + url.absoluteString)
        // Создание заголовка для OAuth 2.0 аутентификации
        var headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        // Добавление дополнительных заголовков
        additionalHeaders?.forEach { headers[$0.name] = $0.value }
        // Отправка запроса
        NetworkService.sessionManager.request(url,
                                              method: .post,
                                              parameters: parameters,
                                              encoder: encoder,
                                              headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: R.self) { [weak self] response in
            if let data = response.data {
                let str = String(decoding: data, as: UTF8.self)
                print(str)
            }
            
            if let body = response.request?.httpBody {
                let str = String(decoding: body, as: UTF8.self)
                print(str)
                if let formattedJSON = self?.prettyPrintedJSONString(from: str) {
                     print(formattedJSON)
                 }
            }
            switch response.result {
            case .success(let reply):
                Log.i("success " + String(describing: reply))
                completion(.success(reply))
            case .failure(let error):
                Log.e("failure " + error.localizedDescription)
                completion(.failure(error))
            }
        }
    }

    func postRequestWithOAuth<P: Encodable>(_ endpointName: String,
                                                          parameters: P,
                                                          urlParameters: Parameters? = nil,
                                                          additionalHeaders: HTTPHeaders? = nil,
                                                          accessToken: String,
                                                          encoder: ParameterEncoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(boolEncoding: .literal)),
                                                          completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.i("postRequest " + endpointName)
        urlParameters?.forEach({ Log.i("urlParameters key: " + $0.key + " value: " + (($0.value as? String) ?? "nil")) })
        Log.i("parameters " + String(describing: parameters))
        
        var url = Constants.baseAPIURL.appendingPathComponent(endpointName)
        if let urlParameters = urlParameters,
           let newUrl = url.appending(urlParameters) {
            url = newUrl
        }
        Log.i("URL " + url.absoluteString)
        // Создание заголовка для OAuth 2.0 аутентификации
        var headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        // Добавление дополнительных заголовков
        additionalHeaders?.forEach { headers[$0.name] = $0.value }
        // Отправка запроса
        NetworkService.sessionManager.request(url,
                                              method: .post,
                                              parameters: parameters,
                                              encoder: encoder,
                                              headers: headers)
        .validate(statusCode: 200..<300)
        .response { response in
            switch response.result {
            case .success(let reply):
                Log.i("success " + String(describing: reply))
                completion(.success(reply))
            case .failure(let error):
                Log.e("failure " + error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
// MARK: - GET
    
    func getRequest<P: Encodable, T: Decodable>(_ endpointName: String,
                                                parameters: P,
                                                encoder: ParameterEncoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(boolEncoding: .literal)),
                                                completion: @escaping (Result<T, Error>) -> Void) {
        Log.i("URL " + Constants.baseAPIURL.appendingPathComponent(endpointName).absoluteString)
        Log.i("parameters " + String(describing: parameters))
        
        NetworkService.sessionManager.request(Constants.baseAPIURL.appendingPathComponent(endpointName),
                                              parameters: parameters,
                                              encoder: encoder).validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case let .success(reply):
                    Log.i("success " + String(describing: reply))
                    completion(.success(reply))
                case .failure(let error):
                    Log.e("failure " + error.localizedDescription)
                    if let responseCode = error.asAFError?.responseCode {
                        Log.e(" responseCode: " + String(responseCode))
                    }
                    completion(.failure(error))
                }
            }
    }
    
    func getRequest<R: Decodable>(_ endpointName: String,
                                  urlParameters: Parameters? = nil,
                                  additionalHeaders: HTTPHeaders? = nil,
                                  completion: @escaping (Result<R, Error>) -> Void) {

        Log.i("getRequest " + endpointName)
        urlParameters?.forEach({ Log.i("urlParameters key: " + $0.key + " value: " + (($0.value as? String) ?? "nil")) })
        
        let url = Constants.baseAPIURL.appendingPathComponent(endpointName)
        if let urlParameters = urlParameters,
           let newUrl = url.appending(urlParameters) {
            Log.i("URL " + newUrl.absoluteString)
        }
        Log.i("URL " + url.absoluteString)

        // Создание заголовка для OAuth 2.0 аутентификации
        var headers: HTTPHeaders = []

        // Добавление дополнительных заголовков
        additionalHeaders?.forEach { headers[$0.name] = $0.value }

        // Отправка GET запроса
        NetworkService.sessionManager.request(url,
                                              method: .get,
                                              parameters: urlParameters,
                                              headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: R.self) { response in
            if let data = response.data {
                let str = String(decoding: data, as: UTF8.self)
                print(str)
            }
            switch response.result {
            case .success(let reply):
                Log.i("success " + String(describing: reply))
                completion(.success(reply))
            case .failure(let error):
                Log.e("failure " + error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    
    func getRequest<P: Encodable>(_ endpointName: String,
                                  parameters: P,
                                  encoder: ParameterEncoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(boolEncoding: .literal)),
                                  completion: @escaping (Result<Data, Error>) -> Void) {
        
        Log.i("URL " + Constants.baseAPIURL.appendingPathComponent(endpointName).absoluteString)
        Log.i("parameters " + String(describing: parameters))
        
        NetworkService.sessionManager.request(Constants.baseAPIURL.appendingPathComponent(endpointName),
                                              parameters: parameters,
                                              encoder: encoder).validate(statusCode: 200..<300).responseData { response in
            switch response.result {
            case .success(let reply):
                Log.i("success + data")
                completion(.success(reply))
            case .failure(let error):
                Log.e("failure " + error.localizedDescription)
                if let responseCode = error.asAFError?.responseCode {
                    Log.e(" responseCode: " + String(responseCode))
                }
                completion(.failure(error))
            }
        }
    }
    
    func getRequest<P: Encodable>(fullPath: URL,
                                  parameters: P,
                                  encoder: ParameterEncoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(boolEncoding: .literal)),
                                  completion: @escaping (Result<Data, Error>) -> Void) {
        Log.i("URL " + fullPath.absoluteString)
        Log.i("parameters " + String(describing: parameters))
        
        NetworkService.sessionManager.request(fullPath,
                                              parameters: parameters,
                                              encoder: encoder).validate(statusCode: 200..<300).responseData { response in
            switch response.result {
            case .success(let reply):
                Log.i("success + data")
                completion(.success(reply))
            case .failure(let error):
                Log.e("failure " + error.localizedDescription)
                if let responseCode = error.asAFError?.responseCode {
                    Log.e(" responseCode: " + String(responseCode))
                }
                completion(.failure(error))
            }
        }
    }
    
    func getRequestWithOAuth<P: Encodable, R: Decodable>(_ endpointName: String,
                                                         parameters: P,
                                           additionalHeaders: HTTPHeaders? = nil,
                                           accessToken: String,
                                                         encoder: ParameterEncoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(boolEncoding: .literal)),
                                           completion: @escaping (Result<R, Error>) -> Void) {

        Log.i("getRequest " + endpointName)
        
        let url = Constants.baseAPIURL.appendingPathComponent(endpointName)
        Log.i("URL " + url.absoluteString)

        // Создание заголовка для OAuth 2.0 аутентификации
        var headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Accept": "application/json"
        ]

        // Добавление дополнительных заголовков
        additionalHeaders?.forEach { headers[$0.name] = $0.value }

        // Отправка GET запроса
        NetworkService.sessionManager.request(url,
                                              method: .get,
                                              parameters: parameters,
                                              encoder: encoder,
                                              headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: R.self) { response in
            if let data = response.data {
                let str = String(decoding: data, as: UTF8.self)
                print(str)
            }
            switch response.result {
            case .success(let reply):
                Log.i("success " + String(describing: reply))
                completion(.success(reply))
            case .failure(let error):
                Log.e("failure " + error.localizedDescription)
                if let responseCode = error.asAFError?.responseCode {
                    Log.e(" responseCode: " + String(responseCode))
                    if responseCode == 401 {
                        Log.e("401 Unauthorized")
//                        NotificationCenter.default.post(name: .tokenRefused, object: nil)
                    }
                }
                completion(.failure(error))
            }
        }
    }
    
    
    
    
    
    func getRequestWithOAuth<R: Decodable>(_ endpointName: String,
                                           urlParameters: Parameters? = nil,
                                           additionalHeaders: HTTPHeaders? = nil,
                                           accessToken: String,
                                           completion: @escaping (Result<R, Error>) -> Void) {

        Log.i("getRequest " + endpointName)
        urlParameters?.forEach({ Log.i("urlParameters key: " + $0.key + " value: " + (($0.value as? String) ?? "nil")) })
        
        let url = Constants.baseAPIURL.appendingPathComponent(endpointName)
        if let urlParameters = urlParameters,
           let newUrl = url.appending(urlParameters) {
            Log.i("URL " + newUrl.absoluteString)
        }
        Log.i("URL " + url.absoluteString)

        // Создание заголовка для OAuth 2.0 аутентификации
        var headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Accept": "application/json"
        ]

        // Добавление дополнительных заголовков
        additionalHeaders?.forEach { headers[$0.name] = $0.value }

        // Отправка GET запроса
        NetworkService.sessionManager.request(url,
                                              method: .get,
                                              parameters: urlParameters,
                                              headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: R.self) { response in
            if let data = response.data {
                let str = String(decoding: data, as: UTF8.self)
                print(str)
            }
            switch response.result {
            case .success(let reply):
                Log.i("success " + String(describing: reply))
                completion(.success(reply))
            case .failure(let error):
                Log.e("failure " + error.localizedDescription)
                if let responseCode = error.asAFError?.responseCode {
                    Log.e(" responseCode: " + String(responseCode))
                    if responseCode == 401 {
                        Log.e("401 Unauthorized")
//                        NotificationCenter.default.post(name: .tokenRefused, object: nil)
                    }
                }
                completion(.failure(error))
            }
        }
    }
    
    func getRequestWithOAuth<R: Decodable>(_ endpointName: String,
                                           urlParameters: Parameters? = nil,
                                           additionalHeaders: HTTPHeaders? = nil,
                                           accessToken: String,
                                           completion: @escaping (Result<R?, Error>) -> Void) {

        Log.i("getRequest " + endpointName)
        urlParameters?.forEach({ Log.i("urlParameters key: " + $0.key + " value: " + (($0.value as? String) ?? "nil")) })
        
        let url = Constants.baseAPIURL.appendingPathComponent(endpointName)
        if let urlParameters = urlParameters,
           let newUrl = url.appending(urlParameters) {
            Log.i("URL " + newUrl.absoluteString)
        }
        Log.i("URL " + url.absoluteString)

        // Создание заголовка для OAuth 2.0 аутентификации
        var headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Accept": "application/json"
        ]

        // Добавление дополнительных заголовков
        additionalHeaders?.forEach { headers[$0.name] = $0.value }

        // Отправка GET запроса
        NetworkService.sessionManager.request(url,
                                              method: .get,
                                              parameters: urlParameters,
                                              headers: headers)
        .validate(statusCode: 200..<300)
        .responseData { response in
            guard let data = response.data, !data.isEmpty else {
                 Log.i("Received empty response")
                 completion(.success(nil)) // Возвращаем nil, если данные пусты
                 return
             }
            
            switch response.result {
            case .success(let data):
                    // Попытка декодировать данные, если они есть
                    do {
                        let decodedData = try JSONDecoder().decode(R.self, from: data)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(error))
                    }
            case .failure(let error):
                Log.e("failure " + error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func getRequestWithOAuth(_ endpointName: String,
                                           urlParameters: Parameters? = nil,
                                           additionalHeaders: HTTPHeaders? = nil,
                                           accessToken: String,
                                           completion: @escaping (Result<Data?, Error>) -> Void) {

        Log.i("getRequest " + endpointName)
        urlParameters?.forEach({ Log.i("urlParameters key: " + $0.key + " value: " + (($0.value as? String) ?? "nil")) })
        
        var url = Constants.baseAPIURL.appendingPathComponent(endpointName)
        if let urlParameters = urlParameters,
           let newUrl = url.appending(urlParameters) {
            url = newUrl
        }
        Log.i("URL " + url.absoluteString)

        // Создание заголовка для OAuth 2.0 аутентификации
        var headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Accept": "application/json"
        ]

        // Добавление дополнительных заголовков
        additionalHeaders?.forEach { headers[$0.name] = $0.value }

        // Отправка GET запроса
        NetworkService.sessionManager.request(url,
                                              method: .get,
                                              parameters: urlParameters,
                                              headers: headers)
        .validate(statusCode: 200..<300)
        .responseData { response in
            if let data = response.data {
                let str = String(decoding: data, as: UTF8.self)
                print(str)
            }
            switch response.result {
            case .success(let reply):
                Log.i("success " + String(describing: reply))
                completion(.success(reply))
            case .failure(let error):
                Log.e("failure " + error.localizedDescription)
                completion(.failure(error))
            }
        }
    }

    func getRequestWithOAuth<P: Encodable>(_ endpointName: String,
                                           parameters: P,
                                           additionalHeaders: HTTPHeaders? = nil,
                                           accessToken: String,
                                           completion: @escaping (Result<Data?, Error>) -> Void) {

        Log.i("getRequest " + endpointName)
        let url = Constants.baseAPIURL.appendingPathComponent(endpointName)
        Log.i("URL " + url.absoluteString)
        var body = String()

        let dataDictionary = ["data": parameters]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dataDictionary, options: [])
            var jsonString = String(data: jsonData, encoding: .utf8) ?? ""

            // Выводим для проверки
            jsonString = jsonString.replacingOccurrences(of: "\\u005C", with: "")
            print(jsonString)

            body = jsonString

        } catch {
            print("Ошибка сериализации: \(error)")
        }

        // Создание заголовка для OAuth 2.0 аутентификации
        var headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            secretStorage.keyFromApiRequest: body
        ]
    
        Log.i("parameters " + String(describing: parameters))
        additionalHeaders?.forEach { headers[$0.name] = $0.value }

        // Отправка GET запроса
        NetworkService.sessionManager.request(url,
                                              method: .get,
//                                              parameters: parameters,
                                              headers: headers)
        .validate(statusCode: 200..<300)
        .responseData { response in
            switch response.result {
            case .success(let reply):
                Log.i("success + data")
                completion(.success(reply))
            case .failure(let error):
                Log.e("failure " + error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func getRequestWithOAuth(_ endpointName: String,
                             additionalHeaders: HTTPHeaders? = nil,
                             accessToken: String,
                             completion: @escaping (Result<Data?, Error>) -> Void) {

        Log.i("getRequest " + endpointName)
        let url = Constants.baseAPIURL.appendingPathComponent(endpointName)
        Log.i("URL " + url.absoluteString)

        // Создание заголовка для OAuth 2.0 аутентификации
        var headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
        ]

        additionalHeaders?.forEach { headers[$0.name] = $0.value }
        // Отправка GET запроса
        NetworkService.sessionManager.request(url,
                                              method: .get,
                                              headers: headers)
        .validate(statusCode: 200..<300)
        .responseData { response in
            switch response.result {
            case .success(let reply):
                Log.i("success + data")
                completion(.success(reply))
            case .failure(let error):
                Log.e("failure " + error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func printPrettyJSON<T: Encodable>(_ parameters: T, encoder: ParameterEncoder, endpointName: String, urlParameters: Parameters?) {
        do {
            var requestURL = Constants.baseAPIURL.appendingPathComponent(endpointName)
            if let urlParameters = urlParameters,
               let newUrl = requestURL.appending(urlParameters) {
                requestURL = newUrl
            }
            Log.i("URL " + requestURL.absoluteString)
            var urlRequest = URLRequest(url: requestURL)
            try urlRequest = encoder.encode(parameters, into: urlRequest)
             if let jsonData = urlRequest.httpBody,
                let prettyPrintedString = String(data: jsonData, encoding: .utf8) {
                 print(prettyPrintedString)
             } else {
                 print("Ошибка при преобразовании JSON в строку")
             }
         } catch {
             print("Ошибка при кодировании параметров в JSON: \(error.localizedDescription)")
         }
    }
}


extension URL {
    func appending(_ parameters: Parameters) -> URL? {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        
        parameters.forEach {
            let queryItem = URLQueryItem(name: $0.key, value: "\($0.value)")
            queryItems.append(queryItem)
        }
        
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
}

class DisabledTrustEvaluator: ServerTrustEvaluating {
    func evaluate(_ trust: SecTrust, forHost host: String) throws {
        // Здесь пустая реализация для пропуска проверки сертификатов
    }
}
