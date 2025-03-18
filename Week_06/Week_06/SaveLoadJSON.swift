
import Foundation

// Utility for saving and loading any Codable object to/from JSON
struct SaveLoadJSON {
    
    // Get the documents directory URL
    private static func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // Save a Codable object to a JSON file
    static func save<T: Encodable>(_ object: T, to filename: String) throws {
        let url = getDocumentsDirectory().appendingPathComponent(filename + ".json")
        
        // Create a JSON encoder with pretty printing
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        
        // Encode the object to JSON data
        let data = try encoder.encode(object)
        
        // Write the data to the file
        try data.write(to: url, options: [.atomicWrite, .completeFileProtection])
    }
    
    // Load a Codable object from a JSON file
    static func load<T: Decodable>(_ type: T.Type, from filename: String) throws -> T {
        let url = getDocumentsDirectory().appendingPathComponent(filename + ".json")
        
        // Read the data from the file
        let data = try Data(contentsOf: url)
        
        // Create a JSON decoder
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        // Decode the data into the specified type
        return try decoder.decode(type, from: data)
    }
}
