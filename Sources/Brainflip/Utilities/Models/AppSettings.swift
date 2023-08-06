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

import SwiftUI
import Foundation
import os.log

/// The global ``AppSettings`` instance.
///
/// - TODO: Get rid of this somehow.
let settings = AppSettings()

/// The bundle ID of this app.
let bundleID = Bundle.main.bundleIdentifier!

// TODO: Create a macro to help out with the AppSettings class
final class AppSettings: ObservableObject {
    private static let logger = Logger(subsystem: bundleID, category: "Settings")
    
    // MARK: - Store Definitions
    
    private static let generalSettings     = UserDefaults(suiteName: "\(bundleID).settings.general")
    private static let soundSettings       = UserDefaults(suiteName: "\(bundleID).settings.sound")
    private static let interpreterSettings = UserDefaults(suiteName: "\(bundleID).settings.interpreter")
    private static let editorSettings      = UserDefaults(suiteName: "\(bundleID).settings.editor")
    private static let inspectorSettings   = UserDefaults(suiteName: "\(bundleID).settings.inspector")
    private static let exportSettings      = UserDefaults(suiteName: "\(bundleID).settings.export")
    private static let hiddenSettings      = UserDefaults(suiteName: "\(bundleID).settings.hidden")
    
    // MARK: - General Settings
    
    @AppStorage("showTimer", store: generalSettings)
    var showTimer: Bool = true
    
    @AppStorage("showNotifications", store: generalSettings)
    var showNotifications: Bool = false
    
    @AppStorage("monospacedOutput", store: generalSettings)
    var monospacedOutput: Bool = true
    
    @AppStorage("monospacedInput", store: generalSettings)
    var monospacedInput: Bool = false
    
    @AppStorage("showCopyPasteButtons", store: generalSettings)
    var showCopyPasteButtons: Bool = true
    
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
    
    @AppStorage("textSize", store: editorSettings)
    var textSize: Double = 14.0
    
    @AppStorage("showProgress", store: editorSettings)
    var showProgress: Bool = true
    
    @AppStorage("showCurrentInstruction", store: editorSettings)
    var showCurrentInstruction: Bool = true
    
    @AppStorage("showProgramSize", store: editorSettings)
    var showProgramSize: Bool = true
    
    // MARK: - Inspector Settings
    
    @AppStorage("enabledInspectorModules", store: inspectorSettings)
    var enabledInspectorModules: [Bool] = Inspector.staticInspector.modules.map(\.enabledByDefault)
    
    @AppStorage("inspectorModuleOrder", store: inspectorSettings)
    var inspectorModuleOrder: [Int] = Array(Inspector.staticInspector.modules.indices)
    
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
    
    @AppStorage("includeVoidWithinMain", store: exportSettings)
    var includeVoidWithinMain: Bool = true
    
    @AppStorage("whitespace", store: exportSettings)
    var whitespace: [BrainflipToC.Whitespace] = [
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
        AppSettings.logger.notice("Resetting ALL settings")
        resetGeneralToDefaults()
        resetSoundToDefaults()
        resetInterpreterToDefaults()
        resetEditorToDefaults()
        resetInspectorToDefaults()
        resetExportToDefaults()
        resetHiddenToDefaults()
    }
    
    func resetGeneralToDefaults() {
        AppSettings.logger.notice("Resetting general settings")
        showTimer                 = true
        showNotifications         = false
        monospacedOutput          = true
        monospacedInput           = false
    }
    
    func resetSoundToDefaults() {
        AppSettings.logger.notice("Resetting sound settings")
        playSounds                = false
        playStartSound            = true
        playSuccessSound          = true
        playFailSound             = true
        playStepSound             = false
    }
    
    func resetInterpreterToDefaults() {
        AppSettings.logger.notice("Resetting interpreter settings")
        endOfInput                = .noChange
        arraySize                 = 30_000
        pointerLocation           = 0
        cellSize                  = .eightBit
        breakOnHash               = false
    }
    
    func resetInspectorToDefaults() {
        AppSettings.logger.notice("Resetting inspector settings")
        enabledInspectorModules   = Inspector.staticInspector.modules.map(\.enabledByDefault)
        inspectorModuleOrder      = Array(Inspector.staticInspector.modules.indices)
    }
    
    func resetEditorToDefaults() {
        AppSettings.logger.notice("Resetting editor settings")
        monospaced                = true
        highlighting              = false
        showProgress              = true
        showCurrentInstruction    = true
        showProgramSize           = true
        textSize                  = 14.0
    }
    
    func resetExportToDefaults() {
        AppSettings.logger.notice("Resetting export settings")
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
            .aroundCompoundAssignment,
            .aroundNotEqual,
            .afterCommentMarkers,
            .afterIfStatement,
            .afterSemicolon,
            .aroundGreaterThanOrEqual
        ]
    }
    
    func resetHiddenToDefaults() {
        AppSettings.logger.notice("Resetting hidden settings")
        exportToCAlertHidden = false
    }
}
