import Foundation

@resultBuilder
struct StringBuilder {
    static func buildBlock(_ components: String...) -> String { components.joined() }
    
    static func buildOptional(_ component: String?) -> String { component ?? "" }
    
    static func buildArray(_ components: [String]) -> String { components.joined() }
    
    static func buildEither(first  component: String) -> String { component }
    static func buildEither(second component: String) -> String { component }
    
    static func buildLimitedAvailability(_ component: String) -> String { component }
}

extension String {
    init(@StringBuilder _ stringBuilder: () -> String) {
        self = stringBuilder()
    }
}
