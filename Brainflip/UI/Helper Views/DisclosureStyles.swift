import SwiftUI

struct DisclosureToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Image(systemName: "chevron.forward")
                .rotationEffect(configuration.isOn ? Angle(degrees: 90) : Angle.zero)
                .animation(.easeInOut, value: configuration.isOn)
                .symbolVariant(.circle)
        }
        .buttonStyle(.plain)
    }
}

struct AnimatedDisclosureGroupStyle: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            HStack {
                Button {
                    configuration.isExpanded.toggle()
                } label: {
                    Image(systemName: "chevron.forward")
                        .rotationEffect(configuration.isExpanded ? Angle(degrees: 90) : Angle.zero)
                        .animation(.easeInOut, value: configuration.isExpanded)
                }
                .buttonStyle(.plain)
                .controlSize(.small)
                
                configuration.label
                
                Spacer()
            }
            if configuration.isExpanded { configuration.content }
        }
        .animation(.easeInOut, value: configuration.isExpanded)
    }
}
