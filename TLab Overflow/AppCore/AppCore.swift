//
//  AppCore.swift
//  SIETA
//
//  Created by Rifat Firdaus on 11/18/16.
//  Copyright © 2016 Suitmedia. All rights reserved.
//

import Foundation
import RealmSwift

public class AppCore: NSObject {
    public static func setup(home: String, customSessionManager: BaseSessionManager? = nil) {
        let schemaVersion:UInt64 = 1
        var config = Realm.Configuration(
            schemaVersion: schemaVersion,
            migrationBlock: { (migration, oldSchemaVersion) in
                if (oldSchemaVersion < schemaVersion) {
                    print("<<REALM: PROVIDED SCHEMA VERSION IS LESS THAN LAST SET VERSION>>")
                }
            }, deleteRealmIfMigrationNeeded: true, objectTypes: nil)
        Realm.Configuration.defaultConfiguration = config
        let _ = try! Realm()
        if let url = config.fileURL {
            print(url.absoluteString)
        }
        AppCoreService.instance.home = home
        if let customSessionManager = customSessionManager {
            AppCoreService.instance.manager = customSessionManager
        }
    }
    
}
