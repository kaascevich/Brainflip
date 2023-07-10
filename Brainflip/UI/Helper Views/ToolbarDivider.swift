import SwiftUI

struct ToolbarDivider: ToolbarContent {
    let placement: ToolbarItemPlacement
    init(placement: ToolbarItemPlacement) {
        self.placement = placement
    }
    
    var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            Rectangle()
                .frame(width: 1, height: 20)
                .foregroundStyle(.quaternary)
                .padding(.horizontal, 5)
        }
    }
}
