//
//  APIConfig.swift
//  RVNetWork
//
//  Created by 金劲通 on 2021/8/9.
//

import Foundation

public enum APIEncodingType {
    case URL
    case JSON
}

public enum APIRequestMethod {
    case get
    case post
}

open class APIConfig: NSObject {
    var requestEncodingType: APIEncodingType = .URL
    var requestMethd: APIRequestMethod = .get
    var requestBaseURLString: String = ""
    var requestPath: String = ""
    var requestParams: [String : Any]?
    var requestHeaders: [String :String]?
    
    init(baseUrlString: String,method: APIRequestMethod = .get, encodingType: APIEncodingType = .URL, path: String, params: [String : Any]?) {
        super.init()
        requestBaseURLString = baseUrlString
        requestMethd = method
        requestEncodingType = encodingType
        requestPath = path
        requestParams = params
    }
    
    func APIBaseURL() -> URL {
        return URL.init(string: requestBaseURLString)!
    }
    
}
