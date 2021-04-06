//
//  UITextView.swift
//  Azibai
//
//  Created Azi IOS on 11/8/18.
//  Copyright © 2018 Azi IOS. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Methods
public extension UITextView {

    /// SwifterSwift: Clear text.
    func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }

    /// SwifterSwift: Scroll to the bottom of text view
    func scrollToBottom() {
        // swiftlint:disable next legacy_constructor
        let range = NSMakeRange((text as NSString).length - 1, 1)
        scrollRangeToVisible(range)
    }

    /// SwifterSwift: Scroll to the top of text view
    func scrollToTop() {
        // swiftlint:disable next legacy_constructor
        let range = NSMakeRange(0, 1)
        scrollRangeToVisible(range)
    }

    /// SwifterSwift: Wrap to the content (Text / Attributed Text).
    func wrapToContent() {
        contentInset = UIEdgeInsets.zero
        scrollIndicatorInsets = UIEdgeInsets.zero
        contentOffset = CGPoint.zero
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
        sizeToFit()
    }

}
#endif

extension UITextView{
    
    @objc func doneButtonAction(){
        self.resignFirstResponder()
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Xong", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    open override func draw(_ rect: CGRect) {
        autocorrectionType = .no
//        addDoneButtonOnKeyboard()
    }

    func getCurrentCursorPosition() -> Int {
        var cursorPosition = text.count - 1
        if let selectedRange = selectedTextRange {
            cursorPosition = offset(from: beginningOfDocument, to: selectedRange.start)
        }
        return cursorPosition
    }
    
    func setCursorPosition(_ pos: Int) {
        if let newPosition = position(from: beginningOfDocument, offset: pos) {
            
            selectedTextRange = textRange(from: newPosition, to: newPosition)
        }
    }
    
    private func _getRange(from position: UITextPosition, offset: Int) -> UITextRange? {
        guard let newPosition = self.position(from: position, offset: offset) else { return nil }
        return self.textRange(from: newPosition, to: position)
    }
    
    /// Returns range of the current word that the cursor is at.
    func currentRange(startWith: Character = " ") -> UITextRange? {
        guard let cursorRange = self.selectedTextRange, text.contains(startWith) else { return nil }
        
        var wordStartPosition: UITextPosition = self.beginningOfDocument
        var wordEndPosition: UITextPosition = self.endOfDocument
        
        var position = cursorRange.start
        
        while let range1 = _getRange(from: position, offset: -1), let text1 = self.text(in: range1),
            let range2 = _getRange(from: range1.start, offset: -1), let text2 = self.text(in: range2)
            {
            if text1 == String(startWith) && (text2 == "\n" || text2 == " ") {
                wordStartPosition = range2.end
                break
            }
            position = range1.start
        }
        
        position = cursorRange.start
        
        while let range = _getRange(from: position, offset: 1), let text = self.text(in: range) {
            if text == " " || text == "\n" {
                wordEndPosition = range.start
                break
            }
            position = range.end
        }
        
        guard let wordRange = self.textRange(from: wordStartPosition, to: wordEndPosition) else {
            return nil
        }
        
        return wordRange
    }
    
    // Returns the current word that the cursor is at.
    func currentWord() -> String {
        if let range = currentRange() {
            return self.text(in: range) ?? ""
        }
        else {
            return ""
        }
    }
    
    func currentPhrase(startWith: Character) -> String {
        if let range = currentRange(startWith: startWith) {
            return self.text(in: range) ?? ""
        }
        else {
            return ""
        }
    }
}
