//
//  Constants.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 11/23/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

//enum FileTypeSize {
//    case main
//    case inc
//
//    var size: Int {
//        switch self {
//        case .main:
//            return 4
//        case .inc:
//            return 2
//        }
//    }
//}

enum C {
    
    public static let MAX_BIT_SIZE = 64
    
    public static let DOC_PATH = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    public static let FILE_NAME = "app_data"
    
    public static let ID_SIZE = 8
    public static let DESC_SIZE = 20
    
    public static let MODEL_TYPE = "TestModel"
    
}

