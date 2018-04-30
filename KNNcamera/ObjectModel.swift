//
//  ObjectModel.swift
//  MetalImageRecognition
//
//  Created by dang on 2017/3/13.
//  Copyright © 2017年 Dhruv Saksena. All rights reserved.
//

import UIKit

class ObjectModel: NSObject, NSCoding{
    var name : String = ""
    var prob : Float = 0.0
    var index : Int = 0 //相册中的位置
    func encode(with aCoder:NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(prob, forKey: "prob")
        aCoder.encode(index, forKey: "index")
    }
    required init(coder aDecoder:NSCoder) {
        super.init()
        name = aDecoder.decodeObject(forKey: "name") as! String
        prob = aDecoder.decodeFloat(forKey: "prob")
        index = Int(aDecoder.decodeInt32(forKey: "index"))
    }
    override init() {
        super.init()
    }
}
