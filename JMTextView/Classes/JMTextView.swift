//
//  JMTextView.swift
//  JMTextView
//
//  Created by Jackie Meggesto on 02/15/2017.
//
//
import Foundation
import UIKit


fileprivate func HAS_TEXT_CONTAINER(x: AnyObject) -> Bool {
    return x.responds(to: #selector(getter: UITextView.textContainer))
}
fileprivate func HAS_TEXT_CONTAINER_INSETS(x: AnyObject) -> Bool {
    return x.responds(to: #selector(getter: UITextView.textContainerInset))
}
public class JMTextView: UITextView {
    
    private var _placeHolder: String?
    private var _attributedPlaceholder: NSAttributedString?
    
    @IBInspectable dynamic public var placeholder: String? {
        
        get {
            return self._placeHolder
        }
        set(newValue) {
            
            self._placeHolder = newValue
            self._attributedPlaceholder = NSAttributedString(string: newValue!)
            self.resizePlaceholderFrame()
        }
        
    }
    public dynamic var attributedPlaceholder: NSAttributedString? {
        
        get {
            return self._attributedPlaceholder
        }
        set(newValue) {
            self._placeHolder = newValue?.string
            self._attributedPlaceholder = newValue?.copy() as? NSAttributedString
            self.resizePlaceholderFrame()
        }
        
    }
    
    @IBInspectable public var fadeTime: Double?
    
    public var placeholderTextColor: UIColor? {
        
        get {
            return self._placeholderTextView?.textColor
        }
        set(newValue) {
            self._placeholderTextView?.textColor = newValue
        }
        
    }
    
    private var _placeholderTextView: UITextView?
    
    private let kAttributedPlaceholderKey = "attributedPlaceholder";
    private let kPlaceholderKey = "placeholder";
    private let kFontKey = "font";
    private let kAttributedTextKey = "attributedText";
    private let kTextKey = "text";
    private let kExclusionPathsKey = "exclusionPaths";
    private let kLineFragmentPaddingKey = "lineFragmentPadding";
    private let kTextContainerInsetKey = "textContainerInset";
    private let kTextAlignmentKey = "textAlignment";
    
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.preparePlaceholder()
    }
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.preparePlaceholder()
    }
    
    private func preparePlaceholder() {
        
        assert(self._placeholderTextView == nil, "placeholder has been prepared already: \(self._placeholderTextView)")
        
        let frame = bounds
        self._placeholderTextView = UITextView(frame:frame)
        self._placeholderTextView?.isOpaque = false
        self._placeholderTextView?.backgroundColor = UIColor.clear
        self._placeholderTextView?.textColor = UIColor.init(white: 0.7, alpha: 0.7)
        self._placeholderTextView?.textAlignment = textAlignment;
        self._placeholderTextView?.isEditable = false
        self._placeholderTextView?.isScrollEnabled = false
        self._placeholderTextView?.isUserInteractionEnabled = false
        self._placeholderTextView?.font = font;
        self._placeholderTextView?.isAccessibilityElement = false
        self._placeholderTextView?.contentOffset = contentOffset;
        self._placeholderTextView?.contentInset = contentInset;
        
        if (self._placeholderTextView!.responds(to: #selector(getter: UITextView.isSelectable))) {
            self._placeholderTextView?.isSelectable = false
        }
        
        if (HAS_TEXT_CONTAINER(x: self)) {
            self._placeholderTextView?.textContainer.exclusionPaths = textContainer.exclusionPaths;
            self._placeholderTextView?.textContainer.lineFragmentPadding = textContainer.lineFragmentPadding;
        }
        if (HAS_TEXT_CONTAINER_INSETS(x: self)) {
            self._placeholderTextView?.textContainerInset = textContainerInset;
        }
        if (attributedPlaceholder != nil) {
            self._placeholderTextView?.attributedText = self.attributedPlaceholder;
        } else if (placeholder != nil ) {
            self._placeholderTextView?.text = self.placeholder;
        }
        
        self.setPlaceHolderVisibleForText(text: text)
        
        self.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(JMTextView.textDidChange(notification:)), name: NSNotification.Name.UITextViewTextDidChange, object: self)
        
        self.addObserver(self, forKeyPath: kAttributedPlaceholderKey, options: .new, context: nil)
        self.addObserver(self, forKeyPath: kPlaceholderKey, options: .new, context: nil)
        self.addObserver(self, forKeyPath: kFontKey, options: .new, context: nil)
        self.addObserver(self, forKeyPath: kAttributedTextKey, options: .new, context: nil)
        self.addObserver(self, forKeyPath: kTextKey, options: .new, context: nil)
        self.addObserver(self, forKeyPath: kTextAlignmentKey, options: .new, context: nil)
        
        if(HAS_TEXT_CONTAINER(x: self)) {
            textContainer.addObserver(self, forKeyPath: kExclusionPathsKey, options: .new, context: nil)
            textContainer.addObserver(self, forKeyPath: kLineFragmentPaddingKey, options: .new, context: nil)
        }
        if(HAS_TEXT_CONTAINER_INSETS(x: self)) {
            addObserver(self, forKeyPath: kTextContainerInsetKey, options: .new, context: nil)
        }
        
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.resizePlaceholderFrame()
    }
    
    
    func textDidChange(notification: NSNotification) {
        self.setPlaceHolderVisibleForText(text: text)
    }
    
    func resizePlaceholderFrame() {
        
        guard var frame = self._placeholderTextView?.frame else {
            return
        }
        frame.size = bounds.size
        self._placeholderTextView?.frame = frame
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
        if keyPath == kAttributedPlaceholderKey {
            if let attributedString = change?[NSKeyValueChangeKey.newKey] as? NSAttributedString {
                self._placeholderTextView?.attributedText = attributedString
            }
        }
        if keyPath == kPlaceholderKey {
            if let placeholderString = change?[NSKeyValueChangeKey.newKey] as? String {
                self._placeholderTextView?.text = placeholderString
            }
        }
        if keyPath == kFontKey {
            if let font = change?[NSKeyValueChangeKey.newKey] as? UIFont {
                self._placeholderTextView?.font = font
            }
        }
        if keyPath == kAttributedTextKey {
            if let attributedString = change?[NSKeyValueChangeKey.newKey] as? NSAttributedString {
                self.setPlaceHolderVisibleForText(text: attributedString.string)
            }
        }
        if keyPath == kTextKey {
            if let newText = change?[NSKeyValueChangeKey.newKey] as? String {
                self.setPlaceHolderVisibleForText(text: newText)
            }
        }
        if keyPath == kExclusionPathsKey {
            if let exclusionPaths = change?[NSKeyValueChangeKey.newKey] as? [UIBezierPath] {
                self._placeholderTextView?.textContainer.exclusionPaths = exclusionPaths
                self.resizePlaceholderFrame()
            }
        }
        if keyPath == kLineFragmentPaddingKey {
            if let paddingValue = change?[NSKeyValueChangeKey.newKey] as? CGFloat {
                self._placeholderTextView?.textContainer.lineFragmentPadding = paddingValue
                self.resizePlaceholderFrame()
            }
        }
        if keyPath == kTextContainerInsetKey {
            if let value = change?[NSKeyValueChangeKey.newKey] as? NSValue {
                self._placeholderTextView?.textContainerInset = value.uiEdgeInsetsValue
            }
        }
        if keyPath == kTextAlignmentKey {
            if let alignment = change?[NSKeyValueChangeKey.newKey] as? NSTextAlignment {
                self._placeholderTextView?.textAlignment = alignment
            }
        }
        
    }
    
    override public func becomeFirstResponder() -> Bool {
        
        self.setPlaceHolderVisibleForText(text: text)
        return super.becomeFirstResponder()
    }
    func hasFadeTime() -> Bool {
        if let fade = self.fadeTime {
            return fade > 0.0
        }
        return false
    }
    
    func setPlaceHolderVisibleForText(text: String) {
        
        guard let placeholderTextView = self._placeholderTextView else {
            return
        }
        
        if text.characters.count < 1 {
            
            if self.hasFadeTime() {
                if !placeholderTextView.isDescendant(of: self) {
                    placeholderTextView.alpha = 0
                    addSubview(placeholderTextView)
                    sendSubview(toBack: placeholderTextView)
                }
                UIView.animate(withDuration: self.fadeTime!, animations: {
                    placeholderTextView.alpha = 1
                })
            } else {
                self.addSubview(placeholderTextView)
                self.sendSubview(toBack: placeholderTextView)
                placeholderTextView.alpha = 1
            }
            
        } else {
            
            if self.hasFadeTime() {
                UIView.animate(withDuration: self.fadeTime!, animations: {
                    placeholderTextView.alpha = 0
                })
            } else {
                placeholderTextView.removeFromSuperview()
            }
            
        }
    }
    
}
