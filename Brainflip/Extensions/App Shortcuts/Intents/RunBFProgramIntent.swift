import AppIntents

struct RunBFProgramIntent: AppIntent {
    static var title: LocalizedStringResource = "Run Brainflip Program"
    static var description = IntentDescription("""
        Runs a Brainflip program, giving it the provided input.
        
        Configure the interpreter in the Brainflip app.
        """)
    
    @Parameter(title: "Program")
    var program: String?
    
    @Parameter(title: "Input")
    var input: String?
    
    func perform() async throws -> some IntentResult & ReturnsValue {
        if let program {
            var output = program
            if let input {
                output += "!" + input
            }
            
            return .result(value: output)
        }
        return .result(value: "test")
    }
}
