//
//  Lozalizer.swift
//  CocoaHeads
//
//  Created by Wals, Donny on 20/02/2020.
//  Copyright © 2020 Donny Wals. All rights reserved.
//

import Foundation
import Combine

let strings = """
{
  "header_login": {
    "default": "Login",
    "en": "Login",
    "nl": "Inloggen"
  },
  "form_field_username": {
    "default": "Username",
    "en": "Username",
    "nl": "Gebruikersnaam"
  },
  "form_field_password": {
    "default": "Password",
    "en": "Password",
    "nl": "Wachtwoord"
  }
}
""".data(using: .utf8)!

class Localizer {
  typealias StringsDict = [String: [String: String]]
  typealias LocalizedString = CurrentValueSubject<String?, Never>

  private let strings: StringsDict
  private let localeProvider: LocaleProvider
  private var subjects = [String: LocalizedString]()

  var cancellables = Set<AnyCancellable>()

  init(with data: Data, localeProvider: LocaleProvider) throws {
    self.strings = try JSONDecoder().decode(StringsDict.self, from: data)
    self.localeProvider = localeProvider

    localeProvider.localePublisher
      .sink(receiveValue: { [weak self] locale in
        self?.updateSubjects(for: locale)
      })
      .store(in: &cancellables)
  }

  private func translationForKey(_ key: String, using locale: Locale) -> String? {
    guard let string = strings[key]
      else { return nil }

    let languageCode = locale.languageCode ?? "default"
    return string[languageCode] ?? string["default"]
  }

  private func updateSubjects(for locale: Locale) {
    subjects.forEach({ key, subject in
      subject.value = translationForKey(key, using: locale)
    })
  }

  func callAsFunction(_ key: String) -> LocalizedString {
    guard let subject = subjects[key] else {
      let string = translationForKey(key, using: localeProvider.localePublisher.value)

      let subject = LocalizedString(string)
      subjects[key] = subject

      return subject
    }

    return subject
  }
}
