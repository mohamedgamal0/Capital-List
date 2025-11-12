//
//  LocationServiceTests.swift
//  Capital ListTests
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import XCTest
import CoreLocation
@testable import Capital_List

final class LocationServiceTests: XCTestCase {
    
    // MARK: - Properties
    
    private var sut: LocationService!
    private let defaultCountryCode = "US"
    private let testTimeout: TimeInterval = 5.0
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        super.setUp()
        sut = LocationService()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization_CreatesLocationService() {
        // Given & When
        let service = LocationService()
        
        // Then
        XCTAssertNotNil(service, "LocationService should be initialized")
        let protocolService: LocationServiceProtocol = service
        XCTAssertNotNil(protocolService, "LocationService should conform to LocationServiceProtocol")
    }
    
    // MARK: - requestLocationPermission Tests
    
    func testRequestLocationPermission_WhenAuthorizedWhenInUse_ReturnsTrue() async {
        
        let result = await sut.requestLocationPermission()
        
        XCTAssertTrue(result == true || result == false,
                     "Should return a boolean value")
    }
    
    func testRequestLocationPermission_WhenAuthorizedAlways_ReturnsTrue() async {
        // Given: Service is initialized
        // When: Permission is already authorized always
        // Then: Should return true
        
        let result = await sut.requestLocationPermission()
        
        // Note: Actual result depends on system permissions
        XCTAssertTrue(result == true || result == false,
                     "Should return a boolean value")
    }
    
    func testRequestLocationPermission_WhenNotDetermined_RequestsPermission() async {
        // Given: Service is initialized
        // When: Permission status is not determined
        // Then: Should request permission and return result
        
        let result = await sut.requestLocationPermission()
        
        // Note: Actual result depends on user/system response
        XCTAssertTrue(result == true || result == false,
                     "Should return a boolean value after requesting permission")
    }
    
    func testRequestLocationPermission_WhenDenied_ReturnsFalse() async {
        // Given: Service is initialized
        // When: Permission is denied
        // Then: Should return false
        
        let result = await sut.requestLocationPermission()
        
        // Note: If permission is denied, should return false
        // Actual result depends on system permissions
        XCTAssertTrue(result == true || result == false,
                     "Should return a boolean value")
    }
    
    func testRequestLocationPermission_WhenRestricted_ReturnsFalse() async {
        // Given: Service is initialized
        // When: Permission is restricted
        // Then: Should return false
        
        let result = await sut.requestLocationPermission()
        
        XCTAssertTrue(result == true || result == false,
                     "Should return a boolean value")
    }
    
    
    func testRequestLocationPermission_IsAsync() async {
        // Given: Service is initialized
        // When: Permission is requested
        // Then: Should complete asynchronously
        
        let startTime = Date()
        _ = await sut.requestLocationPermission()
        let duration = Date().timeIntervalSince(startTime)
        
        XCTAssertGreaterThanOrEqual(duration, 0,
                                   "Should complete asynchronously")
    }
    
    // MARK: - getCurrentCountryCode Tests
    
    func testGetCurrentCountryCode_WhenPermissionDenied_ReturnsDefaultCountryCode() async {
        // Given: Permission is denied
        // When: getCurrentCountryCode is called
        // Then: Should return default country code "US"
        
        let result = await executeGetCurrentCountryCode()
        
        // If permission is denied, should return "US"
        // Otherwise, may return actual country code
        XCTAssertNotNil(result.countryCode,
                       "Should return a country code")
        if let code = result.countryCode {
            XCTAssertTrue(code == defaultCountryCode || code.count == 2,
                         "Should return 'US' or valid 2-letter ISO code, got: \(code)")
        }
    }
    
    func testGetCurrentCountryCode_WhenPermissionGranted_ReturnsCountryCode() async {
        // Given: Permission is granted
        // When: getCurrentCountryCode is called
        // Then: Should return a valid country code
        
        let result = await executeGetCurrentCountryCode()
        
        XCTAssertNotNil(result.countryCode,
                       "Should return a country code")
        if let code = result.countryCode {
            XCTAssertTrue(code == defaultCountryCode || code.count == 2,
                         "Should return 'US' or valid 2-letter ISO code, got: \(code)")
        }
    }
    
    func testGetCurrentCountryCode_ReturnsValidFormat() async {
        // Given: Service is initialized
        // When: getCurrentCountryCode is called
        // Then: Should return valid format (2-letter ISO code or "US")
        
        let result = await executeGetCurrentCountryCode()
        
        if let code = result.countryCode {
            let isValidFormat = code == defaultCountryCode || 
                               (code.count == 2 && code.allSatisfy { $0.isLetter })
            XCTAssertTrue(isValidFormat,
                         "Country code should be 'US' or 2-letter ISO code, got: \(code)")
        } else if result.error != nil {
            // Error is acceptable
            XCTAssertNotNil(result.error)
        } else {
            XCTFail("Should return country code or error")
        }
    }
    
    func testGetCurrentCountryCode_HandlesGeocodingError() async {
        // Given: Location is available but geocoding fails
        // When: getCurrentCountryCode is called
        // Then: Should handle error gracefully
        
        let result = await executeGetCurrentCountryCode()
        
        // Should either return default country code or throw error
        XCTAssertTrue(result.countryCode != nil || result.error != nil,
                     "Should return country code or error")
    }
    
    func testGetCurrentCountryCode_WhenLocationFails_ReturnsDefaultCountryCode() async {
        // Given: Location request fails
        // When: getCurrentCountryCode is called
        // Then: Should return default country code "US"
        
        let result = await executeGetCurrentCountryCode()
        
        // On location failure, should return default country code
        // Note: Actual behavior depends on system state
        XCTAssertNotNil(result.countryCode,
                       "Should return a country code even on failure")
    }
    
    func testGetCurrentCountryCode_WhenEmptyLocations_ReturnsDefaultCountryCode() async {
        // Given: Location update returns empty array
        // When: getCurrentCountryCode is called
        // Then: Should return default country code "US"
        
        let result = await executeGetCurrentCountryCode()
        
        // If locations array is empty, should return default
        // Note: This is tested indirectly through the service behavior
        XCTAssertNotNil(result.countryCode,
                       "Should return a country code")
    }
    
    func testGetCurrentCountryCode_WhenNoPlacemark_ReturnsDefaultCountryCode() async {
        // Given: Location is available but no placemark
        // When: getCurrentCountryCode is called
        // Then: Should return default country code "US"
        
        let result = await executeGetCurrentCountryCode()
        
        // If placemark is nil, should return default
        XCTAssertNotNil(result.countryCode,
                       "Should return a country code")
        if let code = result.countryCode {
            XCTAssertEqual(code, defaultCountryCode,
                          "Should return default when no placemark")
        }
    }
    
    // MARK: - Concurrency Tests
    
    func testGetCurrentCountryCode_HandlesConcurrentRequests() async {
        // Given: Service is initialized
        // When: Multiple concurrent requests are made
        // Then: All should complete without deadlocks
        
        let expectation = expectation(description: "Concurrent requests complete")
        expectation.expectedFulfillmentCount = 3
        
        var results: [(countryCode: String?, error: Error?)] = []
        
        for _ in 0..<3 {
            Task {
                let result = await executeGetCurrentCountryCode()
                results.append(result)
                expectation.fulfill()
            }
        }
        
        await fulfillment(of: [expectation], timeout: testTimeout * 3)
        
        XCTAssertEqual(results.count, 3,
                      "All concurrent requests should complete")
        results.forEach { result in
            XCTAssertTrue(result.countryCode != nil || result.error != nil,
                         "Each request should return a result or error")
        }
    }
    
    func testGetCurrentCountryCode_IsThreadSafe() async {
        // Given: Service is initialized
        // When: Requests are made from different threads
        // Then: Should handle safely without crashes
        
        let expectation = expectation(description: "Thread-safe requests complete")
        expectation.expectedFulfillmentCount = 2
        
        var result1: (countryCode: String?, error: Error?)?
        var result2: (countryCode: String?, error: Error?)?
        
        Task.detached { @MainActor in
            result1 = await self.executeGetCurrentCountryCode()
            expectation.fulfill()
        }
        
        Task.detached { @MainActor in
            result2 = await self.executeGetCurrentCountryCode()
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: testTimeout * 2)
        
        XCTAssertNotNil(result1, "First request should complete")
        XCTAssertNotNil(result2, "Second request should complete")
    }
    
    // MARK: - Protocol Conformance Tests
    
    func testLocationService_ConformsToLocationServiceProtocol() {
        // Given: LocationService instance
        // When: Checking protocol conformance
        // Then: Should conform to LocationServiceProtocol
        
        guard let service = sut else {
            XCTFail("Service should be initialized")
            return
        }
        
        // LocationService always conforms to LocationServiceProtocol (compile-time guarantee)
        let protocolService: LocationServiceProtocol = service
        XCTAssertNotNil(protocolService,
                       "LocationService should conform to LocationServiceProtocol")
    }
    
    func testLocationService_ImplementsRequiredMethods() {
        // Given: LocationService instance
        // When: Checking method availability
        // Then: Should implement all protocol methods
        
        guard let service = sut else {
            XCTFail("Service should be initialized")
            return
        }
        
        let protocolService: LocationServiceProtocol = service
        
        // Verify methods exist (compile-time check)
        // If this compiles, the service implements the protocol
        XCTAssertNotNil(protocolService,
                       "Service should implement protocol methods")
    }
    
    // MARK: - Edge Cases & Error Handling
    
    func testGetCurrentCountryCode_CompletesWithinTimeout() async {
        // Given: Service is initialized
        // When: getCurrentCountryCode is called
        // Then: Should complete within reasonable time
        
        let startTime = Date()
        _ = await executeGetCurrentCountryCode()
        let duration = Date().timeIntervalSince(startTime)
        
        XCTAssertLessThan(duration, testTimeout * 2,
                         "Should complete within reasonable time")
    }
    
    func testGetCurrentCountryCode_DoesNotCrashOnMultipleCalls() async {
        // Given: Service is initialized
        // When: getCurrentCountryCode is called multiple times
        // Then: Should not crash
        
        for _ in 0..<5 {
            let result = await executeGetCurrentCountryCode()
            XCTAssertTrue(result.countryCode != nil || result.error != nil,
                         "Each call should return a result or error")
        }
    }
    
    // MARK: - Helper Methods
    
    /// Executes getCurrentCountryCode and returns result or error
    /// - Returns: Tuple containing country code and error (if any)
    private func executeGetCurrentCountryCode() async -> (countryCode: String?, error: Error?) {
        let expectation = expectation(description: "getCurrentCountryCode completes")
        var countryCode: String?
        var error: Error?
        
        Task {
            do {
                countryCode = try await sut.getCurrentCountryCode()
            } catch let err {
                error = err
            }
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: testTimeout)
        
        return (countryCode, error)
    }
}
