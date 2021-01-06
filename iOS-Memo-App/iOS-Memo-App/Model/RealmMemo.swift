//
//  RealmMemo.swift
//  iOS-Memo-App
//
//  Created by taehy.k on 2021/01/06.
//

import Foundation
import RealmSwift

class RealmMemo: Object {
    @objc dynamic var title = ""
    @objc dynamic var content = ""
}
