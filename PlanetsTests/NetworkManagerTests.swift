//
//  NetworkManagerTests.swift
//  NetworkManagerTests
//
//  Created by Ujjwal on 27/01/2021.
//

import XCTest
@testable import Planets

class NetworkManagerTests: XCTestCase {
  
  var sut = NetworkManager()
  let url = URL(string: Constants().kPlanetsURL)!
  var statusCode: Int?
  var responseError: Error?
  var data : Data!
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  /// Test to verify if the Planet API URL is valid,
  /// **Unwraped URL** value should not be nil,
  /// **URLString** should be valid.
  /// *Simulate failture by uncommenting url variable*
  func test_GetData_Method_ValidUrl()
  {
    //  let url = URL(string: "")
    do {
      _ = try XCTUnwrap(url, "Invalid URL, url found nil")
    } catch { }
    XCTAssertEqual(url,URL(string:"https://swapi.dev/api/planets/"),"Planet list url should match the requirement")
  }
  
  /// Test to verify if the Planet API return,
  /// **Status Code** 200,
  /// **Error** is nil &
  /// **data** is not nil.
  /// *Simulate failture by uncommenting url variable*
  func test_GetData_Method_SessionTask ()
  {
    //let url = URL(string: "https://swapi.dev/api/planets/ddd")!
    let promise = expectation(description: "Completion handler invoked")
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      self.statusCode = (response as? HTTPURLResponse)?.statusCode
      self.responseError = error
      self.data = data
      promise.fulfill()
    }.resume()
    wait(for: [promise], timeout: 5)
    // then
    XCTAssertNil(responseError, "Error is not nil")
    XCTAssertEqual(statusCode, 200, "Status Code Not equal to 200, Received \(statusCode!)")
    XCTAssertNotNil(data)
  }
  
  /// Test to verify if the Planet API valid JSON in response,
  /// **JSON object** should not be nil,
  /// **JSON object type for key "results"** should match to [[**String: AnyObject**]]
  func test_GetData_Method_ValidJSON()
  {
    //let url = URL(string: "https://swapi.dev/api/planets/ddd")!
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      do {
        if let json = try JSONSerialization.jsonObject(with: data!, options: [.mutableContainers]) as? [String: AnyObject] {
          XCTAssertNotNil(json, "JSON found nil")
          XCTAssertTrue(((json["results"] as? [[String: AnyObject]]) != nil))
        }
      } catch { }
    }.resume()
  }
  
  func test_GetData_Method()
  {
    sut.getData { (result) in
      XCTAssertNil(result, "Planet result data not found")
    }
  }
}
