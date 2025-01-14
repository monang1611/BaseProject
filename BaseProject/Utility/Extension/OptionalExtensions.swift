//
//  OptionalExtensions.swift
//  Copyright © 2023 Meet,Monang,Nilomi . All rights reserved.



// MARK: - Operators
infix operator ??= : AssignmentPrecedence

public extension Optional {
	
	/// : Get self of default value (if self is nil).
	///
	///		let foo: String? = nil
	///		print(foo.unwrapped(or: "bar")) -> "bar"
	///
	///		let bar: String? = "bar"
	///		print(bar.unwrapped(or: "foo")) -> "bar"
	///
	/// - Parameter defaultValue: default value to return if self is nil.
	/// - Returns: self if not nil or default value if nil.
	func unwrapped(or defaultValue: Wrapped) -> Wrapped {
		// http://www.russbishop.net/improving-optionals
		return self ?? defaultValue
	}
	
	/// : Runs a block to Wrapped if not nil
	///
	///		let foo: String? = nil
	///		foo.run { unwrappedFoo in
	///			// block will never run sice foo is nill
	///			print(unwrappedFoo)
	///		}
	///
	///		let bar: String? = "bar"
	///		bar.run { unwrappedBar in
	///			// block will run sice bar is not nill
	///			print(unwrappedBar) -> "bar"
	///		}
	///
	/// - Parameter block: a block to run if self is not nil.
	func run(_ block: (Wrapped) -> Void) {
		// http://www.russbishop.net/improving-optionals
		_ = self.map(block)
	}
	
    /// : Assign an optional value to a variable only if the value is not nil.
    ///
    ///     let someParameter: String? = nil
    ///     let parameters = [String:Any]() //Some parameters to be attached to a GET request
    ///     parameters[someKey] ??= someParameter //It won't be added to the parameters dict
    ///
    /// - Parameters:
    ///   - lhs: Any?
    ///   - rhs: Any?
    static func ??= (lhs: inout Optional, rhs: Optional) {
        guard let rhs = rhs else { return }
        lhs = rhs
    }
}
