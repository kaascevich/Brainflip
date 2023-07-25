import SwiftUI

struct ToolbarDivider: ToolbarContent {
    var body: some ToolbarContent {
        ToolbarItem {
            Rectangle()
                .frame(width: 1, height: 20)
                .foregroundStyle(.quaternary)
                .padding(.horizontal, 5)
        }
    }
}
