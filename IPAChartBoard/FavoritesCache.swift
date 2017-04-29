//
//  FavoritesCache.swift
//  DevelopKeyboard
//
//  Created by Frederick Kuhl on 3/20/17.
//  Copyright © 2017 TyndaleSoft LLC. All rights reserved.
//

import Foundation

//The key is a String formed by concatenating a KeyView's kind and scalars.
//Must be a "property list type". See makeKeyViewKey()
typealias Favorites = [String : Int]

class FavoritesCache {
    private static let favoritesKey = "favorites"
    static let keySeparator = "^"
    
    //thread-safe singleton in the age of Swift 3:
    //http://krakendev.io/blog/the-right-way-to-write-a-singleton
    var cache: Favorites
    var stamp = Date().description
    static var sharedInstance = FavoritesCache()
    private init() {
        cache = Favorites()
    }
    
    var count: Int {
        get {
            return cache.count
        }
    }
    
    subscript(kind: KeyViewKind, scalars: String) -> Int? {
        get {
            return cache[makeKeyViewKey(kind: kind, scalars: scalars)]
        }
        
        set(newValue) {
            cache[makeKeyViewKey(kind: kind, scalars: scalars)] = newValue
        }
    }
    
    subscript(key: String) -> Int? {
        return cache[key]
    }
    
    func readFromDefaults() {
        let defaults = UserDefaults.standard
        self.cache  = defaults.object(forKey:FavoritesCache.favoritesKey)
                as? [String : Int] ?? [String : Int]()
    }
    
    func writeToDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(self.cache, forKey:FavoritesCache.favoritesKey)
    }
    
    func printEntries() {
        print("entries:")
        for (key, count) in cache {
            print("  \(key)\t\(count)")
        }
    }
    
    func getSorted() -> [(key: String, value: Int)] {
        return cache.sorted(by: { $0.value > $1.value })
    }
    
}

private func makeKeyViewKey(kind: KeyViewKind, scalars: String) -> String {
    return kind.rawValue + FavoritesCache.keySeparator + scalars
}

func parseKeyViewKey(_ key:String) -> (kind: KeyViewKind, scalars: String) {
    let components = key.components(separatedBy: FavoritesCache.keySeparator)
    if components.count < 2 {
        print("FavoritesCache parseKeyViewKey invalid key: \(key)")
        abort()
    }
    guard let kind = KeyViewKind(rawValue: components[0]) else {
        print("invalid key kind \(components[0])")
        abort()
    }
    return (kind: kind, scalars: components[1])
}
