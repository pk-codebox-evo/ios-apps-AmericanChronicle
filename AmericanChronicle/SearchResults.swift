//
//  SearchResults.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/20/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import ObjectMapper

class SearchResults: NSObject, Mappable {

    // MARK: Properties

    var totalItems: Int?
    var endIndex: Int?
    var startIndex: Int?
    var itemsPerPage: Int = 20
    var items: [SearchResult]?
    var allItemsLoaded: Bool {
        return items?.count >= totalItems
    }
    var numLoadedPages: Int {
        return Int(ceilf(Float(items?.count ?? 0)/Float(itemsPerPage)))
    }

    override init() {
        super.init()
    }

    // MARK: Mappable methods

    required init?(_ map: Map) {
        super.init()
    }

    static func newInstance(map: Map) -> Mappable? {
        return SearchResults(map)
    }

    func mapping(map: Map) {
        totalItems <- map["totalItems"]
        endIndex <- map["endIndex"]
        startIndex <- map["startIndex"]
        itemsPerPage <- map["itemsPerPage"]
        items <- map["items"]
    }

    // MARK: NSObject overrides

    override var description: String {
        let empty = "(nil)"
        var str = "<\(self.dynamicType) \(unsafeAddressOf(self)):"
        str += " totalItems=\(totalItems?.description ?? empty)"
        str += ", endIndex=\(endIndex?.description ?? empty)"
        str += ", startIndex=\(startIndex?.description ?? empty)"
        str += ", itemsPerPage=\(itemsPerPage.description ?? empty)"
        str += ", items.count=\(items?.count ?? 0)"
        str += ">"
        return str
    }
}