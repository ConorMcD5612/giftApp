//
//  PeopleView.swift
//  giftApp
//
//  Created by jmathies on 10/16/24.
//

import SwiftUI

struct PeopleView: View {
    @State var searchEntry: String = ""
    
    @State var selectedPerson: String = ""
    
    @State var people: [Person] = []
    
    @State var confirmation: Bool = false
    
    // Conditions
    @State var personSelected: Bool = false
    @State var addingPerson: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // People title and add person button
                HStack {
                    Text("People")
                    Spacer()
                    Button("+") {
                        addingPerson = true
                    }
                }.font(.largeTitle)
                    .padding([.leading, .trailing])
                
                // Search bar
                SearchField(searchEntry: $searchEntry)
                    .padding([.leading, .trailing])
                
                ScrollView(showsIndicators: false) {
                    if (people.count > 0) {
                        VStack {
                            ForEach(people) {person in
                                IconButton(text: person.name) {
                                    selectedPerson = person.name
                                    personSelected = true
                                }
                            }
                        }
                    } else {
                        Text("You haven't added any people yet!")
                            .font(.system(size: 20))
                    }
                }.scrollBounceBehavior(.basedOnSize)
                .padding([.top, .bottom])
                
            }
            .navigationDestination(isPresented: $addingPerson) {
                AddPeopleView(addPerson: $addingPerson, people: $people)
            }
        }
    }
}

#Preview {
    PeopleView()
}
