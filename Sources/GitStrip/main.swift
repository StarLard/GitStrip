//
//  main.swift
//  GitStrip
//
//  Created by Friden, Caleb on 8/5/19.
//  Copyright © 2019 Friden, Caleb. All rights reserved.
//

import Foundation
import AppKit
import ArgumentParser

struct GitStrip: ParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "git-strip",
        abstract: "A command line tool to format text into a git-friendly branch name")
    
    @Argument(help: "The text to strip.")
    var text: String
    
    @Flag(help: "Lowercase the first word in the name.")
    var lowercaseFirstWord = false
    
    mutating func run() throws {
        guard !text.isEmpty else {
            throw StripError.emptyInput
        }
        
        var strippedText = text
            .replacingOccurrences(of: "\n", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .removingCharacters(in: .invalidGitBranchCharacters)
            .replacingOccurrences(of: "..", with: "")
            .lowercased()
        
        while strippedText.hasSuffix(lockFileExtension) || strippedText.hasSuffix("/") {
            let suffixLength: Int
            if strippedText.hasSuffix(lockFileExtension) {
                suffixLength = lockFileExtension.count
            } else {
                suffixLength = 1
            }
            strippedText.removeLast(suffixLength)
        }
        
        while strippedText.hasPrefix(".") {
            strippedText.removeFirst()
        }
        
        var textComponents = strippedText
            .split(separator: " ")
            .map(String.init)
            .map { $0.trimmingCharacters(in: CharacterSet.init(charactersIn: "_")) }

        if !lowercaseFirstWord, textComponents.count > 0 {
            textComponents[0] = textComponents[0].uppercased()
        }

        let outputChars = Array(textComponents.joined(separator: "_"))
        var outputCharsStripped = [String.Element]()
        for (index, char) in outputChars.enumerated() {
            if char != " " && char != "_" {
                outputCharsStripped.append(char)
            } else if index + 1 < outputChars.count && outputChars[index + 1] != char {
                outputCharsStripped.append(char)
            }
        }
        let output = String(outputCharsStripped)
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(output, forType: .string)
        print("\"\(output)\" copied to pasteboard!")
    }
        
    private enum StripError: CustomNSError {
        case emptyInput
    }
}

private let lockFileExtension = ".lock"

extension CharacterSet {
    static let invalidGitBranchCharacters = CharacterSet(charactersIn: "~^:\\")
}

extension String {
    func removingCharacters(in characterSet: CharacterSet) -> String {
        let filtered = unicodeScalars.filter { !characterSet.contains($0) }
        return String(String.UnicodeScalarView(filtered))
    }
}

GitStrip.main()
