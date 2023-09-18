//
//  StringExtensions.swift
//  Copyright © 2023 Meet,Monang,Nilomi . All rights reserved.



import UIKit

// MARK: - Operators
public extension String {
	
	/// : Repeat string multiple times.
	///
	///		'bar' * 3 -> "barbarbar"
	///
	/// - Parameters:
	///   - lhs: string to repeat.
	///   - rhs: number of times to repeat character.
	/// - Returns: new string with given string repeated n times.
	static func * (lhs: String, rhs: Int) -> String {
		guard rhs > 0 else {
			return ""
		}
		return String(repeating: lhs, count: rhs)
	}
	
	/// : Repeat string multiple times.
	///
	///		3 * 'bar' -> "barbarbar"
	///
	/// - Parameters:
	///   - lhs: number of times to repeat character.
	///   - rhs: string to repeat.
	/// - Returns: new string with given string repeated n times.
	static func * (lhs: Int, rhs: String) -> String {
		guard lhs > 0 else {
			return ""
		}
		return String(repeating: rhs, count: lhs)
	}
	
}

// MARK: - Initializers
public extension String {
	
	/// : Create a new string from a base64 string (if applicable).
	///
	///		String(base64: "SGVsbG8gV29ybGQh") = "Hello World!"
	///		String(base64: "hello") = nil
	///
	/// - Parameter base64: base64 string.
	init?(base64: String) {
		guard let str = base64.base64Decoded else {
			return nil
		}
		self.init(str)
	}
	
	/// : Create a new random string of given length.
	///
	///		String(randomOfLength: 10) -> "gY8r3MHvlQ"
	///
	/// - Parameter length: number of characters in string.
	init(randomOfLength length: Int) {
		self = String.random(ofLength: length)
	}
	
}

// MARK: - NSAttributedString extensions
public extension String {
	
	#if !os(tvOS) && !os(watchOS)
	/// : Bold string.
	///
	var bold: NSAttributedString {
		#if os(macOS)
			return NSMutableAttributedString(string: self, attributes: [.font: NSFont.boldSystemFont(ofSize: NSFont.systemFontSize)])
		#else
			return NSMutableAttributedString(string: self, attributes: [.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
		#endif
	}
	#endif
	
	/// : Underlined string
	///
	var underline: NSAttributedString {
        return NSAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
	}
	
	/// : Strikethrough string.
	///
	var strikethrough: NSAttributedString {
        return NSAttributedString(string: self, attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int)])
	}
	
	#if os(iOS)
	/// : Italic string.
	///
	var italic: NSAttributedString {
		return NSMutableAttributedString(string: self, attributes: [.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
	}
	#endif
	
	#if os(macOS)
	/// : Add color to string.
	///
	/// - Parameter color: text color.
	/// - Returns: a NSAttributedString versions of string colored with given color.
	func colored(with color: NSColor) -> NSAttributedString {
	return NSMutableAttributedString(string: self, attributes: [.foregroundColor: color])
	}
	#else
	/// : Add color to string.
	///
	/// - Parameter color: text color.
	/// - Returns: a NSAttributedString versions of string colored with given color.
	func colored(with color: UIColor) -> NSAttributedString {
		return NSMutableAttributedString(string: self, attributes: [.foregroundColor: color])
	}
	#endif
	
}

// MARK: - NSString extensions
public extension String {
	
	/// : NSString from a string.
	///
	var nsString: NSString {
		return NSString(string: self)
	}
	
	/// : NSString lastPathComponent.
	///
	var lastPathComponent: String {
		return (self as NSString).lastPathComponent
	}
	
	/// : NSString pathExtension.
	///
	var pathExtension: String {
		return (self as NSString).pathExtension
	}
	
	/// : NSString deletingLastPathComponent.
	///
	var deletingLastPathComponent: String {
		return (self as NSString).deletingLastPathComponent
	}
	
	/// : NSString deletingPathExtension.
	///
	var deletingPathExtension: String {
		return (self as NSString).deletingPathExtension
	}
	
	/// : NSString pathComponents.
	///
	var pathComponents: [String] {
		return (self as NSString).pathComponents
	}
	
	/// : NSString appendingPathComponent(str: String)
	///
	/// - Parameter str: the path component to append to the receiver.
	/// - Returns: a new string made by appending aString to the receiver, preceded if necessary by a path separator.
	func appendingPathComponent(_ str: String) -> String {
		return (self as NSString).appendingPathComponent(str)
	}
	
	/// : NSString appendingPathExtension(str: String)
	///
	/// - Parameter str: The extension to append to the receiver.
	/// - Returns: a new string made by appending to the receiver an extension separator followed by ext (if applicable).
	func appendingPathExtension(_ str: String) -> String? {
		return (self as NSString).appendingPathExtension(str)
	}
	
}
