# JMTextView 

[![CI Status](http://img.shields.io/travis/jmeggesto/JMTextView.svg?style=flat)](https://travis-ci.org/jmeggesto/JMTextView)
[![Version](https://img.shields.io/cocoapods/v/JMTextView.svg?style=flat)](http://cocoapods.org/pods/JMTextView)
[![License](https://img.shields.io/cocoapods/l/JMTextView.svg?style=flat)](http://cocoapods.org/pods/JMTextView)
[![Platform](https://img.shields.io/cocoapods/p/JMTextView.svg?style=flat)](http://cocoapods.org/pods/JMTextView)

A drop-in UITextView replacement which gives you: a placeholder.

Swift version of [SZTextView](https://github.com/glaszig/SZTextView)

Technically it differs from other solutions in that it tries to work like UITextField's private `_placeholderLabel` so you should not suffer ugly glitches like jumping text views or loads of custom drawing code.

## Requirements

An iOS project running Swift 3.0 or higher. 

## Installation

Either clone this repo and add the project to your Xcode workspace, or use [CocoaPods](http://cocoapods.org)

#### CocoaPods

Add this to you Podfile:

```ruby
use_frameworks!
target "YourXcodeProj" do
  pod 'JMTextView', '~> 1.0.0'

# where "YourXcodeProj" is the name of your project

end
```
## Usage

```swift
let textView: JMTextView = JMTextView()
textView.placeholder = "Enter lorem ipsum here"
textView.placeholderTextColor = UIColor.lightGray
```

Analogously you can use the `attributedPlaceholder` property to set a fancy `NSAttributedString` as the placeholder:

```swift
let placeholder: NSMutableAttributedString = NSMutableAttributedString(string: "your lorem ipsum here")
placeholder.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSMakeRange(0, 2))
placeholder.addAttribute(NSForegroundColorAttributeName, value: UIColor.green, range: NSMakeRange(2, 4))
placeholder.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: NSMakeRange(6, 4))

textView.attributedPlaceholder = placeholder;
```

Both properties `placeholder` and `attributedPlaceholder` are made to stay in sync.
If you set an `attributedPlaceholder` and afterwards set `placeholder` to something else, the set text gets copied to the `attributedPlaceholder` while trying to keep the original text attributes.  
Also, `placeholder` will be set to `attributedPlaceholder.string` when using the `attributedPlaceholder` setter.

A simple demo and a few unit tests are included.

### Animation

The placeholder is animatable. Just configure the `double` property `fadeTime`
to the seconds you'd like the animation to take.

### User Defined Runtime Attributes

If you prefer using Interface Builder to configure your UI, you can use UDRA's to set values for `placeholder` and `placeholderTextColor`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# License

Published under the [MIT license](http://opensource.org/licenses/MIT).
