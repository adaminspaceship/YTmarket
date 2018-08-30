//
//  searchChannel.swift
//  YT Market
//
//  Created by Adam Eliezerov on 28/08/2018.
//  Copyright © 2018 Adam Eliezerov. All rights reserved.
//

import Foundation

class SearchChannel {
    var channelName1 = String()
    var thumbnailURL1 = String()
    var subCount1 = Int()
    var channelID1 = String()
    var channelDesc1 = String()
    
    init(channelName: String, thumbnailURL: String, subCount: Int, channelID: String, channelDesc: String) {
        channelName1 = channelName
        thumbnailURL1 = thumbnailURL
        subCount1 = subCount
        channelID1 = channelID
        channelDesc1 = channelDesc
    }
}
