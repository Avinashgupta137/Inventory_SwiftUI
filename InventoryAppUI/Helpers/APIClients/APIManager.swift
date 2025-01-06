//
//  APIManager.swift
//  InventoryApp
//
//  Created by Sanskar IOS Dev on 31/07/24.
//

import UIKit
import Alamofire

// Type alias for response handler closure
/// <#Description#>
/// - Parameters:
///   - result: Bool
///   - response: Response as Dictionary
///   - error: error
///   - data:data
/// - Returns: Void
typealias responseHandler = (_ result: Bool, _ response: NSDictionary?, _ error: NSError?, _ data: Data?) -> Void

class APIManager: NSObject {
    
    class func getServerPath() -> String {
        let serverPath: String = Constant.BASEURL
        return serverPath
    }
    
    class func getFullPath(path: String) -> String {
        var fullPath: String!
        fullPath = APIManager.getServerPath()
        fullPath.append("/")
        fullPath.append(path)
        let escapedAddress: String = fullPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return escapedAddress
    }
    
    class func getServerPath2() -> String {
        let serverPath: String = Constant.bookingBase
        return serverPath
    }
    
    class func getFullPath2(path: String) -> String {
        var fullPath: String!
        fullPath = APIManager.getServerPath2()
        fullPath.append("/")
        fullPath.append(path)
        let escapedAddress: String = fullPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return escapedAddress
    }
    
    class func setHeader() -> [String: String] {
        var dict = [String: String]()
        // dict["device_type"] = currentUser.device_type
        return dict
    }
    
    class func json(from object: AnyObject) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    class func setRequest(dict: NSDictionary, url: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 50 // 10 secs
        let values = ["key": "value"]
        request.httpBody = try! JSONSerialization.data(withJSONObject: values, options: [])
        return request
    }
    
    class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    // POST
    class func apiCall(postData: NSDictionary, url: String, identifier: String = "", completionHandler: @escaping responseHandler) {
        let path: String = APIManager.getFullPath(path: url)
        
        print("Request URL ->  \(path)")
        print("Request parameter ->  \(postData.jsonStringRepresentation ?? "")")
        print("Request Header ->  \(APIManager.setHeader().jsonStringRepresentation ?? "")")
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in postData {
                    if value is NSArray {
                        let str = APIManager.json(from: (value as AnyObject))
                        multipartFormData.append((str?.data(using: .utf8)!)!, withName: key as! String)
                    } else {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                    }
                }
            },
            to: path,
            headers: HTTPHeaders(APIManager.setHeader())
        ).uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }.responseJSON { response in
            switch response.result {
            case .success(let value):
                if let responseDict = value as? NSDictionary {
                    print("HTTP Response Value -> \(responseDict.jsonStringRepresentation ?? "")")
                    completionHandler(true, responseDict, nil, response.data)
                } else {
                    print("HTTP Response Value -> \(value)")
                    completionHandler(true, nil, nil, response.data)
                }
            case .failure(let error):
                print(error)
                completionHandler(false, nil, error as NSError, nil)
            }
        }
    }
    
    class func apiWithoutHeader(postData: NSDictionary, url: String, identifier: String, completionHandler: @escaping responseHandler) {
        let path: String = APIManager.getFullPath2(path: url)
        
        print("Request URL ->  \(path)")
        print("Request parameter ->  \(postData.jsonStringRepresentation ?? "")")
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in postData {
                    if value is NSArray {
                        let str = APIManager.json(from: (value as AnyObject))
                        multipartFormData.append((str?.data(using: .utf8)!)!, withName: key as! String)
                    } else {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                    }
                }
            },
            to: path
        ).uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }.responseJSON { response in
            switch response.result {
            case .success(let value):
                if let responseDict = value as? NSDictionary {
                    print("HTTP Response Value -> \(responseDict.jsonStringRepresentation ?? "")")
                    completionHandler(true, responseDict, nil, response.data)
                } else {
                    print("HTTP Response Value -> \(value)")
                    completionHandler(true, nil, nil, response.data)
                }
            case .failure(let error):
                print(error)
                completionHandler(false, nil, error as NSError, nil)
            }
        }
    }
    
    class func apiCall2(postData: NSDictionary, url: String, identifier: String, completionHandler: @escaping (_ result: Bool, _ response: NSDictionary?, _ error: NSError?, _ errorMessage: String?) -> Void) {
        let path: String = APIManager.getFullPath(path: url)
        
        print(path)
        print(postData)
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in postData {
                    print(key, value)
                    if value is NSArray {
                        let str = APIManager.json(from: (value as AnyObject))
                        multipartFormData.append((str?.data(using: .utf8)!)!, withName: key as! String)
                    } else {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                    }
                }
            },
            to: path,
            headers: HTTPHeaders(APIManager.setHeader())
        ).uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }.responseString { response in
            debugPrint(response)
            if let value = response.value as? NSDictionary {
                completionHandler(true, value, nil, "response")
            } else {
                completionHandler(true, nil, nil, "response")
            }
        }
    }
    
    // MARK: MULTIPART POST
    class func apiCall1(_ postData: NSDictionary, _ url: String, _ identifier: String, completionHandler: @escaping (_ result: Bool, _ response: NSDictionary?, _ error: NSError?, _ errorMessage: String?) -> Void) {
        let path: String = APIManager.getFullPath(path: url)
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in postData {
                    print(key, value)
                    if value is NSArray {
                        let str = APIManager.json(from: (value as AnyObject))
                        multipartFormData.append((str?.data(using: .utf8)!)!, withName: key as! String)
                    } else {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                    }
                }
            },
            to: path
        ).uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }.responseJSON { response in
            debugPrint(response)
            if let value = response.value as? NSDictionary {
                completionHandler(true, value, nil, "response")
            } else {
                completionHandler(true, nil, nil, "response")
            }
        }.response { response in
            if let error = response.error {
                print(error)
                completionHandler(false, nil, error as NSError, "response")
            }
        }
    }
    

}

struct BodyStringEncoding: ParameterEncoding {
    private let body: String
    
    init(body: String) { self.body = body }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        guard var urlRequest = urlRequest.urlRequest else { throw Errors.emptyURLRequest }
        guard let data = body.data(using: .utf8) else { throw Errors.encodingProblem }
        urlRequest.httpBody = data
        return urlRequest
    }
}

extension BodyStringEncoding {
    enum Errors: Error {
        case emptyURLRequest
        case encodingProblem
    }
}

extension BodyStringEncoding.Errors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyURLRequest: return "Empty url request"
        case .encodingProblem: return "Encoding problem"
        }
    }
}

extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted]) else {
            return nil
        }
        return String(data: theJSONData, encoding: .ascii)
    }
}

extension NSDictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted]) else {
            return nil
        }
        return String(data: theJSONData, encoding: .ascii)
    }
}

extension Array {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted]) else {
            return nil
        }
        return String(data: theJSONData, encoding: .ascii)
    }
}
