//
//  MissionDetail.swift
//  Animations
//
//  Created by Jinchao Hou on 2/1/20.
//  Copyright © 2020 Jinchao Hou. All rights reserved.
//

import SwiftUI

struct MissionDetail: View {
    private var missions: [Mission] = Bundle.main.decode("missions.json")
    struct CrewMember {
        let role: String
        let astronaut: AStronaut
    }
    
    let mission: Mission
    let astronauts: [CrewMember]
    
    var body: some View {
        GeometryReader {geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.7)
                        .padding(.top)
                    
                    Text(self.mission.description)
                        .padding()
                    
                    ForEach(self.astronauts, id: \.role) { crewMember in
                        NavigationLink(destination: AstronauntDetailView(astronaut: crewMember.astronaut, missions: self.missions)) {
                            HStack{
                                Image(crewMember.astronaut.id)
                                .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                                
                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .font(.headline)
                                    Text(crewMember.role)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                            //fix the crewmember image
                    .buttonStyle(PlainButtonStyle())
                    }
                    
                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
    }
    
    init(mission: Mission, astronauts: [AStronaut]) {
        self.mission = mission
        
        var matches = [CrewMember]()
        
        for member in mission.crew {
            if let match = astronauts.first(where: { $0.id == member.name}) {
                matches.append(CrewMember(role: member.role, astronaut: match))
            } else {
                fatalError("Missing \(member))")
            }
        }
        
        self.astronauts = matches
    }
    
}

struct MissionDetail_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [AStronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        MissionDetail(mission: missions[0], astronauts: astronauts)
    }
}
