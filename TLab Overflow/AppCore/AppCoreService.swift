//
//  AppCoreService.swift
//  TLab Overflow
//
//  Created by Rifat Firdaus on 11/18/16.
//  Copyright © 2016 Suitmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

open class AppCoreService: NSObject {
    public static let instance = AppCoreService()
    public var manager = BaseSessionManager()
    public var home = ""
    
    public func setup(home: String) {
        self.home = home
    }
    
    func getSeacrhResultItems(params: [String : String], page: Int = 1, callback: @escaping (APIResult<Pagination<[SearchItem]>>) -> (Void)) {
        var parameters: [String: AnyObject] = [:]
        for (key, value) in params {
            parameters[key] = value as AnyObject?
        }
        parameters["page"] = page as AnyObject?
        let request = manager.request(home + "search", method: .get, parameters: parameters)
        request.responseJSON { response in
            switch response.result {
            case let .success(value):
                let json = JSON(value)
                let resultJson = json["items"]
                let total = json["total"].intValue
                let currentPage = json["page"].intValue
                let hasMore = json["has_more"].boolValue

                if resultJson.arrayValue.count > 0 {
                    var items = [SearchItem]()
                    for itemJson in resultJson.arrayValue {
                        if let item = SearchItem.with(json: itemJson) {
                            items.append(item)
                        }
                    }
                    let pagination = Pagination<[SearchItem]>(total: total, currentPage: currentPage, hasMore: hasMore, data: items)
                    callback(.success(pagination))
                } else {
                    let error = NSError(domain: "The Search Result DB", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data doesn't exists."])
                    print(error.localizedDescription)
                    callback(.failure(error))
                }
            case let .failure(error):
                print(error.localizedDescription)
                callback(.failure(error as NSError))
            }
        }
    }
}

open class BaseSessionManager: SessionManager {
    
    convenience init() {
        let configuration = URLSessionConfiguration.default
        self.init(configuration:configuration)
    }
    
    override open func request(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil) -> DataRequest {
        var overidedParameters = [String: AnyObject]()
        overidedParameters["filter"] = ApiConfig.filter as AnyObject
        if let parameters = parameters {
            for (key, value) in parameters {
                overidedParameters[key] = value as AnyObject?
            }
        }
        do {
            let urlRequest = URLRequest(url: try url.asURL())
            let request = try! encoding.encode(urlRequest, with: overidedParameters)
            print("[\(method.rawValue)] \(request)")
        } catch {
            print("Error URL Request")
        }
        return super.request(url, method: method, parameters: overidedParameters, encoding: encoding, headers: headers)
    }
}

public struct Pagination<T> {
    public let total: Int
    public let currentPage: Int
    public let hasMore: Bool
    public let data: T
    
    public init(total: Int, currentPage: Int, hasMore: Bool, data: T) {
        self.total = total
        self.currentPage = currentPage
        self.hasMore = hasMore
        self.data = data
    }
}

public enum APIResult<T> {
    case success(T)
    case failure(NSError)
}
