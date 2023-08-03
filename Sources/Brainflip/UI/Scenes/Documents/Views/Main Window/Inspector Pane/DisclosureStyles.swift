import SwiftUI

struct DisclosureToggleStyle: ToggleStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Image(systemName: "chevron.forward")
                .rotationEffect(configuration.isOn ? Angle(degrees: 90) : Angle.zero)
                .animation(reduceMotion ? nil : .spring(duration: 0.75, bounce: 0.5), value: configuration.isOn)
                .symbolVariant(.circle)
        }
        .buttonStyle(.plain)
    }
}

extension ToggleStyle where Self == DisclosureToggleStyle {
    static var disclosure: DisclosureToggleStyle { .init() }
}

struct AnimatedDisclosureGroupStyle: DisclosureGroupStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            HStack {
                Button {
                    configuration.isExpanded.toggle()
                } label: {
                    Image(systemName: "chevron.forward")
                        .rotationEffect(configuration.isExpanded ? Angle(degrees: 90) : Angle.zero)
                        .animation(reduceMotion ? nil : .smooth, value: configuration.isExpanded)
                }
                .buttonStyle(.plain)
                .controlSize(.small)
                
                configuration.label
                
                Spacer()
            }
            if configuration.isExpanded { configuration.content }
        }
        .animation(reduceMotion ? nil : .smooth, value: configuration.isExpanded)
    }
}
