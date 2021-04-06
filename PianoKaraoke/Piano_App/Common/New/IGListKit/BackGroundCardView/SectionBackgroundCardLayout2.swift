//
//  SectionBackgroundCardLayout.swift
//  BaseIGListKit
//
//  Created by Azibai on 21/12/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//
import IGListKit

public class SectionBackgroundCardLayoutAttributes2: UICollectionViewLayoutAttributes {
    public var paddingHeight: CGFloat = 0
    
    public override func copy(with zone: NSZone? = nil) -> Any {
        let obj = super.copy(with: zone) as! SectionBackgroundCardLayoutAttributes2
        obj.paddingHeight = self.paddingHeight
        return obj
    }
}


public class SectionBackgroundCardLayout2: UICollectionViewFlowLayout {
    var itemAttributes: [UICollectionViewLayoutAttributes] = []
    let a: String = ""
    let decorationViewOfKind = "SectionBackgroundCardView2"
    public var topPaddings: [CGFloat] = []
    override public func prepare() {
        super.prepare()
//        self.minimumLineSpacing = 10
//        self.minimumInteritemSpacing = 10
        itemAttributes = []
        guard let collectionView = self.collectionView else{
            return
        }
//        let delegate: UICollectionViewDelegateFlowLayout? = collectionView.delegate as? UICollectionViewDelegateFlowLayout
        let numberOfSection = collectionView.numberOfSections
        for section in  0..<numberOfSection{
            let lastIndex = collectionView.numberOfItems(inSection: section) - 1
            if lastIndex < 0 {
                continue
            }
            guard let firstItem = self.layoutAttributesForItem(at: IndexPath(row: 0, section: section)),
                let lastItem = self.layoutAttributesForItem(at: IndexPath(row: lastIndex, section: section)) else{
                    continue
            }
            
            let contentInset = collectionView.contentInset
            ////----
            var frame = firstItem.frame.union(lastItem.frame)
            if self.scrollDirection == .horizontal {
                frame.origin.x = -contentInset.left
                frame.size.width += sectionInset.left + sectionInset.right
                frame.size.height = collectionView.frame.size.height
            } else {
                frame.origin.x = -contentInset.left
                frame.size.width = collectionView.frame.size.width
                frame.size.height += sectionInset.top + sectionInset.bottom
            }
            
            if let dt = collectionView.dataSource as? ListAdapter,
                let _ = dt.object(atSection: section) as? SectionBackGroundCardLayoutInterface
            {
                let attributes = SectionBackgroundCardLayoutAttributes2(forDecorationViewOfKind: decorationViewOfKind, with: IndexPath(row: 0, section: section))
                attributes.paddingHeight = topPaddings.objectAtIndex(section) ?? 0
                attributes.zIndex = -1;
                attributes.frame = frame;
                itemAttributes.append(attributes)
                self.register(UINib(nibName: decorationViewOfKind, bundle: Bundle(for: SectionBackgroundCardView2.self)), forDecorationViewOfKind: decorationViewOfKind)
            }
        }
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = super.layoutAttributesForElements(in: rect)
        
        for attribute in itemAttributes{
            if (!rect.intersects(attribute.frame)){
                continue
            }
            attributes?.append(attribute)
        }
        
        return attributes
    }
    
//    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        return itemAttributes.objectAtIndex(indexPath.item)
//    }
//

    public override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if let data = self.itemAttributes.objectAtIndex(indexPath.section) {
            return data
        }
        
        return self.itemAttributes.objectAtIndex(indexPath.section - 1)
    }
}



public class AppBundle: NSObject {
    public static let shared: AppBundle = AppBundle()
    static let bundle: Bundle = AppBundle.shared._bundle
    var _bundle: Bundle
    private override init() {
        self._bundle = Bundle(for: type(of: self))
        super.init()
    }
    
    
    public func getBundle() -> Bundle? {
        return _bundle
//        let fwBundle = Bundle(for: AppBundle.self)
//        let path = fwBundle.path(forResource: "BaseIGListKit", ofType: "bundle")
//        let resourcesBundle = Bundle(url: URL(fileURLWithPath: path!))
//        return resourcesBundle
    }
}
