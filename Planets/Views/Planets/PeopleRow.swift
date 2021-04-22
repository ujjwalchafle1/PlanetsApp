//
//  PlanetRow.swift
//  Planets
//
//  Created by Ujjwal on 31/01/2021.
//

import SwiftUI

///Struct used for creating the Planet List rows
struct PeopleRow: View {
  var person: People
  
  var body: some View {
    VStack(alignment: .leading)
    {
      Text(("Name : \(person.name ?? "NA")"))
        .fontWeight(.semibold)
        .font(.system(size: 22))
        .padding(.bottom,5)
      Color.white.frame(height:CGFloat(1) / UIScreen.main.scale)
    }
  }
}
