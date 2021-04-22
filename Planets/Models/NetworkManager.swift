//
//  NetworkManager.swift
//  Planets
//
//  Created by Ujjwal on 28/01/2021.
//

import Foundation
import CoreData

/// Class responsible for handling the network calls to Planet API
class NetworkManager
{
  static let shared = NetworkManager()
  
  /// Function to fetch list of planets from the given url
  /// - Parameter completion:Clouser with Enum with Tuples for Success and Failure condition
  func getData(for param: Types, with completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {

    /// Get the urlString from constants
    let urlString = Constants().kAPIUrl + "\(param)"
    
    /// Create the url from urlString
    guard let url = URL(string: urlString) else { return completion(.Error(Constants().kInvalidURLError)) }
    
    /// Call the DataTask clouser from URLSession shared instance
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      
      /// guard for the error situation
      guard error == nil else { return completion(.Error(error!.localizedDescription)) }
      guard let data = data else { return completion(.Error(error?.localizedDescription ?? Constants().KEmptyPlanetsArrayError))
      }
      do {
        /// Create the Json object from the API response data
        if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
          
          /// get the array Planet objects from the results
          print("response - \(json)")
          guard let itemsJsonArray = json["results"] as? [[String: AnyObject]] else {
            return completion(.Error(error?.localizedDescription ?? Constants().KEmptyPlanetsArrayError))
          }
          DispatchQueue.main.async {
            completion(.Success(itemsJsonArray))
          }
        }
      } catch let error {
        return completion(.Error(error.localizedDescription))
      }
    }.resume()
  }
}

/// Enum for Success and Error scenarios
enum Result<T> {
  case Success(T)
  case Error(String)
}
