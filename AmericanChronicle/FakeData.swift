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

    static let searchResultsMiss: TableViewData = {
        let data = TableViewData()
        data.sections.append(TableViewSection(title: "6 matches", rows: [
            SearchResultsRow(
                date: "Mar 14, 1889",
                cityState: "Scranton, PA",
                matchingText: "...Der befannte Runftbaudler Elie Wolf in Bajeljtadt...",
                publicationTitle: "Scranton Wochenblatt",
                moreMatchesCount: "",
                imageName: SearchResultImageName.ImageHeavy1.rawValue),
            SearchResultsRow(
                date: "Dec 10, 1903",
                cityState: "Logan, OH",
                matchingText: "...the home of Mesers Wolf and Grossman on East Hunter...",
                publicationTitle: "The Ohio Democrat",
                moreMatchesCount: "",
                imageName: SearchResultImageName.ImageHeavy2.rawValue),
            SearchResultsRow(
                date: "Jan 09, 1920",
                cityState: "Plentywood, MO",
                matchingText: "...and Mrs. Eli Maltby of Wolf Point, spent her holiday...",
                publicationTitle: "The Producers News",
                moreMatchesCount: "",
                imageName: SearchResultImageName.PoorQuality0.rawValue),
            SearchResultsRow(
                date: "Jul 07, 1905",
                cityState: "Canton, OH",
                matchingText: "...Reeder on the saw-mill. Eliza Wolf has returned home...",
                publicationTitle: "The Stark County Democrat",
                moreMatchesCount: "",
                imageName: SearchResultImageName.TextHeavy1.rawValue),
            SearchResultsRow(
                date: "Mar 08, 1921",
                cityState: "Astoria, OR",
                matchingText: "...kohtalosta. Beethoven eli Wienissa edelleenkin. V. 1806...",
                publicationTitle: "Toveritar",
                moreMatchesCount: "and 5 more",
                imageName: SearchResultImageName.TextHeavy2.rawValue),
            SearchResultsRow(
                date: "Dec 03, 1898",
                cityState: "Maysville, KY",
                matchingText: "...it many new cases. Eli Perkins. Eli Perkins. Mr Perkins'...",
                publicationTitle: "The Evening Bulletin",
                moreMatchesCount: "and 1 more",
                imageName: SearchResultImageName.TextHeavy3.rawValue)
            ]))
        return data
        }()

    static let searchResultsHit: TableViewData = {
        let data = TableViewData()
        data.sections.append(TableViewSection(title: "4 matches", rows: [
            SearchResultsRow(
                date: "Sep 20, 1902",
                cityState: "Williams, AZ",
                matchingText: "...in this city, Eli W. Wolf, aged seventy-one years...",
                publicationTitle: "Williams News",
                moreMatchesCount: "and 3 more",
                imageName: SearchResultImageName.WilliamsNewsEliWolfSearch.rawValue
            ), SearchResultsRow(
                date: "Feb 03, 1922",
                cityState: "Williams, AZ",
                matchingText: "...the death of Calvin M. Wolfe in Phoenix, Arizona, on...",
                publicationTitle: "Williams News",
                moreMatchesCount: "and 9 more",
                imageName: SearchResultImageName.WilliamsNewsMisc0.rawValue
            ), SearchResultsRow(
                date: "Dec 19, 1919",
                cityState: "Holbrook, AZ",
                matchingText: "...Braam, Messrs. Sims Ely, Williams, Kelley, Wolfe...",
                publicationTitle: "The Holbrook News",
                moreMatchesCount: "",
                imageName: SearchResultImageName.WilliamsNewsMisc1.rawValue
            ), SearchResultsRow(
                date: "Aug 10, 1916",
                cityState: "Williams, AZ",
                matchingText: "...Williams News. Fred Wolfe took out a new Maxwell...",
                publicationTitle: "Williams News",
                moreMatchesCount: "and 3 more",
                imageName: SearchResultImageName.PoorQuality0.rawValue)
            ]))
        return data
        }()

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
        selma.newspapers.append(Newspaper(title: "Chattanooga Daily Rebel", city: selma, startYear: 1865, endYear: 1865, issues: []))
        return State(name: .Alabama, lat: 0, lng: 0, cities: [selma])
    }

    // MARK: Arizona

    private class func holbrook() -> City {
        var holbrook = City(name: "Holbrook", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
        let holbrookIssues = [
            NewspaperIssue(date: moment([1902, 10, 02])!, pages: [
                NewspaperPage(imageName: BrowseResultImageName.HolbrookNews.rawValue)
            ])
        ]
        holbrook.newspapers.append(Newspaper(title: "The Argus", city: holbrook, startYear: 1895, endYear: 1900, issues: holbrookIssues))
        return holbrook
    }

    private class func peachSprings() -> City {
        var peachSprings = City(name: "Peach Springs", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
        let peachSpringsIssues = [NewspaperIssue(date: moment([1902, 10, 02])!, pages: [
            NewspaperPage(imageName: BrowseResultImageName.ImageHeavy0.rawValue)
            ])]
        peachSprings.newspapers.append(Newspaper(title: "The Arizona Champion", city: peachSprings, startYear: 1883, endYear: 1891, issues: peachSpringsIssues))
        return peachSprings
    }

    private class func tucson() -> City {
        var tucson = City(name: "Tucson", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])

        let tucsonIssues = [
            NewspaperIssue(date: moment([1870, 10, 17])!, pages: [
                NewspaperPage(imageName: BrowseResultImageName.ImageHeavy0.rawValue)
                ])
        ]
        tucson.newspapers.append(Newspaper(title: "Arizona Citizen", city: tucson, startYear: 1870, endYear: 1880, issues: tucsonIssues))
        return tucson
    }

    private class func bisbee() -> City {
        var bisbee = City(name: "Bisbee", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
        let bisbeeIssues = [NewspaperIssue(date: moment([1902, 10, 02])!, pages: [
            NewspaperPage(imageName: BrowseResultImageName.ImageHeavy0.rawValue)
            ])]
        bisbee.newspapers.append(Newspaper(title: "The Arizona Daily Orb", city: bisbee, startYear: 1898, endYear: 1900, issues: bisbeeIssues))
        return bisbee
    }

    private class func tombstone() -> City {
        var tombstone = City(name: "Tombstone", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
        let tombstoneIssues = [NewspaperIssue(date: moment([1902, 10, 02])!, pages: [
            NewspaperPage(imageName: BrowseResultImageName.ImageHeavy0.rawValue)
            ])]
        tombstone.newspapers.append(Newspaper(title: "The Arizona Kicker", city: tombstone, startYear: 1893, endYear: 1913, issues: tombstoneIssues))
        return tombstone
    }

    private class func fortWhipple() -> City {
        var fortWhipple = City(name: "Fort Whipple", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
        let fortWhippleIssues = [NewspaperIssue(date: moment([1902, 10, 02])!, pages: [
            NewspaperPage(imageName: BrowseResultImageName.ImageHeavy0.rawValue)
            ])]
        fortWhipple.newspapers.append(Newspaper(title: "Arizona Miner", city: fortWhipple, startYear: 1864, endYear: 1868, issues: fortWhippleIssues))
        return fortWhipple
    }

    private class func phoenix() -> City {
        var phoenix = City(name: "Phoenix", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
        let phoenixIssues = [NewspaperIssue(date: moment([1902, 10, 02])!, pages: [
            NewspaperPage(imageName: BrowseResultImageName.ImageHeavy0.rawValue)
            ])]
        phoenix.newspapers.append(Newspaper(title: "Arizona Republican", city: phoenix, startYear: 1890, endYear: 1930, issues: phoenixIssues))
        return phoenix
    }

    private class func williams() -> City {
        var williams = City(name: "Williams", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
        let williamsIssues = [
            NewspaperIssue(date: moment([1902, 10, 17])!, pages: [
                NewspaperPage(imageName: BrowseResultImageName.TextHeavy0.rawValue),
                NewspaperPage(imageName: BrowseResultImageName.ImageHeavy0.rawValue),
            ]),

            NewspaperIssue(date: moment([1902, 10, 22])!, pages: [
                NewspaperPage(imageName: BrowseResultImageName.ImageHeavy0.rawValue),
                NewspaperPage(imageName: BrowseResultImageName.TextHeavy0.rawValue)
            ]),

            NewspaperIssue(date: moment([1902, 10, 29])!, pages: [
                NewspaperPage(imageName: BrowseResultImageName.TextHeavy0.rawValue),
                NewspaperPage(imageName: BrowseResultImageName.ImageHeavy0.rawValue),
                NewspaperPage(imageName: BrowseResultImageName.TextHeavy0.rawValue),
                NewspaperPage(imageName: BrowseResultImageName.ImageHeavy0.rawValue)
            ]),

            NewspaperIssue(date: moment([1902, 11, 05])!, pages: [
                NewspaperPage(imageName: BrowseResultImageName.ImageHeavy0.rawValue),
                NewspaperPage(imageName: BrowseResultImageName.TextHeavy0.rawValue)
            ])
        ]
        williams.newspapers.append(Newspaper(title: "Williams News", city: williams, startYear: 1901, endYear: 1922, issues: williamsIssues))
        return williams
    }

    private class func arizona() -> State {
        return State(name: .Arizona, lat: 0, lng: 0, cities: [holbrook(), peachSprings(), tucson(), bisbee(), tombstone(), fortWhipple(), phoenix(), williams()])
    }

    private class func arkansas() -> State {
        var holbrook = City(name: "Little Rock", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
        var paper = Newspaper(title: "The Gazette", city: holbrook, startYear: 1895, endYear: 1900, issues: [])
        holbrook.newspapers.append(paper)
        return State(name: .Arkansas, lat: 0, lng: 0, cities: [holbrook])
    }
}