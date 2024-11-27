//
//  Controller.swift
//  giftApp
//
//  Created by jmathies on 11/25/24.
//

import SwiftUI

class RecipientSettings: ObservableObject {
    enum Views {
        case addRecipient, viewGiftIdeaList, modifyRecipient, addGiftIdea, viewGiftIdea, modifyGiftIdea
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
                print("load from \(personalGiftIdeasArchive.path)")
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
        // Placeholders; never get utilized
        self.selectedRecipient = Recipient(name: "", birthday: "", interests: "")
        self.selectedGiftIdea = RecipientGiftIdea(name: "", description: "", link: "", creationDate: Date())
    }
    
    @discardableResult
    func saveChanges() -> Bool {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(recipients)
        try data.write(to: personalGiftIdeasArchive, options: [.atomic])
            print("saved data to \(personalGiftIdeasArchive)")
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
        fatalError("Couldn't parse \(url.path) as \(T.self):\n\(error)")
    }
}
