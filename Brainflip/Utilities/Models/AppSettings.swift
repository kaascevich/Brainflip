import SwiftUI

final class AppSettings: ObservableObject {
    // MARK: - Store Definitions
    
    private static let generalSettings     = UserDefaults(suiteName: "settings-general")
    private static let soundSettings       = UserDefaults(suiteName: "settings-sound")
    private static let interpreterSettings = UserDefaults(suiteName: "settings-interpreter")
    private static let editorSettings      = UserDefaults(suiteName: "settings-editor")
    private static let inspectorSettings   = UserDefaults(suiteName: "settings-inspector")
    private static let exportSettings      = UserDefaults(suiteName: "settings-export")
    private static let hiddenSettings      = UserDefaults(suiteName: "settings-hidden")
    
    // MARK: - General Settings
    
    @AppStorage("showTimer", store: generalSettings)
    var showTimer: Bool = true
    
    // MARK: - Sound Settings
    
    @AppStorage("playSounds", store: soundSettings)
    var playSounds: Bool = false
    
    @AppStorage("playStartSound", store: soundSettings)
    var playStartSound: Bool = true
    
    @AppStorage("playSuccessSound", store: soundSettings)
    var playSuccessSound: Bool = true
    
    @AppStorage("playFailSound", store: soundSettings)
    var playFailSound: Bool = true
    
    @AppStorage("playStepSound", store: soundSettings)
    var playStepSound: Bool = false
    
    // MARK: - Interpreter Settings
    
    @AppStorage("endOfInput", store: interpreterSettings)
    var endOfInput: Interpreter.EndOfInput = .noChange
    
    @AppStorage("arraySize", store: interpreterSettings)
    var arraySize: Double = 30000
    
    @AppStorage("pointerLocation", store: interpreterSettings)
    var pointerLocation: Double = 0
    
    @AppStorage("cellSize", store: interpreterSettings)
    var cellSize: CellSize = .eightBit
    
    @AppStorage("breakOnHash", store: interpreterSettings)
    var breakOnHash: Bool = false
    
    // MARK: - Editor Settings
    
    @AppStorage("monospaced", store: editorSettings)
    var monospaced: Bool = true
    
    @AppStorage("highlighting", store: editorSettings)
    var highlighting: Bool = false
    
    @AppStorage("showProgress", store: editorSettings)
    var showProgress: Bool = true
    
    @AppStorage("showCurrentInstruction", store: editorSettings)
    var showCurrentInstruction: Bool = false
    
    @AppStorage("showProgramSize", store: editorSettings)
    var showProgramSize: Bool = true
    
    // MARK: - Inspector Settings
    
    @AppStorage("enabledInspectorModules", store: inspectorSettings)
    var enabledInspectorModules: [Bool] = Inspector.defaultModules
    
    @AppStorage("expandedInspectorModules", store: inspectorSettings)
    var expandedInspectorModules: [Bool] = Array(repeating: true, count: Inspector.moduleCount)
    
    @AppStorage("inspectorModuleOrder", store: inspectorSettings)
    var inspectorModuleOrder: [Int] = Array(0...(Inspector.moduleCount - 1))
    
    // MARK: - Export Settings
    
    @AppStorage("indentation", store: exportSettings)
    var indentation: Int = 3
    
    @AppStorage("pointerName", store: exportSettings)
    var pointerName: String = "ptr"
    
    @AppStorage("arrayName", store: exportSettings)
    var arrayName: String = "array"
    
    @AppStorage("leftHandIncDec", store: exportSettings)
    var leftHandIncDec: Bool = false
    
    @AppStorage("includeNotEqualZero", store: exportSettings)
    var includeNotEqualZero: Bool = true
    
    @AppStorage("includeDisabledBreak", store: exportSettings)
    var includeDisabledBreak: Bool = false
    
    @AppStorage("openingBraceOnNewLine", store: exportSettings)
    var openingBraceOnNewLine: Bool = false
    
    @AppStorage("whitespace", store: exportSettings)
    var whitespace: [Whitespace] = [
        .beforeWhileOrIf,
        .beforeBrace,
        .aroundAssignment,
        .beforePointerMark,
        .afterCommas,
        .aroundCompoundAssignment,
        .aroundNotEqual,
        .afterCommentMarkers,
        .afterIfStatement,
        .afterSemicolon,
        .aroundGreaterThanOrEqual
    ]
    
    // MARK: - Not user-configurable
    
    @AppStorage("exportToCAlertHidden", store: hiddenSettings)
    var exportToCAlertHidden: Bool = false
}

// MARK: - Reset to Defaults

extension AppSettings {
    func resetAllToDefaults() {
        resetGeneralToDefaults()
        resetSoundToDefaults()
        resetInterpreterToDefaults()
        resetEditorToDefaults()
        resetInspectorToDefaults()
        resetExportToDefaults()
        resetHiddenToDefaults()
    }
    
    func resetGeneralToDefaults() {
        showTimer = true
    }
    
    func resetSoundToDefaults() {
        playSounds = false
        playStartSound = true
        playSuccessSound = true
        playFailSound = true
        playStepSound = false
    }
    
    func resetInterpreterToDefaults() {
        endOfInput = .noChange
        arraySize = 30_000
        pointerLocation = 0
        cellSize = .eightBit
        breakOnHash = false
    }
    
    func resetInspectorToDefaults() {
        enabledInspectorModules = Inspector.defaultModules
        inspectorModuleOrder = Array(0...(Inspector.moduleCount - 1))
        expandedInspectorModules = Array(repeating: true, count: Inspector.moduleCount)
    }
    
    func resetEditorToDefaults() {
        monospaced = true
        highlighting = false
        showProgress = true
        showCurrentInstruction = false
        showProgramSize = true
    }
    
    func resetExportToDefaults() {
        indentation = 3
        pointerName = "ptr"
        arrayName = "array"
        leftHandIncDec = false
        includeNotEqualZero = true
        includeDisabledBreak = false
        openingBraceOnNewLine = false
        whitespace = [
            .beforeWhileOrIf,
            .beforeBrace,
            .aroundAssignment,
            .beforePointerMark,
            .afterCommas,
            .aroundCompoundAssignment,
            .aroundNotEqual,
            .afterCommentMarkers,
            .afterIfStatement,
            .afterSemicolon,
            .aroundGreaterThanOrEqual
        ]
    }
    
    func resetHiddenToDefaults() {
        exportToCAlertHidden = false
    }
}
