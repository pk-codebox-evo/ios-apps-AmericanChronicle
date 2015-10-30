//
//  CachedPageService.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/24/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

public protocol CachedPageServiceInterface {
    func fileURLForRemoteURL(remoteURL: NSURL) -> NSURL?
    func cacheFileURL(fileURL: NSURL, forRemoteURL remoteURL: NSURL)
}

public class CachedPageService: CachedPageServiceInterface {
    private var completedDownloads: [NSURL: NSURL] = [:]
    public func fileURLForRemoteURL(remoteURL: NSURL) -> NSURL? {
        return completedDownloads[remoteURL]
    }
    public func cacheFileURL(fileURL: NSURL, forRemoteURL remoteURL: NSURL) {
        completedDownloads[remoteURL] = fileURL
    }
}
