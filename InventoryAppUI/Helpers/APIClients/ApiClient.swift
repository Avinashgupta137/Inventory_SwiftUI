//
//  ApiClient.swift
//   PB TV OTT
//
//  Created by Avinash on 17/11/24.
//

import Foundation
import Alamofire

class ApiClient: NSObject {
    
    static var shared = ApiClient()
    private var ongoingRequests: [DataRequest] = []
    
    private override init() {}
    
    private func addRequest(_ request: DataRequest) {
        ongoingRequests.append(request)
    }
    
    private func removeRequest(_ request: DataRequest) {
        if let index = ongoingRequests.firstIndex(of: request) {
            ongoingRequests.remove(at: index)
        }
    }
    
    
    func cancelAllRequests() {
        for request in ongoingRequests {
            request.cancel()
        }
        ongoingRequests.removeAll()
    }
    
    func callHttpMethod<T: Decodable>(
        apiendpoint: String,
        method: ApiMethod,
        param: [String: Any],
        model: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        var apiMethod: HTTPMethod = .get
        var urlEncoding: ParameterEncoding = URLEncoding.queryString
        let header = setHeader()
        switch method {
        case .delete:
            return
        case .put:
            apiMethod = .put
        case .post:
            apiMethod = .post
        case .get:
            apiMethod = .get
        }
        
        if apiMethod == .post {
            urlEncoding = JSONEncoding.default
        } else {
            urlEncoding = URLEncoding.queryString
        }
        
        let fullUrl = (Constant.BASEURL + apiendpoint).trimmingCharacters(in: .whitespacesAndNewlines)
        print("Api:--", fullUrl)
        print("Param:--", param)
        print("Method:--", apiMethod.rawValue)
        print("Header Request:--\n", header ,"\n --------------")
        
        let request = AF.request(fullUrl, method: apiMethod, parameters: param, encoding: urlEncoding, headers: header)
        self.addRequest(request)
        
        request.response { response in
            self.removeRequest(request)
            print("Response:--", response.response?.statusCode ?? 00)
            
            switch response.result {
            case .success(let data):
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                        if let jsonString = String(data: jsonData, encoding: .utf8) {
                            print("\(apiendpoint) Pretty-printed JSON response:")
                            print(jsonString)
                        }
                      
                    } else {
                        print("Invalid JSON format")
                    }
                    let decodedResponse = try JSONDecoder().decode(model, from: data!)
                    completion(.success(decodedResponse))
                } catch {
                    print("JSON Serialization error: \(error as NSError)")
                    completion(.failure(error))
                }
            case .failure(let error):
                if let afError = error.asAFError, afError.isExplicitlyCancelledError {
                    print("Request cancelled: \(error.localizedDescription)")
                    
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    
    func callmethodMultipart<T: Decodable>(
        apiendpoint: String,
        method: ApiMethod,
        param: [String: Any],
        model: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ){
        var apiMethod: HTTPMethod = .get
        var urlEncoding: ParameterEncoding = URLEncoding.queryString
        let header = setHeader()
        switch method {
        case .delete:
            return
        case .put:
            apiMethod = .put
        case .post:
            apiMethod = .post
        case .get:
            apiMethod = .get
        }
        
        if apiMethod == .post {
            urlEncoding = JSONEncoding.default
        } else {
            urlEncoding = URLEncoding.queryString
        }
        
        let fullUrl = (Constant.BASEURL + apiendpoint).trimmingCharacters(in: .whitespacesAndNewlines)
        print("Api:--", fullUrl)
        print("Param:--", param)
        print("Method:--", apiMethod.rawValue)
        print("Header Request:--\n", header ,"\n --------------")

        AF.upload(multipartFormData: createBodyWithParameters(parameters: param),to: fullUrl,headers: HTTPHeaders(APIManager.setHeader()))
            .uploadProgress  { progress in
                      print("Upload Progress: \(progress.fractionCompleted)")
                  }
            .response { response in
           // self.removeRequest(requests)
            print("Response:--", response.response?.statusCode ?? 00)
            
            switch response.result {
            case .success(let data):
               
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                        if let jsonString = String(data: jsonData, encoding: .utf8) {
                            print("\(apiendpoint) Pretty-printed JSON response:")
                            print(jsonString)
                        }
                      
                    } else {
                        print("Invalid JSON format")
                    }
                    let decodedResponse = try JSONDecoder().decode(model, from: data!)
                    completion(.success(decodedResponse))
                } catch {
                    print("JSON Serialization error: \(error as NSError)")
                    completion(.failure(error))
                }
            case .failure(let error):
                if let afError = error.asAFError, afError.isExplicitlyCancelledError {
                    print("Request cancelled: \(error.localizedDescription)")
                    
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    
    
     func setHeader() -> HTTPHeaders {
           var headers: HTTPHeaders = [

               
           ]
           
           return headers
       }
    
    
    func createBodyWithParameters(parameters: [String: Any], fileURL: URL? = nil, filename: String? = nil) -> MultipartFormData {
        var body = Data()
        var multipartData = MultipartFormData()
        for (key, value) in parameters {
            if value is NSArray {
                let str = APIManager.json(from: (value as AnyObject))
                multipartData.append((str?.data(using: .utf8)!)!, withName: key )
            } else {
                multipartData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
            }
        }
        return multipartData
    }
}


enum ApiMethod {
    case get, post, put, delete
}

enum CustomError: Error {
    case someError
    case anotherError(String)
}
