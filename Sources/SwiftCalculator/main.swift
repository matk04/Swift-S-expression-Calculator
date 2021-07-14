
import Foundation

if CommandLine.arguments.count > 1 {
    let expression = CommandLine.arguments[1]
    
    let parser = Parser()
    
    if let result = try? parser.evaluate(expression: expression) {
        print(result)
    }else{
        exit(1)
    }
}else{
    exit(1)
}




