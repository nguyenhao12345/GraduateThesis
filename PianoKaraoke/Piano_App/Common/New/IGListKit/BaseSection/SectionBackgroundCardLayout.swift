//
//  File.swift
//  gapoFeedClone
//
//  Created by Azibai on 18/08/2020.
//  Copyright © 2020 com.hieudev. All rights reserved.
//

import UIKit

public class SectionBackgroundCardLayout: UICollectionViewFlowLayout {
    
    var itemAttributes: [UICollectionViewLayoutAttributes] = []
    let decorationViewOfKind = "SectionBackgroundCardView"
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
                let lastItem = self.layoutAttributesForItem(at: IndexPath(row: lastIndex, section: section)) else {
                    continue
            }
            
            let contentInset = collectionView.contentInset
            ////----
            var frame = firstItem.frame.union(lastItem.frame)
            if self.scrollDirection == .horizontal{
                frame.origin.y = -contentInset.top
                frame.origin.x = -contentInset.left
                frame.size.width += sectionInset.left + sectionInset.right
                frame.size.height = collectionView.frame.size.height
            }else{
                frame.origin.y = -contentInset.top
                frame.origin.x = -contentInset.left
                frame.size.width = collectionView.frame.size.width
                frame.size.height += sectionInset.top + sectionInset.bottom
            }
            
            let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: decorationViewOfKind, with: IndexPath(row: 0, section: section))
            attributes.zIndex = -1;
            attributes.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)
            itemAttributes.append(attributes)
            self.register(UINib(nibName: decorationViewOfKind, bundle: Bundle(for: SectionBackgroundCardView.self)), forDecorationViewOfKind: decorationViewOfKind)
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
    
    public override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.itemAttributes.objectAtIndex(indexPath.section)
    }
    
}





protocol CollectionViewSectionBackgroundColor: UICollectionViewDelegateFlowLayout {
    func sectionsNeedBackgroundColor(in collectionView: UICollectionView, layout: UICollectionViewFlowLayout) -> [Int]
    func color(for section: Int) -> UIColor?
}

class SectionBackgroundFlowLayout: UICollectionViewFlowLayout {
    private static let sectionBackgroundColorElement = "sectionBackgroundColorElement"
    private var sectionBackgroundAttributes: SectionBackgroundColorLayoutAttributes?
    private var sectionMaxYPairs: [Int: CGFloat] = [:]
    private var sectionInsetPairs: [Int: UIEdgeInsets] = [:]
    private var sectionLineSpacing: [Int: CGFloat] = [:]
    private var sectionBackgroundAttributesPairs: [Int: SectionBackgroundColorLayoutAttributes] = [:]
    
    weak var sectionBackgroundDelegate: CollectionViewSectionBackgroundColor?
    
    // MARK: prepareLayout
    
    override func prepare() {
        super.prepare()
        register(SectionBackgroundReusableView.self, forDecorationViewOfKind: SectionBackgroundFlowLayout.sectionBackgroundColorElement)
        
        prepareSectionInsetPairs()
        prepareSectionLineSpacing()
        prepareIndices()
        prepareSectionBackgroundAttributes()
    }
    
    private func prepareSectionInsetPairs() {
        sectionInsetPairs.removeAll()
        guard let collectionView = collectionView else {
            return
        }
        for section in 0 ..< collectionView.numberOfSections {
            let inset = (collectionView.delegate as? UICollectionViewDelegateFlowLayout)?
                .collectionView?(collectionView, layout: self, insetForSectionAt: section) ?? sectionInset
            sectionInsetPairs[section] = inset
        }
    }
    
    private func prepareSectionLineSpacing() {
        sectionLineSpacing.removeAll()
        guard let collectionView = collectionView else { return }
        for section in 0 ..< collectionView.numberOfSections {
            let spacing = (collectionView.delegate as? UICollectionViewDelegateFlowLayout)?
                .collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: section) ?? minimumLineSpacing
            sectionLineSpacing[section] = spacing
        }
    }
    
    private func prepareIndices() {
        guard let collectionView = collectionView else {
            sectionInsetPairs.removeAll()
            return
        }
        prepareSectionInsetPairs()
        
        let numberOfSections = collectionView.numberOfSections
        
        var row = 0
        var sectionMaxY: CGFloat = 0
        for section in 0 ..< numberOfSections {
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            let minSpacing = (collectionView.delegate as? UICollectionViewDelegateFlowLayout)?
                .collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: section) ?? minimumInteritemSpacing
            
            guard numberOfItems > 0 else { return }
            let inset = sectionInsetPairs[0]!
            
            let sizeArray = (0 ..< numberOfItems)
                .map({ item in
                    (collectionView.delegate as? UICollectionViewDelegateFlowLayout)?
                        .collectionView?(collectionView, layout: self, sizeForItemAt: IndexPath(item: item, section: section)) ?? itemSize
                    
                })
            
            let sectionWidth = collectionViewContentSize.width - inset.left - inset.right
            
            var rowWidth: CGFloat = 0
            var rowHeight: CGFloat = 0
            var rowIndex = 0
            sectionMaxY = sectionMaxY
                + sectionInsetPairs[section]!.top
                + ((collectionView.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(collectionView, layout: self, referenceSizeForHeaderInSection: section).height ?? 0)
            
            let widthArray = sizeArray.map { $0.width }
            for item in 0 ..< widthArray.count {
                assert(widthArray[item] <= sectionWidth, "Only Vertical Support!! itemWidth Should <= sectionWidth")
                let nextItem = item + 1
                
                let isNextBeyond: Bool
                let hasNext: Bool
                if widthArray.indices ~= nextItem {
                    let nextRowWidth = rowWidth + minSpacing + widthArray[nextItem]
                    isNextBeyond = nextRowWidth > sectionWidth
                    hasNext = true
                } else {
                    isNextBeyond = false
                    hasNext = false
                }
                
                rowHeight = max(sizeArray[item].height, rowHeight)
                
                switch (hasNext, isNextBeyond) {
                case (true, true):
                    // current row is over
                    
                    rowIndex = 0
                    rowWidth = 0
                    row += 1
                    
                    let sectionYaddValue = sectionLineSpacing[section]!
                    
                    sectionMaxY = sectionMaxY + rowHeight + sectionYaddValue
                    
                    rowHeight = 0
                    
                case (true, false):
                    // continue current row
                    
                    rowIndex += 1
                    rowWidth = rowWidth + minSpacing + widthArray[item]
                    
                case (false, _):
                    
                    // current row is over
                    rowIndex = 0
                    rowWidth = 0
                    row += 1
                    
                    let sectionYaddValue = ((collectionView.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(collectionView, layout: self, referenceSizeForFooterInSection: section).height ?? 0) + sectionInsetPairs[section]!.bottom
                    sectionMaxY = sectionMaxY + rowHeight + sectionYaddValue
                    
                    rowHeight = 0
                }
            }
            sectionMaxYPairs[section] = sectionMaxY
        }
    }
    
    private func prepareSectionBackgroundAttributes() {
        sectionBackgroundAttributesPairs.removeAll()
        guard let collectionView = collectionView,
            let sectionBackgroundDelegate = sectionBackgroundDelegate
        else { return }
        
        let sections = sectionBackgroundDelegate.sectionsNeedBackgroundColor(in: collectionView, layout: self)
        
        guard !sections.isEmpty else { return }
        
        let sectionBackgroundMap = sections.reduce(into: [Int: UIColor?]()) { pair, section in
            pair[section] = sectionBackgroundDelegate.color(for: section)
        }
        
        for (section, backgroundColor) in sectionBackgroundMap {
            // let inset = sectionInsetPairs[section]!
            // ignore inset
            let x: CGFloat = 0
            let y = sectionMaxYPairs[section - 1] ?? 0
            let w = collectionView.bounds.width
            let h = (sectionMaxYPairs[section] ?? 0) - (sectionMaxYPairs[section - 1] ?? 0)
            
            let att = SectionBackgroundColorLayoutAttributes(forDecorationViewOfKind: SectionBackgroundFlowLayout.sectionBackgroundColorElement, with: IndexPath(row: 0, section: section))
            att.frame = CGRect(x: x, y: y, width: w, height: h)
            att.zIndex = -100 // may not ok
            att.color = backgroundColor
            sectionBackgroundAttributesPairs[section] = att
        }
    }
    
    // MARK: layoutAttributesForElementsInRect
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard elementKind == SectionBackgroundFlowLayout.sectionBackgroundColorElement
        else { return nil }
        
        return sectionBackgroundAttributesPairs[indexPath.section]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = super.layoutAttributesForElements(in: rect)
        attributes?.append(contentsOf: sectionBackgroundAttributesPairs.map { $0.1 })
        return attributes
    }
}

private class SectionBackgroundColorLayoutAttributes: UICollectionViewLayoutAttributes {
    var color: UIColor?
    override func copy(with zone: NSZone? = nil) -> Any {
        let new = super.copy(with: zone)
        (new as? SectionBackgroundColorLayoutAttributes)?.color = color
        return new
    }
}

private class SectionBackgroundReusableView: UICollectionReusableView {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let scLayoutAttributes = layoutAttributes as! SectionBackgroundColorLayoutAttributes
        backgroundColor = scLayoutAttributes.color
    }
}
