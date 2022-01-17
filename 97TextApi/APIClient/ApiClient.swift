//
//  ApiClient.swift
//  97TextApi
//
//  Created by Vinay Gajbhiye on 17/01/22.
//

import Foundation
import UIKit


class APIClient {
    static let appId = "61e50da053af26025ad77c66"
    static var isPaginating : Bool = false
    
    
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
        static var userEmail = ""
    }
    
    enum Endpoints {
        ///Home Api
        case homeUserApi(Int)
        case createUser
      case deleteUser(String)
        
        var stringValue: String {
            switch self {
          
            case .homeUserApi(let page):
                return "https://dummyapi.io/data/v1/user?limit=10&page=\(page)"
            case .deleteUser(let id):
                return "https://dummyapi.io/data/v1/user/\(id)"
            case .createUser :
                return "https://dummyapi.io/data/v1/user/create"
                
                
                
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
 
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(appId, forHTTPHeaderField: "app-id")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
        
        return task
    }
    
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(appId, forHTTPHeaderField: "app-id")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    
    class func taskForDeleteRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(appId, forHTTPHeaderField: "app-id")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
        
        return task
    }
    
    //MARK:- Home Api
    
    
    class func homeUserApi(pagination: Bool = false ,limit:Int,completion: @escaping ([Datum], Error?) -> Void) {
        if pagination {
            isPaginating = true
        }
        taskForGETRequest(url: Endpoints.homeUserApi(limit).url, responseType: HomeModel.self) { response, error in
            if let response = response {
                print(Endpoints.homeUserApi(limit).url,"Endpoints.getLeaderBoardsUpcoming(userId, contestId).url")
                print(response)
                if pagination == true {
                    completion(response.data ?? [], nil)
                }
                else {
                    completion(response.data ?? [], nil)
                }
                if pagination {
                    isPaginating = false
                }
                
                
            } else {
                completion([], error)
                print(error)
            }
        }
    }

    
    class func deleteUser(id:String,completion: @escaping (String,Error)->Void) {
        taskForDeleteRequest(url: Endpoints.deleteUser(id).url, responseType: String.self) { response, error in
            if let response = response {
                completion(response,error!)
            }
            else {
                completion(response ?? "",error!)
            }
        }
    
    }
    
    
    class func createUser(fName:String,lName:String,Email:String,completion:@escaping (UserModel?,Error?)->Void) {
        let parameterDictionary = ["firstName" : fName, "lastName" : lName,"email":Email]
        taskForPOSTRequest(url: Endpoints.createUser.url, responseType: UserModel.self, body: parameterDictionary) { response, error in
            if let response = response {
                completion(response,nil)
                print(response,"responsee")
            }
            else {
                completion(nil, error)
                print(error,"error")
            }
        }
    }
 
    
}
