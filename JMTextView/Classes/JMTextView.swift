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
    
    @IBInspectable public var placeholder: String? {
        
        get {
            return _placeHolder
        }
        set(newValue) {
            
            _placeHolder = newValue
            _attributedPlaceholder = NSAttributedString(string: newValue!)
            resizePlaceholderFrame()
        }
        
    }
    public var attributedPlaceholder: NSAttributedString? {
        
        get {
            return _attributedPlaceholder
        }
        set(newValue) {
            _placeHolder = newValue?.string
            _attributedPlaceholder = newValue?.copy() as? NSAttributedString
            resizePlaceholderFrame()
        }
        
    }
    
    @IBInspectable public var fadeTime: Double?
    
    public var placeholderTextColor: UIColor? {
        
        get {
            return _placeholderTextView?.textColor
        }
        set(newValue) {
            _placeholderTextView?.textColor = newValue
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
        preparePlaceholder()
    }
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        preparePlaceholder()
    }
    
    private func preparePlaceholder() {
        
        assert(_placeholderTextView == nil, "placeholder has been prepared already: \(_placeholderTextView)")
        
        let frame = bounds
        _placeholderTextView = UITextView(frame:frame)
        _placeholderTextView?.isOpaque = false
        _placeholderTextView?.backgroundColor = UIColor.clear
        _placeholderTextView?.textColor = UIColor.init(white: 0.7, alpha: 0.7)
        _placeholderTextView?.textAlignment = textAlignment;
        _placeholderTextView?.isEditable = false
        _placeholderTextView?.isScrollEnabled = false
        _placeholderTextView?.isUserInteractionEnabled = false
        _placeholderTextView?.font = font;
        _placeholderTextView?.isAccessibilityElement = false
        _placeholderTextView?.contentOffset = contentOffset;
        _placeholderTextView?.contentInset = contentInset;
        
        if (_placeholderTextView!.responds(to: #selector(getter: UITextView.isSelectable))) {
            _placeholderTextView?.isSelectable = false
        }
        
        if (HAS_TEXT_CONTAINER(x: self)) {
            _placeholderTextView?.textContainer.exclusionPaths = textContainer.exclusionPaths;
            _placeholderTextView?.textContainer.lineFragmentPadding = textContainer.lineFragmentPadding;
        }
        if (HAS_TEXT_CONTAINER_INSETS(x: self)) {
            _placeholderTextView?.textContainerInset = textContainerInset;
        }
        if (attributedPlaceholder != nil) {
            _placeholderTextView?.attributedText = attributedPlaceholder;
        } else if (placeholder != nil ) {
            _placeholderTextView?.text = placeholder;
        }
        
        setPlaceHolderVisibleForText(text: text)
        
        clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(JMTextView.textDidChange(notification:)), name: NSNotification.Name.UITextViewTextDidChange, object: self)
        
        addObserver(self, forKeyPath: kAttributedPlaceholderKey, options: .new, context: nil)
        addObserver(self, forKeyPath: kPlaceholderKey, options: .new, context: nil)
        addObserver(self, forKeyPath: kFontKey, options: .new, context: nil)
        addObserver(self, forKeyPath: kAttributedTextKey, options: .new, context: nil)
        addObserver(self, forKeyPath: kTextKey, options: .new, context: nil)
        addObserver(self, forKeyPath: kTextAlignmentKey, options: .new, context: nil)
        
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
        resizePlaceholderFrame()
    }
    
    
    func textDidChange(notification: NSNotification) {
        setPlaceHolderVisibleForText(text: text)
    }
    
    func resizePlaceholderFrame() {
        
        guard var frame = _placeholderTextView?.frame else {
            return
        }
        frame.size = bounds.size
        _placeholderTextView?.frame = frame
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
        if keyPath == kAttributedPlaceholderKey {
            if let attributedString = change?[NSKeyValueChangeKey.newKey] as? NSAttributedString {
                _placeholderTextView?.attributedText = attributedString
            }
        }
        if keyPath == kPlaceholderKey {
            if let placeholderString = change?[NSKeyValueChangeKey.newKey] as? String {
                _placeholderTextView?.text = placeholderString
            }
        }
        if keyPath == kFontKey {
            if let font = change?[NSKeyValueChangeKey.newKey] as? UIFont {
                _placeholderTextView?.font = font
            }
        }
        if keyPath == kAttributedTextKey {
            if let attributedString = change?[NSKeyValueChangeKey.newKey] as? NSAttributedString {
                setPlaceHolderVisibleForText(text: attributedString.string)
            }
        }
        if keyPath == kTextKey {
            if let newText = change?[NSKeyValueChangeKey.newKey] as? String {
                setPlaceHolderVisibleForText(text: newText)
            }
        }
        if keyPath == kExclusionPathsKey {
            if let exclusionPaths = change?[NSKeyValueChangeKey.newKey] as? [UIBezierPath] {
                _placeholderTextView?.textContainer.exclusionPaths = exclusionPaths
                resizePlaceholderFrame()
            }
        }
        if keyPath == kLineFragmentPaddingKey {
            if let paddingValue = change?[NSKeyValueChangeKey.newKey] as? CGFloat {
                _placeholderTextView?.textContainer.lineFragmentPadding = paddingValue
                resizePlaceholderFrame()
            }
        }
        if keyPath == kTextContainerInsetKey {
            if let value = change?[NSKeyValueChangeKey.newKey] as? NSValue {
                _placeholderTextView?.textContainerInset = value.uiEdgeInsetsValue
            }
        }
        if keyPath == kTextAlignmentKey {
            if let alignment = change?[NSKeyValueChangeKey.newKey] as? NSTextAlignment {
                _placeholderTextView?.textAlignment = alignment
            }
        }
        
    }
    
    override public func becomeFirstResponder() -> Bool {
        
        setPlaceHolderVisibleForText(text: text)
        return super.becomeFirstResponder()
    }
    func hasFadeTime() -> Bool {
        if let fade = fadeTime {
            return fade > 0.0
        }
        return false
    }
    
    func setPlaceHolderVisibleForText(text: String) {
        
        guard let placeholderTextView = _placeholderTextView else {
            return
        }
        
        if text.characters.count < 1 {
            
            if hasFadeTime() {
                if !placeholderTextView.isDescendant(of: self) {
                    placeholderTextView.alpha = 0
                    addSubview(placeholderTextView)
                    sendSubview(toBack: placeholderTextView)
                }
                UIView.animate(withDuration: fadeTime!, animations: {
                    placeholderTextView.alpha = 1
                })
            } else {
                addSubview(placeholderTextView)
                sendSubview(toBack: placeholderTextView)
                placeholderTextView.alpha = 1
            }
            
        } else {
            
            if hasFadeTime() {
                UIView.animate(withDuration: fadeTime!, animations: {
                    placeholderTextView.alpha = 0
                })
            } else {
                placeholderTextView.removeFromSuperview()
            }
            
        }
    }
    
}
