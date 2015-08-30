//
//  FakeData.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/29/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import SwiftMoment

enum BrowseResultImageName: String {
    case HolbrookNews = "page-holbrook_news-browse"
    case ImageHeavy0 = "page-image_heavy_0-browse"
    case TextHeavy0 = "page-text_heavy_0-browse"
    case WilliamsNewsEliWolf = "page-williams_news-eli_wolf-browse"
}

enum SearchResultImageName: String {
    case ImageHeavy1 = "page-image_heavy_1-search"
    case ImageHeavy2 = "page-image_heavy_2-search"
    case PoorQuality0 = "page-poor_quality_0-search"
    case TextHeavy1 = "page-text_heavy_1-search"
    case TextHeavy2 = "page-text_heavy_2-search"
    case TextHeavy3 = "page-text_heavy_3-search"
    case WilliamsNewsEliWolfSearch = "page-williams_news-eli_wolf-search"
    case WilliamsNewsMisc0 = "page-williams_news-misc_0-search"
    case WilliamsNewsMisc1 = "page-williams_news-misc_1-search"
}

class FakeData {

    class func statesByName() -> [StateName: State] {
        var statesByName = [StateName: State]()
        statesByName[.Alabama] = alabama()
        statesByName[.Arizona] = arizona()
        statesByName[.Arkansas] = arkansas()
        return statesByName
    }

    // MARK: Alabama

    private class func alabama() -> State {
        var selma = City(name: "Selma", lat: 0, lng: 0, stateName: .Alabama, newspapers: [])
        selma.newspapers.append(Newspaper(title: "Chattanooga daily rebel.", city: selma, startYear: 1865, endYear: 1865, issues: []))
        return State(name: .Alabama, lat: 0, lng: 0, cities: [selma])
    }

    // MARK: Arizona

    private class func holbrook() -> City {
        var holbrook = City(name: "Holbrook", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
        let holbrookIssues = [
            NewspaperIssue(date: moment([1902, 10, 02])!, imageName: "the_holbrook_news", pages: [
                NewspaperPage(imageName: BrowseResultImageName.HolbrookNews.rawValue)
            ])
        ]
        holbrook.newspapers.append(Newspaper(title: "The argus", city: holbrook, startYear: 1895, endYear: 1900, issues: holbrookIssues))
        return holbrook
    }

    private class func peachSprings() -> City {
        var peachSprings = City(name: "Peach Springs", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
        let peachSpringsIssues = [NewspaperIssue(date: moment([1902, 10, 02])!, imageName: "the_williams_news_2", pages: [
            NewspaperPage(imageName: BrowseResultImageName.ImageHeavy0.rawValue)
            ])]
        peachSprings.newspapers.append(Newspaper(title: "The Arizona champion", city: peachSprings, startYear: 1883, endYear: 1891, issues: peachSpringsIssues))
        return peachSprings
    }

    private class func tucson() -> City {
        var tucson = City(name: "Tucson", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])

        let tucsonIssues = [
            NewspaperIssue(date: moment([1870, 10, 17])!, imageName: "the_holbrook_news", pages: [
                NewspaperPage(imageName: BrowseResultImageName.ImageHeavy0.rawValue)
                ])
        ]
        tucson.newspapers.append(Newspaper(title: "Arizona citizen", city: tucson, startYear: 1870, endYear: 1880, issues: tucsonIssues))
        return tucson
    }

    private class func bisbee() -> City {
        var bisbee = City(name: "Bisbee", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
        let bisbeeIssues = [NewspaperIssue(date: moment([1902, 10, 02])!, imageName: "the_holbrook_news", pages: [
            NewspaperPage(imageName: BrowseResultImageName.ImageHeavy0.rawValue)
            ])]
        bisbee.newspapers.append(Newspaper(title: "The Arizona daily orb", city: bisbee, startYear: 1898, endYear: 1900, issues: bisbeeIssues))
        return bisbee
    }

    private class func tombstone() -> City {
        var tombstone = City(name: "Tombstone", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
        let tombstoneIssues = [NewspaperIssue(date: moment([1902, 10, 02])!, imageName: "the_holbrook_news", pages: [
            NewspaperPage(imageName: BrowseResultImageName.ImageHeavy0.rawValue)
            ])]
        tombstone.newspapers.append(Newspaper(title: "The Arizona kicker", city: tombstone, startYear: 1893, endYear: 1913, issues: tombstoneIssues))
        return tombstone
    }

    private class func fortWhipple() -> City {
        var fortWhipple = City(name: "Fort Whipple", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
        let fortWhippleIssues = [NewspaperIssue(date: moment([1902, 10, 02])!, imageName: "the_holbrook_news", pages: [
            NewspaperPage(imageName: BrowseResultImageName.ImageHeavy0.rawValue)
            ])]
        fortWhipple.newspapers.append(Newspaper(title: "Arizona miner", city: fortWhipple, startYear: 1864, endYear: 1868, issues: fortWhippleIssues))
        return fortWhipple
    }

    private class func phoenix() -> City {
        var phoenix = City(name: "Phoenix", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
        let phoenixIssues = [NewspaperIssue(date: moment([1902, 10, 02])!, imageName: "the_holbrook_news", pages: [
            NewspaperPage(imageName: BrowseResultImageName.ImageHeavy0.rawValue)
            ])]
        phoenix.newspapers.append(Newspaper(title: "Arizona republican", city: phoenix, startYear: 1890, endYear: 1930, issues: phoenixIssues))
        return phoenix
    }

    private class func williams() -> City {
        var williams = City(name: "Williams", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
        let williamsIssues = [
            NewspaperIssue(date: moment([1902, 10, 17])!, imageName: "the_williams_news_2", pages: [
                NewspaperPage(imageName: BrowseResultImageName.ImageHeavy0.rawValue),
                NewspaperPage(imageName: BrowseResultImageName.TextHeavy0.rawValue),
            ]),

            NewspaperIssue(date: moment([1902, 10, 22])!, imageName: "the_williams_news_3", pages: [
                NewspaperPage(imageName: BrowseResultImageName.ImageHeavy0.rawValue),
                NewspaperPage(imageName: BrowseResultImageName.TextHeavy0.rawValue)
            ]),

            NewspaperIssue(date: moment([1902, 10, 29])!, imageName: "the_williams_news_2", pages: [
                NewspaperPage(imageName: BrowseResultImageName.ImageHeavy0.rawValue),
                NewspaperPage(imageName: BrowseResultImageName.TextHeavy0.rawValue)
            ]),

            NewspaperIssue(date: moment([1902, 11, 05])!, imageName: "the_williams_news_3", pages: [
                NewspaperPage(imageName: BrowseResultImageName.ImageHeavy0.rawValue),
                NewspaperPage(imageName: BrowseResultImageName.TextHeavy0.rawValue)
            ])
        ]
        williams.newspapers.append(Newspaper(title: "Williams news.", city: williams, startYear: 1901, endYear: 1922, issues: williamsIssues))
        return williams
    }

    private class func arizona() -> State {
        return State(name: .Arizona, lat: 0, lng: 0, cities: [holbrook(), peachSprings(), tucson(), bisbee(), tombstone(), fortWhipple(), phoenix(), williams()])
    }

    private class func arkansas() -> State {
        var holbrook = City(name: "Holbrook", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
        var paper = Newspaper(title: "The argus", city: holbrook, startYear: 1895, endYear: 1900, issues: [])
        holbrook.newspapers.append(paper)
        return State(name: .Arkansas, lat: 0, lng: 0, cities: [holbrook])
    }
}