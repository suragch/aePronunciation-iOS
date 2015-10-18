//
//  String+localized.swift
//  aePronunciation
//
//  Created by MongolSuragch on 10/2/15.
//  Copyright © 2015 Suragch. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}