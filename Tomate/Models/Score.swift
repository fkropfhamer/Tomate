//
//  Score.swift
//  Tomate
//
//  Created by Fabian Kropfhamer on 28.01.22.
//

import Foundation

class Score : ObservableObject {
    static let shared = Score()
    
    @Published private(set) var score = 0
    
    public func scored() {
        score += 1
    }
}
