//
//  PeopleList.swift
//  Planets
//
//  Created by Ujjwal on 21/02/2021.
//

import SwiftUI

struct PeopleList: View {
  
  @State private var peopleArray: [People] = []
  @State private var isError = (false,"No Error")
  
  var body: some View {
    NavigationView {
      VStack {
        if peopleArray.isEmpty {
          errorLabel
        }
        peopleListView
      }
      .modifier(NavigationViewModifier())
      .navigationBarTitle("People")

      //    PlanetDetail(planet: planetsArray.first)
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
  
  
  /// Function to setup and Load the planet list
  private func onLoad() {
    OfflineDataManager.shared.planetDelegate = self
    OfflineDataManager.shared.loadPlanets(for:.people)
  }
  
  var peopleListView: some View {
    List {
      ForEach(peopleArray, id: \.name) { person in
        PeopleRow(person: person)
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


extension PeopleList: PlanetDataDelegate {
  func reloadData(data: Result<[AnyObject]>) {
    DispatchQueue.main.async {
      switch data {
      case .Success(let data):
        peopleArray = (data as? [People])!
      case .Error(let message) :
        isError = (true,message)
      }
    }
  }
}

struct PeopleList_Previews: PreviewProvider {
  static var previews: some View {
    PeopleList()
  }
}
