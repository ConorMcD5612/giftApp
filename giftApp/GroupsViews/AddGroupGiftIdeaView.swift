//
//  AddGroupGiftIdeaView
//  giftApp
//
//  Created by jmathies on 12/1/24.
//

import SwiftUI

struct AddGroupGiftIdeaView: View {
    @EnvironmentObject var appController: AppController
    @EnvironmentObject var settings: GroupsViewModel
    @Environment(\.dismiss) private var dismiss

    @State var name: String = ""
    @State var giftingDate: Date = Date()
    @State var description: String = ""
    @State var link: String = ""
    
    @State var confirmation: Bool = false
    @State var expectedGiftingDate: Bool = false
    
    @Binding var recipient: User?
    @Binding var group: Group
    
    var MAX_NAME_LENGTH: Int = 32
    var MAX_DESCRIPTION_LENGTH: Int = 320
    
    var body: some View {
        VStack(spacing: 10) {
            VStack(spacing: 0) {
                StyledTextField(title: "Gift Idea", text: "Enter idea here", entry: $name, characterLimit: MAX_NAME_LENGTH, hideLimit: false, autoCapitalization: UITextAutocapitalizationType.none)
                HStack {
                    Text("Required")
                        .font(.system(size: 16))
                        .foregroundStyle(.gray)
                    Spacer()
                }
            }
            
            Divider()
            
            VStack(spacing: 5) {
                HStack {
                    Text("Gifting Date")
                        .font(.system(size: 20))
                    Spacer()
                }
                if (expectedGiftingDate) {
                    HStack {
                        DatePicker("", selection: $giftingDate, displayedComponents: .date)
                            .frame(width: 135)
                        Button("Remove", role: .destructive) {
                            expectedGiftingDate = false
                        }
                        Spacer()
                    }
                } else {
                    HStack {
                        Button("Add") {
                            expectedGiftingDate = true
                        }
                        Spacer()
                    }
                }
            }.padding([.top])
            
            Divider()
            StyledTextField(title: "Link", text: "Enter link here", entry: $link, autoCapitalization: UITextAutocapitalizationType.none)
            
            Divider()
            StyledTextEditor(title: "Description", entry: $description, characterLimit: MAX_DESCRIPTION_LENGTH)
            
            Spacer()
        }.padding([.leading, .trailing], 20)
        .padding([.top, .bottom], 10)
        
        .onChange(of: name) {
            // Removes any leading whitespaces and limits input to letters and spaces
            name = String(
                    name[(name.firstIndex(where: { !$0.isWhitespace }) ?? name.startIndex)...]
                )
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar() {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Creating New Gift Idea").font(.headline)
                    Text("For \(recipient?.name ?? "")").font(.subheadline)
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    if (name.count != 0 || expectedGiftingDate || link.count != 0 || description.count != 0) {
                        confirmation = true
                    } else {
                        dismiss()
                    }
                }.confirmationDialog("Are you sure you want to discard this new gift idea?", isPresented: $confirmation, titleVisibility: .visible) {
                    Button("Discard Changes", role: .destructive) {
                        confirmation = false
                        dismiss()
                    }
                    Button("Cancel", role: .cancel) {
                        confirmation = false
                    }
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    settings.addGiftIdea(groupID: group.id ?? "", memberID: recipient?.id ?? "", giftIdea: GroupGiftIdea(name: name, description: description, link: link, creationDate: Date.now, giftingDate: giftingDate, creator: appController.userViewModel?.user?.id ?? "", comments: []))
                    dismiss()
                }.disabled(name.count == 0)
            }
        }
    }
}
