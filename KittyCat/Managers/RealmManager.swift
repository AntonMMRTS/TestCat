//
//  RealmManager.swift
//  KittyCat
//
//  Created by Антон Усов on 13.10.2021.
//

import Foundation
import RealmSwift


class RealmManager {
    
    fileprivate lazy var realm = try! Realm(configuration: .defaultConfiguration)
    
    func addNewCat(cat: Cat) {
        let newCat = Cat()
        newCat.image = cat.image
        try! realm.write {
            realm.add(newCat)
        }
    }
    
    func obtainCats() -> [Cat] {
        let models = realm.objects(Cat.self)
        return Array(models)
    }
    
    func deleteCat(cat:Cat) {
        try? realm.write {
            realm.delete(cat)
        }
    }
    
}
