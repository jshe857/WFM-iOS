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
    private var columnKeys = [String:[String:Int]]()
    private var currFilters = [String:String]()
    private var processedRows:[[NSObject:AnyObject]]?
   
    let db = FMDatabase(path: nil)
    let schema = "(serial TEXT PRIMARY KEY, name TEXT, band INTEGER, home TEXT, jrss TEXT, project TEXT, availability TEXT, business TEXT, availWks INTEGER, manager TEXT)"

    
    public init(String string: String, headers:[String]?, separator:String) {
        
        if !db.open() {
            println("Unable to open database")
            exit(1)
        }
        
        if !db.executeUpdate("CREATE TABLE practitioners\(schema)", withArgumentsInArray: nil) {
            println("create table failed: \(db.lastErrorMessage())")
        }

        parse(String: string, headers: headers, separator: separator)
        let results = db.executeQuery("SELECT * FROM practitioners ORDER BY name",withArgumentsInArray:nil)
        self.processedRows = [[NSObject:AnyObject]]()
        if results != nil {
            while results!.next() {
                processedRows!.append(results!.resultDictionary())
            }
        }
        
        
        
    }
    
    //TODO: Document that this assumes header string
    public convenience init(String string: String) {
        self.init(String: string, headers:nil, separator:",")
    }
    
    
    public func getColumnValues(column:String) ->[String] {
        var values = [String]()
        let results = db.executeQuery("SELECT DISTINCT \(column) FROM practitioners ORDER BY \(column)",withArgumentsInArray:nil)
        if results != nil {
            while results!.next() {
                if results!.stringForColumnIndex(0) != "" {
                    values.append(results!.stringForColumnIndex(0))
                }
            }
        }
        return values
    }
    
    public func getRow(index:Int) ->[String:String]{
        var dict  = [String:String]()
        if processedRows != nil {
            let row = processedRows![index]
            for (key,val) in row {
                if let num = val as? Int {
                    dict[key as String] = String(num)
                } else {
                    dict[key as String] = val as? String
                }
            }
        }
        return dict
    }

    public func getCount() -> Int {
        var count = 0
        if processedRows != nil {
            return processedRows!.count
        }
        return count
    }
    
    public func applyFilters(filter:[String:String]) {
        var filterSql = "SELECT * FROM practitioners"
        if (filter.count > 0) {
            filterSql += " WHERE "
            for (key,val) in filter {
                if key != "availWks" || key != "band" {
                    filterSql+="\(key)='\(val)'"
                    filterSql+=" AND "
                } else {
                    filterSql+="\(key)=\(val)"
                    filterSql+=" AND "
                }
            }

            filterSql = filterSql.substringToIndex(advance(filterSql.startIndex, countElements(filterSql)-5))

        }
        
        filterSql += " ORDER BY name"
        let results = db.executeQuery(filterSql, withArgumentsInArray:nil)
        self.processedRows = [[NSObject:AnyObject]]()
        if results != nil {
            while results!.next() {
                processedRows!.append(results!.resultDictionary())
            }
        }
        currFilters = filter

    }
    
    public func update(string:String) {

        db.executeUpdate("DROP TABLE practitioners IF EXISTS",withArgumentsInArray:nil)
        if !db.executeUpdate("CREATE TABLE practitioners\(schema)", withArgumentsInArray: nil) {
            println("create table failed: \(db.lastErrorMessage())")
        }

        parse(String: string, headers:nil, separator:",")
    }
    
    public func getFilters()->[String:String]? {
        return self.currFilters
    }
    
    public func search(search:String) {
        
        let results = db.executeQuery("SELECT * FROM practitioners WHERE name LIKE '%\(search)%'",withArgumentsInArray:nil)
        self.processedRows = [[NSObject:AnyObject]]()
        if results != nil {
            while results!.next() {
                processedRows!.append(results!.resultDictionary())
            }
        }

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
        
        }else {
            parsedLines.removeAtIndex(0)
        }
        
        var rows = parsedLines

        if db.beginTransaction() {
            
            for row in rows {
                if !db.executeUpdate("INSERT INTO practitioners values (?,?,?,?,?,?,?,?,?,?)",withArgumentsInArray:[row[0],row[1],row[2].toInt()!,row[3],row[5],row[6],row[11],row[14],row[17].toInt()!,row[23]]) {
                    println("error occurred")
                }
            }
            if !db.commit() {
                println("failed to commit db transaction")
            }
        }

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






