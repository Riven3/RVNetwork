//
//  Response+HandyJSON.swift
//  RVNetWork
//
//  Created by 金劲通 on 2021/8/10.
//

import UIKit
import Moya
import RxSwift
import HandyJSON

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    func mapData<T: HandyJSON>(_ type: T.Type) -> Single<T> {
        return flatMap { (response) -> Single<T> in
            return Single.just(response.mapData(T.self))
        }
    }
}

extension Response {
    func mapData<T: HandyJSON>(_ type: T.Type) -> T {
        let jsonString = String.init(data: data, encoding: String.Encoding.utf8)
        return JSONDeserializer<T>.deserializeFrom(json: jsonString)!
    }
}
