//
//  String+Currency.swift
//  CarApp
//
//  Created by Lucas Santiago on 26/09/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import Foundation

extension String {
    
    static let whitespace = " "
    private static let nonBreakLineWhitespace = " "
    
    /**
     Converts the currency string into a double-valid format to be parsed as double
     */
    private var cleanCurrencyFormat: String {
        let stringWithAllSeparators = remove(currencySymbol: .ptBR).replacingOccurrences(of: ",", with: ".")
        let groups = stringWithAllSeparators.split(separator: ".")
        if groups.count <= 1 {
            // "123".. No decimal grouping can be formed here
            return groups.joined()
        }
        
        if groups.count == 2 {
            return groups.joined(separator: ".")
        }
        
        if let lastGroup = groups.last, lastGroup.count > 1 {
            // "133.581.591.11"... all with more than 1 group
            // "12.1",  "133581491.11" <- resulting conversions
            let integers = groups.dropLast().joined()
            let decimals = lastGroup
            return integers + "." + decimals
        }
        
        return "0.0"
    }
    
    var doubleValue: Double {
        let styler = NumberFormatter()
        styler.minimumFractionDigits = 2
        styler.maximumFractionDigits = 2
        styler.numberStyle = .decimal
        
        let converter = NumberFormatter()
        converter.decimalSeparator = ","
        
        if let result = converter.number(from: self) {
            return result.doubleValue
        } else {
            converter.decimalSeparator = "."
            if let result = converter.number(from: self) {
                return result.doubleValue
            }
        }
        
        return 0.0
    }
    
    /**
     Gets the value for this currency string as a double
     Accepts:
     - currency formated: "R$ 19,99"
     - number formatted: "9,99"
     - number with dot: "9.99"
     - returns: The double value representing the string. Zero (0.0) if can't convert.
     */
    var currencyDoubleValue: Double {
        return cleanCurrencyFormat.doubleValue
    }
    
    /**
     Gets the value for the currency string without the currency symbol
     */
    var currencyStringValue: String {
        return currencyFormat().remove(currencySymbol: .ptBR)
    }
    
    
    
    /**
     Convert the number string to a currency one. Adding the current currency symbol to it.
     - parameter minimumFractionDigits: Amount of digits representing cents. Default = 2
     - returns: The currency string with symbolicated value, e.g: "R$ 9,99"
     */
    func currencyFormat(minimumFractionDigits: Int = 2) -> String {
        let formatter: NumberFormatter = NumberFormatter.currencyFormatter
        formatter.minimumFractionDigits = minimumFractionDigits
        let doubleValue = currencyDoubleValue
        let number = NSNumber(value: doubleValue)
        let formattedString = formatter.string(from: number)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: String.nonBreakLineWhitespace, with: String.whitespace)
        return formattedString!
    }
    
    /**
     Format the inputed string as currency string with symbol
     - parameter default: The default value if input is not a NUMBER. Default = ""
     - returns: The currency string with symbolicated value, e.g: "R$ 9,99"
     */
    func currencyInputFormatting(default defaultValue: String = "") -> String {
        var amountWithPrefix = self
        let regex = try? NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex!.stringByReplacingMatches(in: amountWithPrefix,
                                                           options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                           range: NSRange(location: 0, length: self.count),
                                                           withTemplate: "")
        let double = (amountWithPrefix as NSString).doubleValue / 100 * (self.contains("-") ? -1 : 1)
        return double.currencyFormat()
    }
    
    /**
     Returns the formatted value for the currency string without the currency symbol
     */
    func currencyInputFormattingString(default defaultValue: String = "") -> String {
        return currencyInputFormatting().remove(currencySymbol: .ptBR)
    }
    
    var digits: [UInt8] {
        return map(String.init).compactMap(UInt8.init)
    }
    
    /**
     Remove a given currency symbol
     - parameter default: The default value if input is not a NUMBER. Default = ""
     - returns: The currency string with symbolicated value, e.g: "R$ 9,99"
     */
    func remove(currencySymbol: CurrencySymbol) -> String {
        return self
            .replacingOccurrences(of: currencySymbol.rawValue, with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}

extension Double {
    
    func currencyFormat(minimumFractionDigits: Int = 2) -> String {
        return "\(self)".currencyFormat(minimumFractionDigits: minimumFractionDigits)
    }
    
    var currencyStringValue: String {
        return self.currencyFormat().remove(currencySymbol: .ptBR)
    }
    
    func currencyValueFromCentsFormatting() -> String {
        let value = self / 100.0
        return value.currencyStringValue
    }
}

enum CurrencySymbol: String {
    case ptBR = "R$"
}

extension NumberFormatter {
    convenience init(numberStyle: Style) {
        self.init()
        self.numberStyle = numberStyle
    }
    
    static var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter(numberStyle: .currency)
        if #available(iOS 12.0, *) {
            formatter.currencySymbol = CurrencySymbol.ptBR.rawValue
        } else {
            formatter.currencySymbol = CurrencySymbol.ptBR.rawValue + String.whitespace
        }
        formatter.allowsFloats = true
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }
}
