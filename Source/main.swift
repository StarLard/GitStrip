//
//  main.swift
//  Stripper
//
//  Created by Friden, Caleb on 8/5/19.
//  Copyright © 2019 Friden, Caleb. All rights reserved.
//

import Foundation
import AppKit

guard let input = readLine(), !input.isEmpty else {
    exit(EXIT_SUCCESS)
}

extension String {
    
    func removeCharacters(from forbiddenChars: CharacterSet) -> String {
        let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }
    
    func removeCharacters(from: String) -> String {
        return removeCharacters(from: CharacterSet(charactersIn: from))
    }
}

var components = input
    .removeCharacters(from: "()\n.~^:/\\`")
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .replacingOccurrences(of: " ", with: "_")
    .split(separator: "_", maxSplits: 1)
    .map(String.init)

if components.count > 1 {
    components = components.map { $0.lowercased() }
}
if components.count > 0 {
    components[0] = components[0].uppercased()
}

let outputCharsAll = Array(components.joined(separator: "_"))
var outputCharsStripped = [String.Element]()
for (index, char) in outputCharsAll.enumerated() {
    if char != " " && char != "_" {
        outputCharsStripped.append(char)
    } else if index + 1 < outputCharsAll.count && outputCharsAll[index + 1] != char {
        outputCharsStripped.append(char)
    }
}
let output = String(outputCharsStripped)
let pasteboard = NSPasteboard.general
pasteboard.declareTypes([.string], owner: nil)
pasteboard.setString(output, forType: .string)
print("\"\(output)\" copied to pasteboard!")
exit(EXIT_SUCCESS)
