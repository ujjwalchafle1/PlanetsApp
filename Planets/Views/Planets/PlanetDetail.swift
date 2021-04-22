//
//  PlanetDetail.swift
//  Planets
//
//  Created by Ujjwal on 30/01/2021.
//

import SwiftUI

struct PlanetDetail: View
{
  //MARK: - Properties
  
  let planet: Planet?
  
  //MARK: - Detail view component
  
  var body: some View {
    ZStack{
      Image("ListBackground")
        .resizable()
        .edgesIgnoringSafeArea(.all)
      
      VStack {
        if planet == nil {
          Text(Constants().KPlanetDetailsError)
            .fontWeight(.bold)
            .font(.system(size: 20))
            .foregroundColor(.orange)
        }
        else {
          ZStack {
            Circle()
              .stroke(Color.white, lineWidth: 2)
              .frame(width: 250.0, height: 250.0)
            
            Text((planet?.name)!)
              .fontWeight(.bold)
              .font(Font.custom("Pacifico-Regular", size: 40))
              .foregroundColor(.orange)
          }
          
          Divider()
          
          otherDetailsView
          
          Spacer()
        }
      }
    }
  }
  
  var otherDetailsView: some View {
    VStack(){
      Text("Diameter : \((planet?.diameter)!)")
        .font(.system(size: 22))
        .padding(.bottom,5)
      
      Text("Climate : \((planet?.climate)!)")
        .fontWeight(.regular)
        .font(.system(size: 22))
        .padding(.bottom,5)
      
      Text("Terrian : \((planet?.terrain)!)")
        .fontWeight(.regular)
        .font(.system(size: 22))
        .padding(.bottom,5)
      
      Text("Population : \((planet?.population)!)")
        .fontWeight(.regular)
        .font(.system(size: 22))
      
    }
    .lineLimit(1)
    .allowsTightening(true)
    .foregroundColor(.white)
    .minimumScaleFactor(0.5)
  }
}
