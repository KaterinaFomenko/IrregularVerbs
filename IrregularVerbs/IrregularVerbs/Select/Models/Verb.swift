//
//  Verb.swift
//  Words App HM
//
//  Created by Katerina on 25/11/2023.
//

import Foundation
import UIKit

struct Verb {
    let infinitive: String
    let pastSimple: String
    let participle: String
    var translation: String {
        NSLocalizedString(self.infinitive, comment: "")
    }
}
