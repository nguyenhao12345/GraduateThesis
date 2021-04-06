//
//  Sequence.swift
//  Azibai
//
//  Created Azi IOS on 11/8/18.
//  Copyright © 2018 Azi IOS. All rights reserved.
//

import Foundation

public extension Sequence where Iterator.Element: Hashable {
	var uniqueElements: [Iterator.Element] {
		return Array(
			Set(self)
		)
	}
}
public extension Sequence where Iterator.Element: Equatable {
	var uniqueElements: [Iterator.Element] {
		return self.reduce([]) { uniqueElements, element in
			
			uniqueElements.contains(element)
				? uniqueElements
				: uniqueElements + [element]
		}
	}
}

extension Range where Bound == String.Index {
    
    func toNSRange(str: String) -> NSRange {
        return NSRange(location: self.lowerBound.utf16Offset(in: str),
                       length: self.upperBound.utf16Offset(in: str) -
                        self.lowerBound.utf16Offset(in: str))
    }
}
