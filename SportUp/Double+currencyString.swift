//
//  Double+currencyString.swift
//  SportUp
//
//  Created by Алексей on 26.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation

extension Double {
  var currencyString: String {
    let currencyFormatter = NumberFormatter()

    let localeIdentifier = "ru_RU"
    currencyFormatter.numberStyle = NumberFormatter.Style.currency
    currencyFormatter.locale = Locale(identifier: localeIdentifier)
    currencyFormatter.minimumFractionDigits = 0
    currencyFormatter.maximumFractionDigits = 0
    return currencyFormatter.string(from: self as NSNumber) ?? ""
  }

}

extension Decimal {
  var currencyString: String {
    let currencyFormatter = NumberFormatter()

    let localeIdentifier = "ru_RU"
    currencyFormatter.numberStyle = NumberFormatter.Style.currency
    currencyFormatter.locale = Locale(identifier: localeIdentifier)
    currencyFormatter.minimumFractionDigits = 0
    currencyFormatter.maximumFractionDigits = 0
    return currencyFormatter.string(from: NSDecimalNumber(decimal: self)) ?? ""
  }
}
