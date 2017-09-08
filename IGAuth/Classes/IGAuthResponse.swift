//
//  IGAuthResponse.swift
//  IGAuth
//
//  Created by Ander Goig on 8/9/17.
//  Copyright © 2017 Ander Goig. All rights reserved.
//

import Foundation

public struct IGAuthResponse: Decodable {
    
    public struct IGAuthUser: Decodable {
        public let id: String
        public let username: String
        public let full_name: String
        public let profile_picture: String
    }
    
    public let access_token: String
    public let user: IGAuthUser
    
}

