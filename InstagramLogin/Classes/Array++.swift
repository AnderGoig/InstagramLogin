//
//  Array++.swift
//  InstagramLogin
//
//  Created by Ander Goig on 2/11/17.
//  Copyright © 2017 Ander Goig. All rights reserved.
//

extension Array where Element == InstagramScope {

    func joined(separator: String) -> String {
        return self.map({ "\($0.rawValue)" }).joined(separator: separator)
    }
}
