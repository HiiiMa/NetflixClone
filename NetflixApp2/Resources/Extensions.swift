//
//  Extensions.swift
//  TheNitflex
//
//  Created by ibrahim alasl on 22/07/2024.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
