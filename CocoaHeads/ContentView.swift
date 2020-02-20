//
//  ContentView.swift
//  CocoaHeads
//
//  Created by Wals, Donny on 16/02/2020.
//  Copyright © 2020 Donny Wals. All rights reserved.
//

import SwiftUI
import Combine

struct SampleView: View {
  @ObservedObject private var strings: Strings

  @State private var username: String = ""
  @State private var password: String = ""

  init(localizer: Localizer) {
    self.strings = Strings(localizer: localizer)
  }

  var body: some View {
    NavigationView {
      Form(content: {
        Section(header: Text(strings.username)) {
          TextField(strings.username, text: $username)
        }

        Section(header: Text(strings.password)) {
          TextField(strings.password, text: $username)
        }

        Button(action: {}, label: { Text(strings.login) })
      })
        .navigationBarTitle(strings.login)
        .navigationBarItems(trailing: Button(action: {
          if localeProvider.userDefinedLocale == "nl_NL" {
            localeProvider.userDefinedLocale = "en_US"
          } else {
            localeProvider.userDefinedLocale = "nl_NL"
          }
        }, label: {
          Image(systemName: "arrow.counterclockwise")
        }))
    }
  }
}

extension SampleView {
  private class Strings: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var login: String = ""

    var cancellables = Set<AnyCancellable>()

    init(localizer: Localizer) {
      localizer("form_field_username")
        .sink(receiveValue: { [weak self] in
          self?.username = $0 ?? "--"
        })
        .store(in: &cancellables)

      localizer("form_field_password")
      .sink(receiveValue: { [weak self] in
        self?.password = $0 ?? "--"
      })
      .store(in: &cancellables)

      localizer("header_login")
        .sink(receiveValue: { [weak self] in
          self?.login = $0 ?? "--"
        })
        .store(in: &cancellables)
    }
  }
}
