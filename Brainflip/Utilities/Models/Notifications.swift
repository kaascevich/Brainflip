import Foundation
import UserNotifications
import SwiftUI
import os.log
import Interpreter

struct Notifications {
    private init() { }
    
    static private let logger = Logger(subsystem: bundleID, category: "Notifications")
    
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
        if !NSApplication.shared.isActive, settings.showNotifications {
            requestPermission()
            
            let content = UNMutableNotificationContent()
            content.subtitle = filename
            content.body = "Run \(error == nil ? "succeeded" : "failed")"
            if let error = error as? Interpreter.Error {
                content.body += ": "
                switch error {
                    case .overflow:           content.body += "overflow"
                    case .underflow:          content.body += "underflow"
                    case .mismatchedBrackets: content.body += "mismatched brackets"
                    default: break
                }
            }
            if NSApp.isActive { content.badge = 1 }
                        
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
            
            UNUserNotificationCenter.current().add(request)
        }
    }
}
