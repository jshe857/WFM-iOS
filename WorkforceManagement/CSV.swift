//
//  CSV.swift
//  SwiftCSV
//
//  Created by naoty on 2014/06/09.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import UIKit

public class CSV {
    public let headers: [String] = []
    //public let rows: [Dictionary<String, String>] = []
    public let rows: [Array<String>] = []
    let delimiter = NSCharacterSet(charactersInString: ",")
    
    public init(csvString:String?, delimiter: NSCharacterSet) {
        var error: NSError?
        if let csvStringToParse = csvString {
            self.delimiter = delimiter
            
            let newline = NSCharacterSet.newlineCharacterSet()
            var lines: [String] = []
            csvStringToParse.stringByTrimmingCharactersInSet(newline).enumerateLines { line, stop in lines.append(line) }
            self.headers = self.parseHeaders(fromLines: lines)
            self.rows = self.parseRows(fromLines: lines)
        } else {
            NSLog("Failed to open file: \(error)")
            abort()
        }


    }

    
    func parseHeaders(fromLines lines: [String]) -> [String] {
        return lines[0].componentsSeparatedByCharactersInSet(self.delimiter)
    }
    
    //func parseRows(fromLines lines: [String]) -> [Dictionary<String, String>] {
    func parseRows(fromLines lines: [String]) -> [Array<String>] {

        //var rows: [Dictionary<String, String>] = []
        var rows  = Array<Array<String>>()
        
        for (lineNumber, line) in enumerate(lines) {
            if lineNumber == 0 {
                continue
            }
            
            //var row = Dictionary<String, String>()
            let values = line.componentsSeparatedByCharactersInSet(self.delimiter)
            
            //for (index, header) in enumerate(self.headers) {
                //let value = values[index]
                //row[header] = value
            //}
            
            
            var row = Array<String>()
            var quoteFound = false
            for field in values {
                if (!field.isEmpty) && field.hasPrefix("\"") {
                    quoteFound = true
                    row.append(field.substringFromIndex(field.startIndex.successor())+",")
                } else if (!field.isEmpty) && field.hasSuffix("\"") {
                    quoteFound = false
                    row[row.count-1] += field.substringToIndex(field.endIndex.predecessor())
                }else {
                    if (quoteFound) {
                        row[row.count-1]+=field
                    } else {
                       row.append(field)
                    }
                }

            }
            rows.append(row)
        }
        
        return rows
    }
}
