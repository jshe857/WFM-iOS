//
//  CSV.swift
//  SwiftCSV
//
//


import CoreData
//TODO: make these prettier and probably not extensions
public extension String {
    func splitOnNewLine () -> ([String]) {
        return self.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
    }
}

public class CSV {
    public var headers = [String]()
    public var columnKeys = [String:[String:Int]]()
    public var currFilters : [String:String]?

    
    public var keyedRows: [[String : String]]?
    public var processedRows:[[String:String]]?
    
    public var db: FMDatabase = FMDatabase(path: nil)
    
    public init(String string: String, headers:[String]?, separator:String) {
        
        
        parse(String: string, headers: headers, separator: separator)
        self.processedRows = self.keyedRows
        
        
        
    }
    
    //TODO: Document that this assumes header string
    public convenience init(String string: String) {
        self.init(String: string, headers:nil, separator:",")
    }
    
    
    public func getColumnValues(column:String) ->[String] {
        if (columnKeys[column] != nil) {
            return columnKeys[column]!.keys.array.sorted {$0 < $1}
        }
        return []
    }
    
    public func getRows() ->[[String:String]] {
        if processedRows != nil {
            return processedRows!
        } else {
            return [[String:String]]()
        }
    }
    
    public func applyFilters([String:String]) {
        
    }
    
    public func update(string:String) {
        parse(String: string, headers:nil, separator:",")
    }
    
    public func getFilters()->[String:String]? {
        return self.currFilters
    }
    
    private func parse(String string: String, headers:[String]?, separator:String) {
        let lines : [String] = includeQuotedStringInFields(Fields:string.splitOnNewLine().filter{(includeElement: String) -> Bool in
            return !includeElement.isEmpty;
            } , "\r\n")
        
        var parsedLines = lines.map{
            (transform: String) -> [String] in
            let commaSanitized = includeQuotedStringInFields(Fields: transform.componentsSeparatedByString(separator) , separator)
                .map
                {
                    (input: String) -> String in
                    return sanitizedStringMap(String: input)
                }
                .map
                {
                    (input: String) -> String in
                    return input.stringByReplacingOccurrencesOfString("\"\"", withString: "\"", options: NSStringCompareOptions.LiteralSearch)
            }
            
            return commaSanitized;
        }
        
        if let unwrappedHeaders = headers {
            self.headers = unwrappedHeaders
        }
        else {
            self.headers = parsedLines[0]
            parsedLines.removeAtIndex(0)
        }
        
        var rows = parsedLines
        
//        self.keyedRows = rows.map{ (field :[String]) -> [String:String] in
//            
//            var row = [String:String]()
//            
//            for (index, value) in enumerate(field) {
//                row[self.headers[index]] = value
//            }
//            
//            return row
//        }

    }
    
}

//MARK: Helpers
func includeQuotedStringInFields(Fields fields: [String], quotedString :String) -> [String] {
    
    var mergedField = ""
    
    var newArray = [String]()
    
    for field in fields {
        mergedField += field
        if (mergedField.componentsSeparatedByString("\"").count%2 != 1) {
            mergedField += quotedString
            continue
        }
        newArray.append(mergedField);
        mergedField = ""
    }
    
    return newArray;
}


func sanitizedStringMap(String string :String) -> String {
    
    let doubleQuote : String = "\""
    
    let startsWithQuote: Bool = string.hasPrefix("\"");
    let endsWithQuote: Bool = string.hasSuffix("\"");
    
    if (startsWithQuote && endsWithQuote) {
        let startIndex = advance(string.startIndex, 1)
        let endIndex = advance(string.endIndex,-1)
        let range = startIndex ..< endIndex
        
        let sanitizedField: String = string.substringWithRange(range)
        
        return sanitizedField
    }
    else {
        return string;
    }
    
}






