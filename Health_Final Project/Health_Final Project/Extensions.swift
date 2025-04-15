//
//  Extensions.swift
//  Health_Final Project
//
//  Created by Rehnuma Taskin on 15/04/2025.
//
import Foundation

extension URL {
    static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

