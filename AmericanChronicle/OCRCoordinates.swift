//
//  OCRCoordinates.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 11/22/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import ObjectMapper

public class OCRCoordinates: NSObject, Mappable {

    // MARK: Properties

    public var width: CGFloat?
    public var height: CGFloat?
    public var wordCoordinates: [String: [CGRect]]?

    // MARK: Mappable methods

    public required init?(_ map: Map) {
        super.init()
    }

    public static func newInstance(map: Map) -> Mappable? {
        return OCRCoordinates(map)
    }

    public func mapping(map: Map) {
        let floatTransform = TransformOf<CGFloat, String>(fromJSON: { (val: String?) in
            return CGFloat((val ?? "" as NSString).doubleValue)
        }, toJSON: { (val: CGFloat?) in
            return nil
        })
        width <- (map["width"], floatTransform)
        height <- (map["height"], floatTransform)
        let transform = TransformOf<[String: [CGRect]], [String: [[String]]]>(fromJSON: { (jsonDict: [String: [[String]]]?) in
            var returnVal: [String: [CGRect]] = [:]
            for item in (jsonDict ?? [:]) {
                let rectArrays = item.1
                let rects = rectArrays.map { (rectArray: [String]) -> CGRect in
                    let x = (rectArray[0] as NSString).doubleValue
                    let y = (rectArray[1] as NSString).doubleValue
                    let w = (rectArray[2] as NSString).doubleValue
                    let h = (rectArray[3] as NSString).doubleValue
                    return CGRect(x: x, y: y, width: w, height: h)
                }
                returnVal[item.0] = rects
            }
            return returnVal
        }, toJSON: { (val: [String: [CGRect]]?) in
            return nil
        })

        wordCoordinates <- (map["coords"], transform)
    }

    // MARK: NSObject overrides

    override public var description: String {
        let empty = "(nil)"
        var str = "<\(self.dynamicType) \(unsafeAddressOf(self)):"
        str += " width=\(width?.description ?? empty)"
        str += ", height=\(height?.description ?? empty)"
        str += ", wordCoordinates=\(wordCoordinates?.description ?? empty)"
        str += ">"
        return str
    }
}
