//
//  PlanetsView.swift
//  Planets
//
//  Created by Ujjwal on 29/01/2021.
//

import SwiftUI

struct PlanetsView: View {
    
    @State var planetsArray = [Planet]()
    @State var isError = (false,"No Error")
    
    init() {
        UITableViewCell.appearance().accessoryType = .detailDisclosureButton
        UITableView.appearance().backgroundColor = .clear
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    /// Function to 
    fileprivate func onLoad() {
        OfflineDataManager.shared.planetDelegate = self
        OfflineDataManager.shared.loadPlanets()
        UITableView.appearance().separatorStyle = .singleLine
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().separatorColor = .white
        UITableViewCell.appearance().selectionStyle = .none
    }
    
    var body: some View {
        NavigationView{
            VStack{
                if planetsArray.count == 0 {
                    Text(Constants().KEmptyPlanetsMessageLblTxt).fontWeight(.bold).font(.system(size: 20)).foregroundColor(.orange)
                }
                List {
                    ForEach(planetsArray, id: \.name) { planet in
                        VStack(alignment: .leading){
                            Text(("Name : \(planet.name ?? "NA")")).fontWeight(.semibold).font(Font.system(size: 22))
                                .padding(.bottom,5)
                            Text(("Diameter : \(planet.diameter ?? "NA")")).fontWeight(.regular).foregroundColor(.white).font(.system(size: 18))
                            NavigationLink(
                                destination: DetailView(planet: planet)) {
                            }
                            Color.white.frame(height:CGFloat(1) / UIScreen.main.scale)
                        }
                        .listRowBackground(Color.clear)
                        .foregroundColor(.white)
                    }
                }
            }
            .navigationBarTitle("Planets")
            .background(
                Image("ListBackground")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
            )
            .navigationBarItems(trailing: Button(action: {
                OfflineDataManager.shared.loadPlanets()
            }, label: { Image(systemName:"arrow.clockwise")
                .imageScale(.large)
            })
            )
            DetailView(planet: planetsArray.first)
        }
        .alert(isPresented: $isError.0) {
            Alert(
                title: Text("Error"),
                message: Text(isError.1)
            )
        }
        .onAppear{
            onLoad()
        }
    }
}

extension PlanetsView : PlanetDataDelegate {
    func reloadData(data: Result<[Planet]>) {
        DispatchQueue.main.async {
            switch data {
            case .Success(let data):
                planetsArray = data
            case .Error(let message) :
                isError = (true,message)
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PlanetsView()
    }
}
#endif


struct DetailView: View
{
    let planet: Planet?
    var body: some View {
        ZStack{
            Image("ListBackground")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                if planet == nil {
                    Text(Constants().KPlanetDetailsError).fontWeight(.bold).font(.system(size: 20)).foregroundColor(.orange)
                } else {
                    ZStack {
                        Circle().stroke(Color.white, lineWidth: 2).frame(width: 250.0, height: 250.0)
                        Text((planet?.name)!).fontWeight(.bold).font(Font.custom("Pacifico-Regular", size: 40)).foregroundColor(.orange)
                        
                    }
                    Divider()
                    VStack(){
                        Text("Diameter : \((planet?.diameter)!)").fontWeight(.regular).font(.system(size: 22)).foregroundColor(.white)
                            .padding(.bottom,5)
                        Text("Climate : \((planet?.climate)!)").fontWeight(.regular).font(.system(size: 22)).foregroundColor(.white)
                            .padding(.bottom,5)
                        Text("Terrian : \((planet?.terrain)!)").fontWeight(.regular).font(.system(size: 22)).foregroundColor(.white)
                            .padding(.bottom,5)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .allowsTightening(true)
                        Text("Population : \((planet?.population)!)").fontWeight(.regular).font(.system(size: 22)).foregroundColor(.white)
                    }
                    Spacer()
                }
            }
            
        }
    }
}
