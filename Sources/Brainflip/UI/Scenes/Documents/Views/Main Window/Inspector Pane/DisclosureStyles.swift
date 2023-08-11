// DisclosureStyles.swift
// Copyright © 2023 Kaleb A. Ascevich
//
// This app is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This app is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
// for more details.
//
// You should have received a copy of the GNU General Public License along
// with this app. If not, see https://www.gnu.org/licenses/.

import SwiftUI

struct DisclosureToggleStyle: ToggleStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            #symbolImage("chevron.forward")
                .rotationEffect(configuration.isOn ? Angle(degrees: 90) : Angle.zero)
                .animation(reduceMotion ? nil : .spring(duration: 0.75, bounce: 0.5), value: configuration.isOn)
                .symbolVariant(.circle)
        }
        .buttonStyle(.plain)
    }
}

extension ToggleStyle where Self == DisclosureToggleStyle {
    static var disclosure: DisclosureToggleStyle {
        .init()
    }
}

struct AnimatedDisclosureGroupStyle: DisclosureGroupStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            HStack {
                Button {
                    configuration.isExpanded.toggle()
                } label: {
                    #symbolImage("chevron.forward")
                        .rotationEffect(configuration.isExpanded ? Angle(degrees: 90) : Angle.zero)
                        .animation(reduceMotion ? nil : .smooth, value: configuration.isExpanded)
                }
                .buttonStyle(.plain)
                .controlSize(.small)
                
                configuration.label
                
                Spacer()
            }
            if configuration.isExpanded {
                configuration.content
            }
        }
        .animation(reduceMotion ? nil : .smooth, value: configuration.isExpanded)
    }
}
