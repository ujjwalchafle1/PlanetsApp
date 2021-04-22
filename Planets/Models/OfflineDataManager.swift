//
//  OfflineDataManager.swift
//  Planets
//
//  Created by Ujjwal on 28/01/2021.
//

import Foundation
import CoreData

/// Protocal to notify when the Planet List data is available
protocol PlanetDataDelegate {
  func reloadData(data : Result<[AnyObject]>)
}

/// Class responsible for creating core data stack and managing the offline stoage for the Planet list
class OfflineDataManager
{
  static let shared = OfflineDataManager()
  
  var offlineRecords: [AnyObject] = []
  
  var planetDelegate : PlanetDataDelegate?
  
  // MARK: - Core Data stack
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Planets")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
}

extension OfflineDataManager {
  
  ///The directory the application uses to store the Core Data store file.
  func applicationDocumentsDirectory() {
    if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
      print("path - \(url.absoluteString)")
    }
  }
  
  /// Function to save the Planet list in database
  /// Create function from CURD
  /// - Parameter array: array of planets
  func saveInCoreDataWith(for type:Types, _ array: [[String: AnyObject]])
  {
    applicationDocumentsDirectory()
    if type == .planets{
      _ = array.map{self.createPlanetEntity(with: $0)}
    } else {
      _ = array.map{self.createPeopleEntity(with: $0)}
    }
    do {
      try persistentContainer.viewContext.save()
    } catch let error {
      self.planetDelegate?.reloadData(data: .Error(error.localizedDescription))
    }
  }
  
  /// Function to create the core data Planet entity
  /// - Parameter dictionary: raw planet data in dictionary
  /// - Returns: planet core data entity
  private func createPlanetEntity(with dictionary: [String: AnyObject]) -> NSManagedObject?
  {
    let planet = Planet(context: persistentContainer.viewContext)
    planet.name = dictionary["name"] as? String
    planet.diameter = dictionary["diameter"] as? String
    planet.climate = dictionary["climate"] as? String
    planet.terrain = dictionary["terrain"] as? String
    planet.population = dictionary["population"] as? String
    return planet
  }
  
  private func createPeopleEntity(with dictionary: [String: AnyObject]) -> NSManagedObject?
  {
    let people = People(context: persistentContainer.viewContext)
    people.name = dictionary["name"] as? String
    people.gender = dictionary["gender"] as? String
    return people
  }
  /// Function to fetch the Planet list from local database
  /// If Planet list data is not available offline, make network call to fetch the list
  /// Store the planet list and notify the Planet List Controller of fetched records.
  /// Read function from CURD
  func loadPlanets(for type: Types)
  {
    
    let request = createFetchRequest(for: type)
    do {
      offlineRecords = try persistentContainer.viewContext.fetch(request)
      if offlineRecords.isEmpty
      {
        NetworkManager.shared.getData(for: type)
        { (result) in
          switch result {
          case .Success(let data):
            OfflineDataManager.shared.saveInCoreDataWith(for: type, data)
            self.loadPlanets(for: type)
          case .Error(let message):
            self.planetDelegate?.reloadData(data: .Error(message))
          }
        }
      }
      else {
        self.planetDelegate?.reloadData(data: .Success(self.offlineRecords))
      }
    } catch let error{
      self.planetDelegate?.reloadData(data: .Error(error.localizedDescription))
    }
  }
  
  func createFetchRequest(for type: Types) -> NSFetchRequest<NSFetchRequestResult>
  {
    let request: NSFetchRequest = type == .planets ? Planet.fetchRequest() : People.fetchRequest()
    
    let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
    
    request.sortDescriptors = [sortDescriptor]
    
    return request
    
  }
  
  /// Function to clear all the records from offline database
  /// Delete function from CURD
  func clearData()
  {
    let context = persistentContainer.viewContext
    let request: NSFetchRequest<Planet> = Planet.fetchRequest()
    do {
      let planets = try context.fetch(request)
      _ = planets.map{context.delete($0)}
      try context.save()
    } catch let error {
      self.planetDelegate?.reloadData(data: .Error(error.localizedDescription))
    }
  }
}

