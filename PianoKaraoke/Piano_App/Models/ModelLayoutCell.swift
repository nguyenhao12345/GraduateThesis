//
//  ModelHome.swift
//  Piano_App
//
//  Created by Nguyen Hieu on 2/12/19.
//  Copyright © 2019 com.nguyenhieu.demo. All rights reserved.
//

enum LayoutNhacTrungQuoc {
    case heightTQ
    case widthTQ
    case heightCellTQ
    case widthCellTQ
    var rawValue: Float {
        switch self {
        case .heightTQ:
            return GetFramUIScreen.share.getHeightUIScreen()/2
        case .widthTQ:
            return GetFramUIScreen.share.getWitdhUIScreen()
        case .heightCellTQ:
            return GetFramUIScreen.share.getHeightUIScreen()/2 - 50
        case .widthCellTQ:
            return GetFramUIScreen.share.getWitdhUIScreen()/3
        }
    }
}
enum LayoutNhacViet {
    case heightNhacViet
    case widthNhacViet
    case heightCellNhacViet
    case widthCellNhacViet
    var rawValue: Float {
        switch self {
        case .heightNhacViet:
            return GetFramUIScreen.share.getHeightUIScreen()/3
        case .widthNhacViet:
            return GetFramUIScreen.share.getWitdhUIScreen()
        case .heightCellNhacViet:
            return GetFramUIScreen.share.getHeightUIScreen()/3 - 50
        case .widthCellNhacViet:
            return GetFramUIScreen.share.getWitdhUIScreen()/4
        }
    }
}

enum LayoutDanhChoNguoiMoiBatDau {
    case heightDanhChoNguoiMoiBatDau
    case widthDanhChoNguoiMoiBatDau
    case heightCellDanhChoNguoiMoiBatDau
    case widthCellDanhChoNguoiMoiBatDau
    var rawValue: Float {
        switch self {
        case .heightDanhChoNguoiMoiBatDau:
            return GetFramUIScreen.share.getHeightUIScreen()/3
        case .widthDanhChoNguoiMoiBatDau:
            return GetFramUIScreen.share.getWitdhUIScreen()
        case .heightCellDanhChoNguoiMoiBatDau:
            return GetFramUIScreen.share.getHeightUIScreen()/3 - 50
        case .widthCellDanhChoNguoiMoiBatDau:
            return GetFramUIScreen.share.getWitdhUIScreen()/3
        }
    }
}
enum LayoutListSongPiano {
    case height
    case width
    var rawValue: Float {
        switch self {
        case .height:
            return GetFramUIScreen.share.getHeightUIScreen()/5
        case .width:
            return GetFramUIScreen.share.getWitdhUIScreen()
        }
    }
}










//
//struct BaiHatYeuThichNhat: ModelHome {
//    var viewController: UIViewController? {
//        return nil
//    }
//    
//    var heighthSize: CGFloat? {
//        return UIScreen.main.bounds.size.height / 3
//    }
//    
//    var widthSize: CGFloat? {
//        return UIScreen.main.bounds.size.width
//    }
//    
//    var background: UIColor? {
//        return .white
//    }
//    
//    let arrayBaiHatYeuThichNhat: [ModelDetailCellSongs]
//    let title: String?
//    init(title: String, arrayBaiHatYeuThichNhat: [ModelDetailCellSongs]) {
//        self.title = title
//        self.arrayBaiHatYeuThichNhat = arrayBaiHatYeuThichNhat
//    }
//}
