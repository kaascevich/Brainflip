@propertyWrapper
struct Alias<T> {
    var wrappedValue: T
    var p[]
    
    init(wrappedValue: T, for aliasedValue: inout T) {
        self.wrappedValue = wrappedValue
    }
}
