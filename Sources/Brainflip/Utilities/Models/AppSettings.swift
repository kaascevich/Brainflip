// AppSettings.swift
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

// I prefer to use explicit type annotations with @AppStorage.
// swiftlint:disable redundant_type_annotation

import SwiftUI

/// The global ``AppSettings`` instance.
///
/// - TODO: Get rid of this somehow.
let settings = AppSettings()

/// The bundle ID of this app.
let bundleID = Bundle.main.bundleIdentifier!

// TODO: Create a macro to help out with the AppSettings class
final class AppSettings: ObservableObject {
    // MARK: - Store Definitions
    
    private enum Suite {
        static func suite(name: String) -> UserDefaults? {
            UserDefaults(suiteName: "\(bundleID).settings.\(name)")
        }
        
        static let generalSettings     = suite(name: "general")
        static let soundSettings       = suite(name: "sound")
        static let interpreterSettings = suite(name: "interpreter")
        static let editorSettings      = suite(name: "editor")
        static let inspectorSettings   = suite(name: "inspector")
        static let exportSettings      = suite(name: "export")
        static let hiddenSettings      = suite(name: "hidden")
    }
    
    // MARK: - General Settings
    
    @AppStorage("showTimer", store: Suite.generalSettings)
    var showTimer: Bool = true
    
    @AppStorage("showNotifications", store: Suite.generalSettings)
    var showNotifications: Bool = false
    
    @AppStorage("monospacedOutput", store: Suite.generalSettings)
    var monospacedOutput: Bool = true
    
    @AppStorage("monospacedInput", store: Suite.generalSettings)
    var monospacedInput: Bool = false
    
    @AppStorage("showCopyPasteButtons", store: Suite.generalSettings)
    var showCopyPasteButtons: Bool = true
    
    // MARK: - Sound Settings
    
    @AppStorage("playSounds", store: Suite.soundSettings)
    var playSounds: Bool = false
    
    @AppStorage("playStartSound", store: Suite.soundSettings)
    var playStartSound: Bool = true
    
    @AppStorage("playSuccessSound", store: Suite.soundSettings)
    var playSuccessSound: Bool = true
    
    @AppStorage("playFailSound", store: Suite.soundSettings)
    var playFailSound: Bool = true
    
    @AppStorage("playStepSound", store: Suite.soundSettings)
    var playStepSound: Bool = false
    
    // MARK: - Interpreter Settings
    
    @AppStorage("endOfInput", store: Suite.interpreterSettings)
    var endOfInput: Interpreter.EndOfInput = .noChange
    
    @AppStorage("arraySize", store: Suite.interpreterSettings)
    var arraySize: Double = 30_000
    
    @AppStorage("pointerLocation", store: Suite.interpreterSettings)
    var pointerLocation: Double = 0
    
    @AppStorage("cellSize", store: Suite.interpreterSettings)
    var cellSize: CellSize = .eightBit
    
    @AppStorage("breakOnHash", store: Suite.interpreterSettings)
    var breakOnHash: Bool = false
    
    // MARK: - Editor Settings
    
    @AppStorage("monospaced", store: Suite.editorSettings)
    var monospaced: Bool = true
    
    @AppStorage("highlighting", store: Suite.editorSettings)
    var highlighting: Bool = false
    
    @AppStorage("textSize", store: Suite.editorSettings)
    var textSize: Double = 14.0
    
    @AppStorage("showProgress", store: Suite.editorSettings)
    var showProgress: Bool = true
    
    @AppStorage("showCurrentInstruction", store: Suite.editorSettings)
    var showCurrentInstruction: Bool = true
    
    @AppStorage("showProgramSize", store: Suite.editorSettings)
    var showProgramSize: Bool = true
    
    // MARK: - Inspector Settings
    
    @AppStorage("enabledInspectorModules", store: Suite.inspectorSettings)
    var enabledInspectorModules: [Bool] = Inspector.modules.map(\.enabledByDefault)
    
    @AppStorage("inspectorModuleOrder", store: Suite.inspectorSettings)
    var inspectorModuleOrder: [Int] = Array(Inspector.modules.indices)
    
    // MARK: - Export Settings
    
    @AppStorage("indentation", store: Suite.exportSettings)
    var indentation: Int = 3
    
    @AppStorage("pointerName", store: Suite.exportSettings)
    var pointerName: String = "ptr"
    
    @AppStorage("arrayName", store: Suite.exportSettings)
    var arrayName: String = "array"
    
    @AppStorage("leftHandIncDec", store: Suite.exportSettings)
    var leftHandIncDec: Bool = false
    
    @AppStorage("includeNotEqualZero", store: Suite.exportSettings)
    var includeNotEqualZero: Bool = true
    
    @AppStorage("includeDisabledBreak", store: Suite.exportSettings)
    var includeDisabledBreak: Bool = false
    
    @AppStorage("openingBraceOnNewLine", store: Suite.exportSettings)
    var openingBraceOnNewLine: Bool = false
    
    @AppStorage("includeVoidWithinMain", store: Suite.exportSettings)
    var includeVoidWithinMain: Bool = true
    
    @AppStorage("whitespace", store: Suite.exportSettings)
    var whitespace: [BrainflipToC.Whitespace] = [
        .beforeWhileOrIf,
        .beforeBrace,
        .aroundAssignment,
        .beforePointerMark,
        .afterCommas,
        .aroundAddition,
        .aroundNotEqual,
        .afterCommentMarkers,
        .afterIfStatement,
        .afterSemicolon,
        .aroundGreaterThanOrEqual
    ]
    
    // MARK: - Not user-configurable
    
    @AppStorage("exportToCAlertHidden", store: Suite.hiddenSettings)
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
        showTimer                 = true
        showNotifications         = false
        monospacedOutput          = true
        monospacedInput           = false
    }
    
    func resetSoundToDefaults() {
        playSounds                = false
        playStartSound            = true
        playSuccessSound          = true
        playFailSound             = true
        playStepSound             = false
    }
    
    func resetInterpreterToDefaults() {
        endOfInput                = .noChange
        arraySize                 = 30_000
        pointerLocation           = 0
        cellSize                  = .eightBit
        breakOnHash               = false
    }
    
    func resetInspectorToDefaults() {
        enabledInspectorModules   = Inspector.modules.map(\.enabledByDefault)
        inspectorModuleOrder      = Array(Inspector.modules.indices)
    }
    
    func resetEditorToDefaults() {
        monospaced                = true
        highlighting              = false
        showProgress              = true
        showCurrentInstruction    = true
        showProgramSize           = true
        textSize                  = 14.0
    }
    
    func resetExportToDefaults() {
        indentation               = 3
        pointerName               = "ptr"
        arrayName                 = "array"
        leftHandIncDec            = false
        includeNotEqualZero       = true
        includeDisabledBreak      = false
        openingBraceOnNewLine     = false
        includeVoidWithinMain     = true
        whitespace = [
            .beforeWhileOrIf,
            .beforeBrace,
            .aroundAssignment,
            .beforePointerMark,
            .afterCommas,
            .aroundAddition,
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

// swiftlint:enable redundant_type_annotation
