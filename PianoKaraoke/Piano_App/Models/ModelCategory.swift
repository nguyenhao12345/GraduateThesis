//
//  ModelCategory.swift
//  Piano_App
//
//  Created by Nguyen Hieu on 5/26/19.
//  Copyright © 2019 com.nguyenhieu.demo. All rights reserved.
//

import Foundation
struct CategoryModel: ModelHome {
    var heighthSize: Float?
    
    var widthSize: Float?
    
    let name: String
    let arrCategory: [CategoryDetail]
    init(name: String, arrCategory: [CategoryDetail]) {
        self.name = name
        
        self.arrCategory = arrCategory
    }
}

struct CategoryDetail {
    var title: String
    var content: String
    init(title: String, content: String) {
        self.title = title
        self.content = content

    }
}
