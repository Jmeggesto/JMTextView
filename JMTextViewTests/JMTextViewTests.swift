class JMTextViewTests: XCTestCase {
    var textView: JMTextView?
    var placeholderTextView: UITextView?
    
    override func setUp() {
        super.setUp()
        textView = JMTextView()
        placeholderTextView = textView?.value(forKey: "_placeholderTextView") as! UITextView!
    }
    override func tearDown() {
        placeholderTextView = nil
        textView = nil
        super.tearDown()
    }
    func testPlaceholderTextViewSuperViewUponBecomingFirstResponder() {
        textView?.becomeFirstResponder()
        XCTAssertNotNil(placeholderTextView?.superview, "Should initially have superview")
        XCTAssertEqual(placeholderTextView?.superview, textView, "Placeholder superview should be text view itself.")
    }
    func testPlaceholderTextViewChangeSuperviewAfterSetText() {
        textView?.text = "Foobar"
        XCTAssertNil(placeholderTextView?.superview, "Placeholder should not have a superview if the containing text view has input")
        textView?.text = nil
        NSLog("Superview: %@", placeholderTextView?.superview ?? "nil")
        XCTAssertNotNil(placeholderTextView?.superview, "Placeholder should have a superview if the containing text view has no input")
        
    }
    func testPlaceholderTextViewShouldInheritFont() {
        textView?.font = UIFont.systemFont(ofSize: 20.0)
        XCTAssertEqual(placeholderTextView?.font, textView?.font, "label and text view should have equal fonts")
    }
    func testAttributedPlaceholderText() {
        let placeholder: NSMutableAttributedString = NSMutableAttributedString(string: "SZTextView")
        placeholder.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSMakeRange(0, 2))
        placeholder.addAttribute(NSForegroundColorAttributeName, value: UIColor.green, range: NSMakeRange(2, 4))
        placeholder.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: NSMakeRange(6, 4))
        textView?.attributedPlaceholder = placeholder
        XCTAssertEqual(textView?.attributedPlaceholder?.string, "SZTextView", "-attributedPlaceholder string should be set")
        XCTAssertEqual(textView?.placeholder, "SZTextView", "-placeholder should return a non-attributed copy of -attributedPlacholder")
        textView?.placeholder = "AnotherPlaceholder"
        XCTAssertEqual(textView?.attributedPlaceholder?.string, "AnotherPlaceholder", "setting a non-attributed placeholder after setting an attributed placholder should copy the text")
    }
    
    
}
