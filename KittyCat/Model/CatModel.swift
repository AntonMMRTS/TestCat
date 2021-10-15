//
//  CatModel.swift
//  KittyCat
//
//  Created by Антон Усов on 12.10.2021.
//

import Foundation
import RealmSwift


class Cat: Object {
    @objc dynamic var image: Data = Data()
}

struct URLAddress: Decodable {
    var url: String = ""
}



