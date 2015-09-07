//
//  SearchResults.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/20/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import ObjectMapper

public class SearchResults: NSObject, Mappable {

    // MARK: Properties

    var totalItems: Int?
    var endIndex: Int?
    var startIndex: Int?
    var itemsPerPage: Int?
    public var items: [SearchResult]?

    public override init() {
        super.init()
    }

    // MARK: Mappable methods

    public required init?(_ map: Map) {
        super.init()
    }

    public static func newInstance(map: Map) -> Mappable? {
        return SearchResults(map)
    }

    public func mapping(map: Map) {
        totalItems <- map["totalItems"]
        endIndex <- map["endIndex"]
        startIndex <- map["startIndex"]
        itemsPerPage <- map["itemsPerPage"]
        items <- map["items"]
    }

    // MARK: NSObject overrides

    override public var description: String {
        let empty = "(nil)"
        var str = "<\(self.dynamicType) \(unsafeAddressOf(self)):"
        str += " totalItems=\(totalItems?.description ?? empty)"
        str += ", endIndex=\(endIndex?.description ?? empty)"
        str += ", startIndex=\(startIndex?.description ?? empty)"
        str += ", itemsPerPage=\(itemsPerPage?.description ?? empty)"
        str += ", items.count=\(items?.count ?? 0)"
        str += ">"
        return str
    }
}