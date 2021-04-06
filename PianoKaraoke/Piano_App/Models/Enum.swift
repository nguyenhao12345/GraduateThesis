//
//  Enum.swift
//  Piano_App
//
//  Created by Nguyen Hieu on 2/27/19.
//  Copyright © 2019 com.nguyenhieu.demo. All rights reserved.
//

enum NameCell: String {
    case LocalSongs = "LocalSongs"
    case OnlineSongs = "OnlineSongs"
    var result: String {
        return self.rawValue
    }
}
enum ListScreen: Int {
    case InfoSong = 1
    case ListSongs = 2
}
enum TypeCell: Int {
    case CellLocal = 1
    case CellOnline = 2
    case CellYoutube = 3
}

enum Tone: Int {
    case Do = 48
    case DoThang = 49
    case Re = 50
    case ReThang = 51
    case Mi = 52
    case Fa = 53
    case FaThang = 54
    case Sol = 55
    case SolThang = 56
    case La = 57
    case LaThang = 58
    case Si = 59
    
    var arrTone: [Tone] {
        return [.Do, .DoThang,
                .Re, .ReThang,
                .Mi,
                .Fa, .FaThang,
                .Sol, .SolThang,
                .La, .LaThang,
                .Si]
    }
    enum EditTone {
        case Up
        case Down
    }
    func editTone(control: EditTone) -> Tone {
        for i in arrTone.enumerated() {
            if i.element == self {
                if control == .Up {
                    if i.offset + 1 >= arrTone.count {
                        return self
                    }
                    return arrTone[i.offset + 1]
                } else if control == .Down {
                    if i.offset + 1 <= 0 {
                        return self
                    }
                    return arrTone[i.offset - 1]
                }
            }
        }
        return self
    }
    
    func getName(quang: String) -> String {
        switch self {
        case .Do:
            return "Đô\(quang)"
        case .DoThang:
            return "Đô\(quang)#"
        case .Re:
            return "Rê\(quang)"
        case .ReThang:
            return "Rê\(quang)#"
        case .Mi:
            return "Mi\(quang)"
        case .Fa:
            return "Fa\(quang)"
        case .FaThang:
            return "Fa\(quang)#"
        case .Sol:
            return "Sol\(quang)"
        case .SolThang:
            return "Sol\(quang)#"
        case .La:
            return "La\(quang)"
        case .LaThang:
            return "La\(quang)#"
        case .Si:
            return "Si\(quang)"
        }
    }
    
    func getKeyName(quang: String) -> String {
        switch self {
        case .Do:
            return "C\(quang)"
        case .DoThang:
            return "C\(quang)#"
        case .Re:
            return "D\(quang)"
        case .ReThang:
            return "D\(quang)#"
        case .Mi:
            return "E\(quang)"
        case .Fa:
            return "F\(quang)"
        case .FaThang:
            return "F\(quang)#"
        case .Sol:
            return "G\(quang)"
        case .SolThang:
            return "G\(quang)#"
        case .La:
            return "A\(quang)"
        case .LaThang:
            return "A\(quang)#"
        case .Si:
            return "B\(quang)"
        }
    }
    
    
}
