//
//  SearchItem.swift
//  TLab Overflow
//
//  Created by bungkhus on 06/06/18.
//  Copyright © 2018 TLab. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class SearchItem: Object {
    
    @objc dynamic var identifier: Int64 = 0
    @objc dynamic var title: String?
    @objc dynamic public var createDate: NSDate?
    @objc dynamic var owner: Owner?

    override public static func primaryKey() -> String? {
        return "identifier"
    }
    
    public static func with(realm: Realm, json: JSON) -> SearchItem? {
        let identifier = json["question_id"].int64Value
        if identifier == 0 {
            return nil
        }
        var obj = realm.object(ofType: SearchItem.self, forPrimaryKey: identifier)
        if obj == nil {
            obj = SearchItem()
            obj?.identifier = identifier
        } else {
            obj = SearchItem(value: obj!)
        }
        
        if json["title"].exists() {
            obj?.title = json["title"].string
        }
        if json["creation_date"].exists() {
            if let timeInterval = json["creation_date"].double {
                obj?.createDate = Date(timeIntervalSince1970: timeInterval) as NSDate?
            } else {
                print("gagal parsing tanggal")
            }
        }
        if json["owner"].exists() {
            let ownerJson = json["owner"]
            obj?.owner = Owner.with(json: ownerJson)
        }
        
        return obj
    }
    
    public static func with(json: JSON) -> SearchItem? {
        return with(realm: try! Realm(), json: json)
    }
    
}
