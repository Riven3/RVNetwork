//
//  APIModel.swift
//  RVNetWork
//
//  Created by 金劲通 on 2021/8/9.
//

import UIKit
import HandyJSON

class APIModel<T: HandyJSON>: HandyJSON {
    required init() {}
    var error: Bool = false
    var results: T?
}

class APIBlankModel: HandyJSON {
    required init() { }
}
