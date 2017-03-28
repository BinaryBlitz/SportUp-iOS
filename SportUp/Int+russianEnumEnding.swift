//
//  Int+russianEnumEnding.swift
//  SportUp
//
//  Created by Алексей on 28.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

/*
 Склонять падежи существительных, находящихся после числительных (актуально для русского языка)
 "слово", "слова", "слов" // Необходимо передать 3 возможных окончания
 */

import Foundation

extension Int {
  func getRussianNumEnding(endings: [String]) -> String {
    let number = self % 100

    var ending: String
    if number >= 11 && number <= 19 {
      ending = endings[2]
    } else {
      switch number % 10 {
      case 1:
        ending = endings[0]
      case 2 ... 4:
        ending = endings[1]
      default:
        ending = endings[2]
      }
    }
    return "\(self) " + ending
  }
}
