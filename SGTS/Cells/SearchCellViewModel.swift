//
//  SearchViewModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 15.06.2024.
//

import Foundation
import DifferenceKit


struct SearchViewModel {
    let id: AnyHashable
    let backColor: UIColor

    let isSearchBarDisplaying: Bool
    let searchBarAttributedPlaceholder: NSAttributedString
    let searchText: String
    let searchIcon: UIImage

    let searchTextColor: UIColor
    let separatorColor: UIColor
    let insets: UIEdgeInsets

    init(id: AnyHashable, backColor: UIColor, isSearchBarDisplaying: Bool, searchBarAttributedPlaceholder: NSAttributedString, searchText: String, searchIcon: UIImage, searchTextColor: UIColor, separatorColor: UIColor, insets: UIEdgeInsets) {
        self.id = id
        self.backColor = backColor
        self.isSearchBarDisplaying = isSearchBarDisplaying
        self.searchBarAttributedPlaceholder = searchBarAttributedPlaceholder
        self.searchText = searchText
        self.searchIcon = searchIcon
        self.searchTextColor = searchTextColor
        self.separatorColor = separatorColor
        self.insets = insets
    }
}

extension SearchViewModel: Differentiable {
    var differenceIdentifier: AnyHashable {
        id
    }

    func isContentEqual(to source: SearchViewModel) -> Bool {
        source.backColor == backColor &&
        source.isSearchBarDisplaying == isSearchBarDisplaying &&
        source.searchBarAttributedPlaceholder == searchBarAttributedPlaceholder &&
        source.searchText == searchText &&
        source.searchIcon == searchIcon &&
        source.searchTextColor == searchTextColor &&
        source.separatorColor == separatorColor &&
        source.insets == insets
    }
}

