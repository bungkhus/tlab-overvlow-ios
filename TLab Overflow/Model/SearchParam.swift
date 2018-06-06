//
//  SearchParam.swift
//  TLab Overflow
//
//  Created by bungkhus on 06/06/18.
//  Copyright © 2018 TLab. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class SearchParam: Object {

    @objc dynamic var identifier: Int = 0
    @objc dynamic var pageSize: Int = 0
    @objc dynamic var tag: String?
    @objc dynamic var from: NSDate?
    @objc dynamic var to: NSDate?
    
    override public static func primaryKey() -> String? {
        return "identifier"
    }
    
    public static func with(tag: String, pageSize: Int, from: Date, to: Date) -> SearchParam? {
        let realm = try! Realm()
        let identifier:Int = 1
        var obj = realm.object(ofType: SearchParam.self, forPrimaryKey: identifier)
        if obj == nil {
            obj = SearchParam()
            obj?.identifier = identifier
        } else {
            obj = SearchParam(value: obj!)
        }
        
        obj?.tag = tag
        obj?.from = from as NSDate
        obj?.to = to as NSDate
        obj?.pageSize = pageSize
        
        return obj
    }
    
}
