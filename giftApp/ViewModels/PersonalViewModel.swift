//
//  Controller.swift
//  giftApp
//
//  Created by jmathies on 11/25/24.
//
//  Contains, loads and saves data necessary for PersonalMainView
//

import SwiftUICore

class PersonalViewModel: ObservableObject {
    enum Views {
        case addRecipient, viewGiftIdeaList, editRecipient, addGiftIdea, viewGiftIdea, editGiftIdea
    }
    
    // Set to false after changing data structures
    let loadFromFile: Bool = true
            
    let personalGiftIdeasArchive: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("personal-gift-ideas.json")
    } ()
    
    @Published var recipients: [Recipient]
    @Published var path: [Views]
    @Published var selectedRecipient: Recipient
    @Published var selectedGiftIdea: RecipientGiftIdea
    
    init() {
        if loadFromFile {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: personalGiftIdeasArchive.path) {
                print("loading data from system")
                self.recipients = load(personalGiftIdeasArchive)
            } else {
                print("no file found")
                // No file; no recipients
                self.recipients = []
            }
        } else {
            self.recipients = []
        }
        
        self.path = []
        // Placeholders; never get utilized; don't wanna deal with optionals (prob worth turning into optionals)
        self.selectedRecipient = Recipient(name: "", birthmonth: nil, birthday: nil, interests: "")
        self.selectedGiftIdea = RecipientGiftIdea(name: "", description: "", link: "", creationDate: Date(), giftingDate: nil)
    }
    
    @discardableResult
    func saveChanges() -> Bool {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(recipients)
        try data.write(to: personalGiftIdeasArchive, options: [.atomic])
            print("saved data to system")
            return true
        } catch let encodingError {
            print("Error encoding allItems: \(encodingError)")
            return false
        }
    }
    
    func remove(recipient: Recipient) {
        for i in 0...(recipients.count - 1) {
            if recipients[i].id == recipient.id {
                recipients.remove(at: i)
            }
        }
    }
}

func load<T: Decodable>(_ url: URL) -> T {
    let data: Data
    do {
        data = try Data(contentsOf: url)
    } catch {
    fatalError("Couldn't load \(url.path) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        print("parse \(url.path)")
        // if you get this error, set loadFromFile to false
        fatalError("Couldn't parse \(url.path) as \(T.self):\n\(error)")
    }
}
