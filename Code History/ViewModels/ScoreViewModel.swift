//
//  ScoreViewModel.swift
//  Code History
//
//  Created by Эдуард Кудянов on 30.06.23.
//

import Foundation

struct ScoreViewModel {
    let correctGuesses: Int
    let incorrectGuesses: Int
    
    var percentage: Int {
        (correctGuesses * 100 / (correctGuesses + incorrectGuesses))
    }
}
