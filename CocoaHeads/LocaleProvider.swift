//
//  LocaleProvider.swift
//  CocoaHeads
//
//  Created by Wals, Donny on 20/02/2020.
//  Copyright © 2020 Donny Wals. All rights reserved.
//

import Foundation
import Combine

class LocaleProvider {
  typealias LocaleSubject = CurrentValueSubject<Locale, Never>

  lazy var localePublisher: LocaleSubject = {
    guard let localeString = userDefinedLocale else {
      return LocaleSubject(Locale.current)
    }

    return LocaleSubject(Locale(identifier: localeString))
  }()

  var userDefinedLocale: String? {
    get { UserDefaults.standard.string(forKey: "userLocale") }
    set {
      UserDefaults.standard.set(newValue, forKey: "userLocale")
      if let locale = newValue {
        localePublisher.value = Locale(identifier: locale)
      } else {
        localePublisher.value = Locale.current
      }
    }
  }
}
