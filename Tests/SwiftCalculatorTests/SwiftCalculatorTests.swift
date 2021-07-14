import XCTest
import class Foundation.Bundle

final class SwiftCalculatorTests: XCTestCase {
    
    func testAddNumbers() throws {
        let guess = "(add 1 1)"
        
        let result = try calculate(input: guess)
        
        XCTAssertEqual(result, "2")
    }
    
    func testAddFunction() throws {
        let guess = "(add 0 (add 3 4))"
        
        let result = try calculate(input: guess)
        
        XCTAssertEqual(result, "7")
    }
    
    func testAddNestedFunctions() throws {
        let guess = "(add 3 (add (add 3 3) 3))"
        
        let result = try calculate(input: guess)
        
        XCTAssertEqual(result, "12")
    }
    
    func testMultiplyNumbers() throws {
        let guess = "(multiply 1 1)"
        
        let result = try calculate(input: guess)
        
        XCTAssertEqual(result, "1")
    }
    
    func testMultiplyFunction() throws {
        let guess = "(multiply 2 (multiply 3 4))"
        
        let result = try calculate(input: guess)
        
        XCTAssertEqual(result, "24")
    }
    
    func testMultiplyFunctionZero() throws {
        let guess = "(multiply 0 (multiply 3 4))"
        
        let result = try calculate(input: guess)
        
        XCTAssertEqual(result, "0")
    }
    
    func testMultiplyNestedFunctions() throws {
        let guess = "(multiply 3 (multiply (multiply 3 3) 3))"
        
        let result = try calculate(input: guess)
        
        XCTAssertEqual(result, "81")
    }
    
    func testCombinedFunctions() throws {
        let guess = "(add 1 (multiply 2 3))"
        
        let result = try calculate(input: guess)
        
        XCTAssertEqual(result, "7")
    }
    
    func testCombinedNestedFunctions() throws {
        let guess = "(multiply 2 (add (multiply 2 3) 8))"
        
        let result = try calculate(input: guess)
        
        XCTAssertEqual(result, "28")
    }
    
    private func calculate(input : String) throws -> String? {
        guard #available(macOS 10.13, *) else {
            return nil
        }

        let fooBinary = productsDirectory.appendingPathComponent("SwiftCalculator")

        let process = Process()
        process.executableURL = fooBinary
        process.arguments = [input]

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .newlines)
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testExample", testAddNumbers,testAddFunction,testAddNestedFunctions,testMultiplyNumbers,testMultiplyFunction,testMultiplyFunctionZero,testMultiplyNestedFunctions,testCombinedFunctions,testCombinedNestedFunctions),
    ]
}
