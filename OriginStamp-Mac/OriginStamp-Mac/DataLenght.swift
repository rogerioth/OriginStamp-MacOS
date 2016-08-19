//
//  DataLenght.swift
//  OriginStamp-Mac
//
//  Created by Rogerio Hirooka on 8/11/16.
//  Copyright © 2016 Rogerio Hirooka. All rights reserved.
//

import Foundation

class DataLength {
    static let DL_AUTO: Float = 0.0
    static let DL_BYTES: Float = 1.0
    static let DL_KB: Float = 1024.0
    static let DL_MB: Float = 1048576.0
    static let DL_GB: Float = 1073741824.0
    static let DL_TB: Float = 1099511627776.0
    static let DL_PB: Float = 1125899906842624.0
    static let DL_Un: Float = 1.0
    static let DL_KUn: Float = 1000.0
    static let DL_MUn: Float = 1000000.0
    static let DL_GUn: Float = 1000000000.0
    static let DL_TUn: Float = 1000000000000.0
    static let DL_PUn: Float = 1000000000000000.0
    static var formatter: NSNumberFormatter? = nil
    
    static func getFormatter() -> NSNumberFormatter {
        if (formatter == nil) {
            formatter = NSNumberFormatter()
            formatter!.groupingSize = 3
            formatter!.usesGroupingSeparator = true
        }
        return formatter!
    }
    
    static func bytesToMultipleStringFromLong(input: Int,
                                             targetUnit unit: Float,
                                                        numberOfDecimals decimals: Int) -> String {
        return self.bytesToMultipleString(Float(input),
                                          targetUnit: unit,
                                          numberOfDecimals: decimals,
                                          breakUnit: false)
    }
    
    static func bytesToMultipleStringFromLong(input: Int,
                                             targetUnit unit: Float,
                                             numberOfDecimals decimals: Int,
                                             breakUnit: Bool) -> String {
        
        let retVal: String = self.bytesToMultipleString(Float(input),
                                                        targetUnit: unit,
                                                        numberOfDecimals: decimals,
                                                        breakUnit: breakUnit,
                                                        ommitUnit: false)
        return retVal
    }
    
    static func bytesToMultipleStringFromUInt64(input: UInt64,
                                               targetUnit unit: Float,
                                               numberOfDecimals decimals: Int,
                                               breakUnit: Bool) -> String {
        let retVal: String = self.bytesToMultipleString(Float(input),
                                                        targetUnit: unit,
                                                        numberOfDecimals: decimals,
                                                        breakUnit: breakUnit,
                                                        ommitUnit: false)
        return retVal
    }
    
    static func bytesToMultipleString(input: Float, targetUnit unit: Float, numberOfDecimals decimals: Int) -> String {
        return self.bytesToMultipleString(input,
                                          targetUnit: unit,
                                          numberOfDecimals: decimals,
                                          breakUnit: false,
                                          ommitUnit: false)
    }
    
    static func bytesToMultipleString(input: Float, targetUnit unit: Float, numberOfDecimals decimals: Int, breakUnit: Bool) -> String {
        let retVal: String = self.bytesToMultipleString(input,
                                                        targetUnit: unit,
                                                        numberOfDecimals: decimals,
                                                        breakUnit: breakUnit,
                                                        ommitUnit: false)
        return retVal
    }
    
    static func bytesToMultipleString(input: Float,
                                      targetUnit unit: Float,
                                      numberOfDecimals decimals: Int,
                                      breakUnit: Bool,
                                      ommitUnit: Bool) -> String {
        var preResult: Float = 0
        var targetUnit = unit
        var targetDecimals = decimals
        if unit == DL_AUTO {
            if input < DL_KB {
                targetUnit = DL_BYTES
            }
            else if input < DL_MB {
                targetUnit = DL_KB
            }
            else if input < DL_GB {
                targetUnit = DL_MB
            }
            else if input < DL_TB {
                targetUnit = DL_GB
            }
            else if input < DL_PB {
                targetUnit = DL_TB
            }
            else {
                targetUnit = DL_PB
            }
        }
        
        var stringUnit = ""
        if targetUnit == DL_BYTES {
            stringUnit = "bytes"
        }
        else if targetUnit == DL_KB {
            stringUnit = "KB"
        }
        else if targetUnit == DL_MB {
            stringUnit = "MB"
        }
        else if targetUnit == DL_GB {
            stringUnit = "GB"
        }
        else if targetUnit == DL_TB {
            stringUnit = "TB"
        }
        else if targetUnit == DL_PB {
            stringUnit = "PB"
        }
        
        preResult = input / targetUnit
        if targetUnit == DL_BYTES {
            targetDecimals = 0
        }
        
        let form: NSNumberFormatter = self.getFormatter()
        form.minimumFractionDigits = targetDecimals
        form.maximumFractionDigits = targetDecimals
        let format1: String = "%@ %@"
        let format2: String = "%@\n%@"
        if ommitUnit {
            stringUnit = ""
        }
        
        return String(format: breakUnit ? format2 : format1, form.stringFromNumber(preResult)!, stringUnit)
    }
    
    static func multipleString(input: Float, targetUnit unit: Float, numberOfDecimals decimals: Int, unitSymbol: String) -> String {
        var preResult: Float = 0
        var targetUnit = unit
        var targetDecimals = decimals

        if unit == DL_AUTO {
            if input < DL_KUn {
                targetUnit = DL_Un
            }
            else if input < DL_MUn {
                targetUnit = DL_KUn
            }
            else if input < DL_GUn {
                targetUnit = DL_MUn
            }
            else if input < DL_TUn {
                targetUnit = DL_GUn
            }
            else if input < DL_PUn {
                targetUnit = DL_TUn
            }
            else {
                targetUnit = DL_PUn
            }
        }
        
        var stringUnit = ""
        if targetUnit == DL_Un {
            stringUnit = ""
        }
        else if targetUnit == DL_KUn {
            stringUnit = "K"
        }
        else if targetUnit == DL_MUn {
            stringUnit = "M"
        }
        else if targetUnit == DL_GUn {
            stringUnit = "G"
        }
        else if targetUnit == DL_TUn {
            stringUnit = "T"
        }
        else if targetUnit == DL_PUn {
            stringUnit = "P"
        }
        
        preResult = input / targetUnit
        if targetUnit == DL_KUn {
            targetDecimals = 0
        }
        let form: NSNumberFormatter = self.getFormatter()
        form.minimumFractionDigits = targetDecimals
        form.maximumFractionDigits = targetDecimals
        let format1: String = "%@ %@%@"
        return String(format: format1, form.stringFromNumber(preResult)!, stringUnit, unitSymbol)
    }
    
    static func decimalString(input: Float, numberOfDecimals decimals: Int) -> String {
        let form: NSNumberFormatter = self.getFormatter()
        form.minimumFractionDigits = decimals
        form.maximumFractionDigits = decimals
        return "\(form.stringFromNumber(Int(input)))"
    }
    
    static func decimalStringFromLong(input: Int, numberOfDecimals decimals: Int) -> String {
        let form: NSNumberFormatter = self.getFormatter()
        form.minimumFractionDigits = decimals
        form.maximumFractionDigits = decimals
        return "\(form.stringFromNumber(Int(input)))"
    }
    
    
}