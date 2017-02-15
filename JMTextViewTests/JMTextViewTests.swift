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
    
    
}
