//
//  SaveDataFormat.swift
//  ToDo202102
//
//  Created by Chihiro Nishiwaki on 2021/02/18.
//

import Foundation
import RealmSwift

class SaveDataFormat: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var taskName: String = ""
    @objc dynamic var deadLine: String = ""
//    @objc dynamic var deadLineInt: Int = 0
    @objc dynamic var tag: String = ""
    @objc dynamic var deatail: String = ""
    
}
