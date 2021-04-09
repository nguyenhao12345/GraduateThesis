//
//  RealmHelper.swift
//  Piano_App
//
//  Created by Azibai on 06/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import Foundation

import RealmSwift

let REALM_HELPER = RealmHelper.shared

class RealmHelper {
    
    // MARK: - Properties
    static let shared = RealmHelper()
    var _realm: Realm!
}

// MARK: - Methods
extension RealmHelper {
    
    func configure() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        }, deleteRealmIfMigrationNeeded: true)
        
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        _realm = try! Realm()
        print("Realm Path", Realm.Configuration.defaultConfiguration.fileURL!)
        
    }
    
    // delete database
    func deleteDatabase() {
        try! _realm.write({
            _realm.deleteAll()
        })
    }
    
    // delete particular object
    func deleteObject(_ object : Object) {
        try? _realm.write ({
            _realm.delete(object)
        })
    }
    
    func deleteObjects<T: Object>(type: T.Type) {
        let objects = _realm.objects(T.self)
        try? _realm.write ({
            _realm.delete(objects)
        })
    }
    
    //Save array of objects to database
    func saveObjects(_ object: Object) {
        try? _realm.write ({
            _realm.add(object, update: .error)
//            _realm.add(object, update: false)
        })
    }
    
    // editing the object
    func editObjects(_ object: Object) {
        try? _realm.write ({
            _realm.add(object, update: .all)
//            _realm.add(object, update: true)
        })
    }
    
    //Returs an array as Results<object>?
    func getObjects<T: Object>(type: T.Type) -> Results<T>? {
        let objects = _realm.objects(T.self)
        return objects
    }
}
