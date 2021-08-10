//
//  HTTPClient.swift
//  RVNetWork
//
//  Created by 金劲通 on 2021/8/9.
//

import Foundation
import HandyJSON
import Moya
import RxSwift
import SVProgressHUD

#if DEBUG
let kBaseURLString = "http://gank.io"
#else
let kBaseURLString = "http://gank.io"
#endif

extension Array: HandyJSON {}

extension HandyJSON {
//MARK: - 普通GET/POST请求
    static func request(baseURLString: String = kBaseURLString, method: APIRequestMethod, url: String,dict: [String : Any]?, encodingtype: APIEncodingType = .URL) -> Single<APIModel<Self>> {
        let config = APIConfig.init(baseUrlString: baseURLString, method: method, encodingType: encodingtype, path: url, params: dict)
        return APIServer.rx.request(.loadConfig(config))
            .filterSuccessfulStatusCodes()
            .mapData(APIModel<Self>.self)
            .do(onSuccess:{(model) in
                print(model.error)
            }, onError:{(error) in
                print("error" + error.localizedDescription)
            })
    }
    
//MARK: - 上传文件请求
    static func upload(baseURLString: String = kBaseURLString,url: String,dict:[String: Any]?, datas:[APIUploadData]? = nil,files:[APIUploadFile]? = nil) -> Single<APIModel<Self>> {
        let config = APIUploadConfig.init(baseUrlString: kBaseURLString, path: url, params: dict)
        config.datas = datas
        config.files = files
        return APIServer.rx.request(.uploadConfig(config))
            .filterSuccessfulStatusCodes()
            .mapData(APIModel<Self>.self)
            .do(onSuccess:{(model) in
                print(model.error)
            }, onError: {(error) in
                print("errore" + error.localizedDescription)
            })
    }
}

extension HandyJSON {
    //接口请求成功 处理报错
    static func dealWithSuccError(model:APIModel<Self>) {
        if !model.error {
            SVProgressHUD.showError(withStatus: "请求出错")
        }
    }
}

extension MoyaError {
    func errorMessage() -> String {
        switch self {
        case .imageMapping, .jsonMapping, .stringMapping:
            return "数据解析出错"
        case .statusCode(let response):
        return "状态码无效\n状态码:\(response.statusCode)"
        case .requestMapping:
            return "端点映射失败"
        case .underlying( _, _):
        return "请求失败，请检查网络"
        default:
            return "请求失败，请检查网络"
        }
    }
}
