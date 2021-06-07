//
//  SectionBackgroundCardLayout.swift
//  BaseIGListKit
//
//  Created by Azibai on 21/12/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//
import IGListKit
public class SectionBackgroundCardViewLayoutDefault: SectionBackgroundCardViewLayout<SectionBackgroundCardView2> {
    
}

public class SectionBackgroundCardLayoutAttributes: UICollectionViewLayoutAttributes {
    public var paddingHeight: CGFloat = 0
    
    public override func copy(with zone: NSZone? = nil) -> Any {
        let obj = super.copy(with: zone) as! SectionBackgroundCardLayoutAttributes
        obj.paddingHeight = self.paddingHeight
        return obj
    }
}


public class SectionBackgroundCardViewLayout<T: UICollectionReusableView>: UICollectionViewFlowLayout {
    var itemAttributes: [UICollectionViewLayoutAttributes] = []
    let decorationViewOfKind = T.className
    public var topPaddings: [CGFloat] = []

    override public func prepare() {
        super.prepare()
        itemAttributes = []
        guard let collectionView = self.collectionView else {
            return
        }
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
                let attributes = SectionBackgroundCardLayoutAttributes(forDecorationViewOfKind: decorationViewOfKind, with: IndexPath(row: 0, section: section))
                attributes.paddingHeight = topPaddings.objectAtIndex(section) ?? 0
                attributes.zIndex = -1;
                attributes.frame = frame;
                itemAttributes.append(attributes)
                self.register(UINib(nibName: decorationViewOfKind, bundle: Bundle(for: T.self)), forDecorationViewOfKind: decorationViewOfKind)
            } else {
                let attributes = SectionBackgroundCardLayoutAttributes(forDecorationViewOfKind: "BackroundClear", with: IndexPath(row: 0, section: section))
                attributes.zIndex = -1;
                attributes.frame = frame;
                itemAttributes.append(attributes)
                self.register(UINib(nibName: "BackroundClear", bundle: Bundle(for: BackroundClear.self)), forDecorationViewOfKind: "BackroundClear")
            }
        }
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = super.layoutAttributesForElements(in: rect)

        for attribute in itemAttributes {
            if (!rect.intersects(attribute.frame)){
                continue
            }
            attributes?.append(attribute)
        }
        
        return attributes
    }


    public override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if let data = self.itemAttributes.objectAtIndex(indexPath.section) {
            return data
        }
        
        return nil
//            self.itemAttributes.objectAtIndex(indexPath.section - 1)
    }
}
