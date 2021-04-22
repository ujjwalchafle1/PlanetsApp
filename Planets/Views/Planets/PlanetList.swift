//
//  PlanetList.swift
//  Planets
//
//  Created by Ujjwal on 29/01/2021.
//

import SwiftUI

struct PlanetList: View {
  
  //MARK: - Properties
  
  @State private var planetsArray: [Planet] = []
//  @State private var peopleArray: [People] = []

  @State private var isError = (false,"No Error")
  
//  @State private var typeSelected = "plantes"
  /// Function to setup and Load the planet list
  private func onLoad() {
    OfflineDataManager.shared.planetDelegate = self
    OfflineDataManager.shared.loadPlanets(for:.planets)
  }
  
  //MARK: - List view component
  
  var body: some View {
    NavigationView {
      VStack {
        if planetsArray.isEmpty {
          errorLabel
        }
        planetListView
      }
      .modifier(NavigationViewModifier())
      .navigationBarTitle("Planets")

      PlanetDetail(planet: planetsArray.first)
    }
    .alert(isPresented: $isError.0) {
      Alert(
        title: Text("Error"),
        message: Text(isError.1)
      )
    }
    .onAppear {
      onLoad()
    }
  }
  
  var planetListView: some View {
    List {
      ForEach(planetsArray, id: \.name) { planet in
        NavigationLink(
          destination: PlanetDetail(planet: planet)) {
          PlanetRow(planet: planet)
        }
        .listRowBackground(Color.clear)
        .foregroundColor(.white)
      }
    }
  }
  
  var errorLabel: some View {
    Text(Constants().KEmptyPlanetsMessageLblTxt)
      .fontWeight(.bold)
      .font(.system(size: 20))
      .foregroundColor(.orange)
  }
}


//MARK: - Navigation View Modifier

struct NavigationViewModifier: ViewModifier {
  func body(content: Content) -> some View {
    return content
      
      .navigationBarItems(trailing: Button(action: {
        OfflineDataManager.shared.loadPlanets(for: .planets)
      }, label: { Image(systemName:"arrow.clockwise")
        .imageScale(.large)
      }))
      
      .background(
        Image("ListBackground")
          .resizable()
          .edgesIgnoringSafeArea(.all)
      )
  }
}

//MARK: - Planet Data Delegate Methods

extension PlanetList: PlanetDataDelegate {
  func reloadData(data: Result<[AnyObject]>) {
    DispatchQueue.main.async {
      switch data {
      case .Success(let data):
        planetsArray = (data as? [Planet])!
      case .Error(let message) :
        isError = (true,message)
      }
    }
  }
}


