//
//  DiningData.swift
//  Dining App
//
//  Created by Udit Garg on 9/20/21.
//

import Foundation
import SwiftUI
import UIKit

// STRUCTURE FOR RETRIEVING DATA FROM PENN LABS API

struct documentData: Codable {
    var document = [String: [venue]]()
}

struct venue: Codable {
    var dateHours: [dates]
    let facilityURL: String
    let imageURL: String?
    let name: String
}

struct dates: Codable {
    let date: String
    var meal: [mealType]
}

struct mealType: Codable {
    var close: String = ""
    var open: String = ""
    var type: String = ""
}


