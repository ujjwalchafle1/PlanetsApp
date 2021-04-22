//
//  TabBarView.swift
//  Planets
//
//  Created by Ujjwal on 19/02/2021.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
      TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
        VStack{
          PlanetList()
        }
        .tabItem { Text("Planets") }.tag(1)
        
        VStack{
          PeopleList()
        }.tabItem { Text("People") }.tag(2)
      }
    }
  func myParents(){
    
  }

}

struct TestSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
  
}
