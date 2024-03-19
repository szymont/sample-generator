//
//  Property.swift
//  Generator
//
//  Created by Artyom Mukha on 4/11/20.
//  Copyright © 2020 SFTNHRD. All rights reserved.
//

import Foundation

final class Object {

    struct Property {
        let name: String
        let type: String
        let castedType: PropertyType?

        enum PropertyType {
            case uuid
            case string
            case date
            case timeInterval
            case bool
            case int
            case decimal
            case double
            case float
            case url
            case array
            case dictionary
            case set
            case unknownOptional
            case unknownNonOptional
        }
    }

    let name: String
    private(set) weak var parent: Object?
    var properties = [Property]()
    var children = [Object]()

    init(name: String, parent: Object?) {
        self.name = name
        self.parent = parent
    }
}

extension Object.Property {

    private enum Constants {
        static let closureRegex = try? NSRegularExpression(pattern: "->", options: [])
    }

    var isClosure: Bool {
        Constants.closureRegex?.firstMatch(
            in: type,
            options: [],
            range: NSRange(location: 0, length: (type as NSString).length)
        ) != nil
    }
}

extension Object.Property.PropertyType {
    init(string: String) {
        let matched = Self.patterns.first {
            string.contains($0.value)
        }
        if let matched {
            self = matched.key
        } else if string.contains(Self.optionalPattern) {
            self = .unknownOptional
        } else {
            self = .unknownNonOptional
        }
    }

    private static let patterns: [Self: Regex] = [
        .array: /\[\w+\??\]\??$/,
        .dictionary: /\[\w+ ?: ?\w+\??\]\??$/,
        .set: /Set\<\w+\??\>\??$/,
        .uuid: /UUID\??$/,
        .string: /String\??$/,
        .date: /Date\??$/,
        .timeInterval: /TimeInterval\??$/,
        .bool: /Bool\??$/,
        .int: /[Int|Int8|Int16|Int32|Int64|UInt]\??$/,
        .decimal: /Decimal\??$/,
        .double: /Double\??$/,
        .float: /Float\??$/,
        .url: /URL\??$/,
    ]
    private static let optionalPattern: Regex = /.*\?$/
}
