//
//  Constants.swift
//  Planets
//
//  Created by Ujjwal on 28/01/2021.
//

import Foundation

struct Constants
{
  let kPlanetsURL = "https://swapi.dev/api/planets/"
  let kPeopleURL  = "https://swapi.dev/api/people/"
  
  let kAPIUrl =  "https://swapi.dev/api/"
  
  let kPlanetCellReuseIdentifier = "planet_cell"
  
  //Error Messages
  let kInvalidURLError = "Invalid URL, we can't update your feed"
  
  let KEmptyPlanetsArrayError = "There are no new Items to show"
  
  let KEmptyPlanetsMessageLblTxt = """
        Sorry! Planets currently not available, \
        Please try to refresh!
        """
  let KPlanetDetailsError = """
        Planets Details not available, \
        Please try to refresh page!
        """
  
}
