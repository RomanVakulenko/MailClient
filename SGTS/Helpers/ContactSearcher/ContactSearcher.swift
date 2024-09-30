//
//  ContactSearcher.swift
// 31.07.2024.
//

import Foundation

class ContactSearcher {
    static let shared = ContactSearcher()
    private init() {}
    
    private let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"
    private let contactManager = DIManager.shared.container.resolve(ContactManagerProtocol.self)!
    private var currentIndex = 0
    
    func startSearching() {
        searchNextCharacter()
    }
    
    private func searchNextCharacter() {
        guard currentIndex < characters.count else {
            print("Search completed for all characters.")
            return
        }
        
        let character = characters[characters.index(characters.startIndex, offsetBy: currentIndex)]
        let query = String(character)
        
        print("Searching contacts for query: \(query)")
        
        contactManager.searchContacts(by: query) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let contacts):
                print("Found \(contacts.count) contacts for query: \(query)")
                // You can process contacts here if needed
            case .failure(let error):
                print("Failed to search contacts for query \(query): \(error.localizedDescription)")
            }
            
            // Move to the next character
            self.currentIndex += 1
            self.searchNextCharacter()
        }
    }
}
