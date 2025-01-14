//
//  IntExtensions.swift
//  Copyright © 2023 Meet,Monang,Nilomi . All rights reserved.



import CoreGraphics

// MARK: - Properties
public extension Int {
	
	/// : CountableRange 0..<Int.
	var countableRange: CountableRange<Int> {
		return 0..<self
	}
	
	/// : Radian value of degree input.
	var degreesToRadians: Double {
		return Double.pi * Double(self) / 180.0
	}
	
	/// : Degree value of radian input
	var radiansToDegrees: Double {
		return Double(self) * 180 / Double.pi
	}
	
	/// : UInt.
	var uInt: UInt {
		return UInt(self)
	}
	
	/// : Double.
	var double: Double {
		return Double(self)
	}
	
	/// : Float.
	var float: Float {
		return Float(self)
	}
	
	/// : CGFloat.
	var cgFloat: CGFloat {
		return CGFloat(self)
	}
	
	/// : String formatted for values over ±1000 (example: 1k, -2k, 100k, 1kk, -5kk..)
	var kFormatted: String {
		var sign: String {
			return self >= 0 ? "" : "-"
		}
		let abs = Swift.abs(self)
		if abs == 0 {
			return "0k"
		} else if abs >= 0 && abs < 1000 {
			return "0k"
		} else if abs >= 1000 && abs < 1000000 {
			return String(format: "\(sign)%ik", abs / 1000)
		}
		return String(format: "\(sign)%ikk", abs / 100000)
	}
	
}

// MARK: - Methods
public extension Int {
	
	/// : Random integer between two integer values.
	///
	/// - Parameters:
	///   - min: minimum number to start random from.
	///   - max: maximum number random number end before.
	/// - Returns: random double between two double values.
	static func random(between min: Int, and max: Int) -> Int {
		return random(inRange: min...max)
	}
	
	/// : Random integer in a closed interval range.
	///
	/// - Parameter range: closed interval range.
	/// - Returns: random double in the given closed range.
	static func random(inRange range: ClosedRange<Int>) -> Int {
		let delta = UInt32(range.upperBound - range.lowerBound + 1)
		return range.lowerBound + Int(arc4random_uniform(delta))
	}

	/// : check if given integer prime or not.
	/// Warning: Using big numbers can be computationally expensive!
	/// - Returns: true or false depending on prime-ness
	func isPrime() -> Bool {
		// To improve speed on latter loop :)
		if self == 2 {
		    return true
		}
		
		guard self > 1 && self % 2 != 0 else {
                    return false
                }
		// Explanation: It is enough to check numbers until
		// the square root of that number. If you go up from N by one,
		// other multiplier will go 1 down to get similar result
		// (integer-wise operation) such way increases speed of operation
		let base = Int(sqrt(Double(self)))
		for i in Swift.stride(from: 3, through: base, by: 2) where self % i == 0 {
			return false
		}
		return true
	}
	
	/// : Roman numeral string from integer (if applicable).
	///
	///		10.romanNumeral() -> "X"
	///
	/// - Returns: The roman numeral string.
	func romanNumeral() -> String? {
		// https://gist.github.com/kumo/a8e1cb1f4b7cff1548c7
		guard self > 0 else { // there is no roman numerals for 0 or negative numbers
			return nil
		}
		let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
		let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
		
		var romanValue = ""
		var startingValue = self
		
		for (index, romanChar) in romanValues.enumerated() {
			let arabicValue = arabicValues[index]
			let div = startingValue / arabicValue
			if div > 0 {
				for _ in 0..<div {
					romanValue += romanChar
				}
				startingValue -= arabicValue * div
			}
		}
		return romanValue
	}

}

// MARK: - Initializers
public extension Int {
	
	/// : Created a random integer between two integer values.
	///
	/// - Parameters:
	///   - min: minimum number to start random from.
	///   - max: maximum number random number end before.
	init(randomBetween min: Int, and max: Int) {
		self = Int.random(between: min, and: max)
	}
	
	/// : Create a random integer in a closed interval range.
	///
	/// - Parameter range: closed interval range.
	init(randomInRange range: ClosedRange<Int>) {
		self = Int.random(inRange: range)
	}
	
}

// MARK: - Operators

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ** : PowerPrecedence
/// : Value of exponentiation.
///
/// - Parameters:
///   - lhs: base integer.
///   - rhs: exponent integer.
/// - Returns: exponentiation result (example: 2 ** 3 = 8).
public func ** (lhs: Int, rhs: Int) -> Double {
	// http://nshipster.com/swift-operators/
	return pow(Double(lhs), Double(rhs))
}

prefix operator √
/// : Square root of integer.
///
/// - Parameter int: integer value to find square root for
/// - Returns: square root of given integer.
public prefix func √ (int: Int) -> Double {
	// http://nshipster.com/swift-operators/
	return sqrt(Double(int))
}

infix operator ±
/// : Tuple of plus-minus operation.
///
/// - Parameters:
///   - lhs: integer number.
///   - rhs: integer number.
/// - Returns: tuple of plus-minus operation (example: 2 ± 3 -> (5, -1)).
public func ± (lhs: Int, rhs: Int) -> (Int, Int) {
	// http://nshipster.com/swift-operators/
	return (lhs + rhs, lhs - rhs)
}

prefix operator ±
/// : Tuple of plus-minus operation.
///
/// - Parameter int: integer number
/// - Returns: tuple of plus-minus operation (example: ± 2 -> (2, -2)).
public prefix func ± (int: Int) -> (Int, Int) {
	// http://nshipster.com/swift-operators/
	return 0 ± int
}
