//
//  Owner.swift
//  TLab Overflow
//
//  Created by bungkhus on 06/06/18.
//  Copyright © 2018 TLab. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class Owner: Object {
    
    @objc dynamic var identifier: Int64 = 0
    @objc dynamic var displayName: String?
    @objc dynamic var profileImageUrl: String?
    
    override public static func primaryKey() -> String? {
        return "identifier"
    }
    
    public static func with(realm: Realm, json: JSON) -> Owner? {
        let identifier = json["user_id"].int64Value
        if identifier == 0 {
            return nil
        }
        var obj = realm.object(ofType: Owner.self, forPrimaryKey: identifier)
        if obj == nil {
            obj = Owner()
            obj?.identifier = identifier
        } else {
            obj = Owner(value: obj!)
        }
        
        if json["display_name"].exists() {
            obj?.displayName = json["display_name"].string
        }
        if json["profile_image"].exists() {
            obj?.profileImageUrl = json["profile_image"].string
        }
        
        return obj
    }
    
    public static func with(json: JSON) -> Owner? {
        return with(realm: try! Realm(), json: json)
    }
    
}
