//
//  CSV.swift
//  SwiftCSV
//
//


import CoreData


public class CSV {
    public var headers = [String]()
    public var allRows = [Dictionary<String,String>]()
    public var processedRows = [Dictionary<String,String>]()
    public var columnKeys = [String:[String:Int]]()
    public var currFilters = [String:String]()
    
    
    
    let delimiter = NSCharacterSet(charactersInString: ",")

    public init(csvString:String?, delimiter: NSCharacterSet,filters:[String:String]?) {
        let context = NSManagedObjectContext()
        var error: NSError?
        if let csvStringToParse = csvString {
            self.delimiter = delimiter
            
            let newline = NSCharacterSet.newlineCharacterSet()
            var lines: [String] = []
            csvStringToParse.stringByTrimmingCharactersInSet(newline).enumerateLines { line, stop in lines.append(line) }
            
            self.headers = self.parseHeaders(fromLines: lines)
            self.allRows = self.parseRows(fromLines: lines)
            if filters != nil {
                self.currFilters = filters!
                self.processedRows = filterRows()
            } else {
                self.processedRows = allRows
            }
        } else {
            NSLog("Failed to open file: \(error)")
            abort()
        }
    }
    private func filterRows () -> [Dictionary<String,String>]{
        var filtered = [Dictionary<String,String>]()
        for row in allRows {
            filtered.append(row)
            for (filter,val) in currFilters {
                if row[filter] != val {
                    filtered.removeLast()
                    break
                }
            }
        }
        return filtered
    }
    public func applyFilters() {
        processedRows = filterRows()
    }
    
    func parseHeaders(fromLines lines: [String]) -> [String] {
        return lines[0].componentsSeparatedByCharactersInSet(self.delimiter)
    }
    
    func parseRows(fromLines lines: [String]) -> [Dictionary<String, String>] {
        var rows: [Dictionary<String, String>] = []
        for (lineNumber, line) in enumerate(lines) {
            if lineNumber == 0 {
                continue
            }

            var row = Dictionary<String, String>()
            let values = line.componentsSeparatedByCharactersInSet(self.delimiter)
            var quoteFound = false
            var index = 0
            for field in values {
                //handling commas within quotes
                let col = headers[index]
                if  field == "" {
                    row[col] = "Blank"
                    index++
                    continue
                }
                
                if (!field.isEmpty) && field.hasPrefix("\"") {
                    quoteFound = true
                    row[col] = field.substringFromIndex(field.startIndex.successor())+","
                    
                } else if (!field.isEmpty) && field.hasSuffix("\"") {
                    quoteFound = false
                    row[col]! += field.substringToIndex(field.endIndex.predecessor())
                    index++
                    
                    if columnKeys[col] == nil {
                        columnKeys[col] = [String:Int]()
                    }
                    columnKeys[col]![row[col]!] = 1
                    
                } else if (quoteFound) {
                    row[col]! += field
                    
                //normal assignement
                } else {
                    row[col] = field
                    index++
                    if columnKeys[col] == nil {
                        columnKeys[col] = [String:Int]()
                    }
                    columnKeys[col]![row[col]!] = 1
                }
            }
            rows.append(row)
            
        }
        
        return rows
    }
    public func getColumnValues(column:String) ->[String] {
        if (columnKeys[column] != nil) {
            return columnKeys[column]!.keys.array.sorted {$0 < $1}
        }
        return []
    }
    
    public func getRows() ->[Dictionary<String,String>]{
        return processedRow
    }
    
    
}
