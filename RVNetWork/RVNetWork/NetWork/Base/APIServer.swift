//
//  APIServer.swift
//  RVNetWork
//
//  Created by 金劲通 on 2021/8/9.
//

import UIKit
import Moya

#if DEBUG
public let APIServer = MoyaProvider<APIManager>(plugins:[NetworkLoggerPlugin(verbose: true)])
#else
public let APIServer = MoyaProvider<APIManager>()
#endif

public enum APIManager {
    case loadConfig(APIConfig)
    case uploadConfig(APIUploadConfig)
}

extension APIManager : TargetType {
    public var baseURL: URL {
        switch self {
        case .loadConfig(let config):
            return config.APIBaseURL()
        case .uploadConfig(let config):
             return config.APIBaseURL()
    }
}
    public var path: String {
        switch self {
        case .loadConfig(let config):
            return config.requestPath
        case .uploadConfig(let config):
            return config.requestPath
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .loadConfig(let config):
            switch config.requestMethd {
            case .post:
                return .post
            default:
                return .get
            }
        case .uploadConfig(_):
            return .post
        }
    }
    
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
        case .loadConfig(let config):
            if let params = config.requestParams {
                if config.requestEncodingType == .URL {
                    return .requestParameters(parameters: params, encoding: URLEncoding.default)
                }
                return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            }
        case .uploadConfig(let config):
            return uploadTask(config: config)
        }
        return .requestPlain
    }
    
    public var headers: [String : String]? {
        switch self {
        case .loadConfig(let config):
            return config.requestHeaders
        case .uploadConfig(let config):
            return config.requestHeaders
        }
    }
}

extension APIManager {
    func uploadTask(config: APIUploadConfig) -> Task {
        var formDataContainer = [MultipartFormData]()
        // 参数
        if let params = config.requestParams as? [String : String] {
            for (k, v) in params {
                if let strData = v.data(using: .utf8) {
                    let formData = MultipartFormData(provider: .data(strData), name: k)
                    formDataContainer.append(formData)
                }
            }
        }
        // 数据
        if let datas = config.datas {
            for data in datas {
                let formData = MultipartFormData(provider: .data(data.uploadData), name: data.dataName, fileName: data.fileName, mimeType: data.mineType)
                formDataContainer.append(formData)
            }
        }
        // 文件
        if let files = config.files {
            for file in files {
                let formData = MultipartFormData(provider: .file(file.uploadFile), name: file.dataName, fileName: file.fileName, mimeType: file.mineType)
                formDataContainer.append(formData)
            }
        }
        // 提价
        return .uploadMultipart(formDataContainer)
        
    }
}
