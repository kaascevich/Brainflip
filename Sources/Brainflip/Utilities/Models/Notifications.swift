// Notifications.swift
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

import os.log
import SwiftUI
import UserNotifications

enum Notifications {
    private static let logger = Logger(subsystem: bundleID, category: "Notifications")
    
    @discardableResult
    static func requestPermission() -> Bool {
        var isAuthorized = false
        let options: UNAuthorizationOptions = [.alert, .badge]
        
        logger.info("Requesting notification authorization")
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            isAuthorized = success
            if success {
                logger.info("Notification authorization succeeded")
            } else if let error {
                logger.error("Notification authorization failed: \(error.localizedDescription)")
            }
        }
        return isAuthorized
    }
    
    static func sendNotification(_ filename: String, error: Error? = nil) {
        guard !NSApplication.shared.isActive, settings.showNotifications else {
            return
        }
        
        requestPermission()
        
        let content = UNMutableNotificationContent().then {
            $0.subtitle = filename
            $0.body = "Run \(error.isNil ? "succeeded" : "failed")".then { body in
                if let error = error as? InterpreterError {
                    body += ": "
                    switch error {
                        case .overflow:           body += "overflow"
                        case .underflow:          body += "underflow"
                        case .mismatchedBrackets: body += "mismatched brackets"
                        default: break
                    }
                }
            }
            $0.badge = 1
        }
                    
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}
