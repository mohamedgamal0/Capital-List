//
//  Logger.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation
import OSLog

enum LogLevel: String {
    case debug = "🔍 DEBUG"
    case info = "ℹ️ INFO"
    case warning = "⚠️ WARNING"
    case error = "❌ ERROR"
    case success = "✅ SUCCESS"
}

struct AppLogger {
    // MARK: - Properties
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.capitallist"
    
    // MARK: - Core Log Method
    static func log(
        _ level: LogLevel,
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let fileName = (file as NSString).lastPathComponent
        let category = fileName.replacingOccurrences(of: ".swift", with: "")
        let logger = Logger(subsystem: subsystem, category: category)
        
        let logMessage = "[\(level.rawValue)] [\(fileName):\(line)] \(function) → \(message)"
        
        // MARK: - System Log
        switch level {
        case .debug:
            logger.debug("\(logMessage, privacy: .public)")
        case .info, .success:
            logger.info("\(logMessage, privacy: .public)")
        case .warning:
            logger.warning("\(logMessage, privacy: .public)")
        case .error:
            logger.error("\(logMessage, privacy: .public)")
        }
        
        // MARK: - Console Log (Debug Only)
        #if DEBUG
        print(colorizedMessage(for: level, message: logMessage))
        #endif
    }
    
    // MARK: - Convenience Methods
    static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.debug, message, file: file, function: function, line: line)
    }
    
    static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.info, message, file: file, function: function, line: line)
    }
    
    static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.warning, message, file: file, function: function, line: line)
    }
    
    static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.error, message, file: file, function: function, line: line)
    }
    
    static func success(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.success, message, file: file, function: function, line: line)
    }
    
    // MARK: - Helpers
    private static func colorizedMessage(for level: LogLevel, message: String) -> String {
        let colorCode: String
        switch level {
        case .debug: colorCode = "\u{001B}[0;36m" // cyan
        case .info: colorCode = "\u{001B}[0;32m"  // green
        case .success: colorCode = "\u{001B}[0;32m" // green
        case .warning: colorCode = "\u{001B}[0;33m" // yellow
        case .error: colorCode = "\u{001B}[0;31m"  // red
        }
        return "\(colorCode)\(message)\u{001B}[0m"
    }
}
