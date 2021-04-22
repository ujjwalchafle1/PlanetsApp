//
//  PlanetRow.swift
//  Planets
//
//  Created by Ujjwal on 31/01/2021.
//

import SwiftUI

///Struct used for creating the Planet List rows
struct PlanetRow: View {
  var planet: Planet
  
  var body: some View {
    VStack(alignment: .leading)
    {
      Text(("Name : \(planet.name ?? "NA")"))
        .fontWeight(.semibold)
        .font(.system(size: 22))
        .padding(.bottom,5)
      
      Text(("Diameter : \(planet.diameter ?? "NA")"))
        .fontWeight(.regular)
        .font(.system(size: 18))
      
      Color.white.frame(height:CGFloat(1) / UIScreen.main.scale)
    }
  }
}
