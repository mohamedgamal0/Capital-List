//
//  AppLoggerAdapter.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation

/// Adapter that makes AppLogger conform to LoggerProtocol
/// This allows dependency injection while keeping the existing AppLogger implementation
final class AppLoggerAdapter: LoggerProtocol {
    func debug(_ message: String, file: String, function: String, line: Int) {
        AppLogger.debug(message, file: file, function: function, line: line)
    }
    
    func info(_ message: String, file: String, function: String, line: Int) {
        AppLogger.info(message, file: file, function: function, line: line)
    }
    
    func warning(_ message: String, file: String, function: String, line: Int) {
        AppLogger.warning(message, file: file, function: function, line: line)
    }
    
    func error(_ message: String, file: String, function: String, line: Int) {
        AppLogger.error(message, file: file, function: function, line: line)
    }
    
    func success(_ message: String, file: String, function: String, line: Int) {
        AppLogger.success(message, file: file, function: function, line: line)
    }
}

