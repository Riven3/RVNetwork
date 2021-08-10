//
//  APIUploadConfig.swift
//  RVNetWork
//
//  Created by 金劲通 on 2021/8/9.
//

import Foundation

public struct APIUploadData {
    public var uploadData: Data!
    public var dataName: String = ""
    public var fileName: String = ""
    public var mineType: String = ""
}

public struct APIUploadFile {
    public var uploadFile: URL!
    public var dataName: String = ""
    public var fileName: String = ""
    public var mineType: String = ""
}

open class APIUploadConfig: APIConfig {
    public var datas: [APIUploadData]?
    public var files: [APIUploadFile]?
}
