//
//  FileManagerService.swift
//  FileManagerService
//
//  Created by t.lolaev on 02.06.2022.
//

import UIKit

public class FileManagerService {
    
    public static let shared = FileManagerService()
    
    private lazy var fileManager = FileManager.default
    
    private var documentsPath: URL? {
        do {
            return try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        } catch {
            return nil
        }
    }
    
    public var files = [URL]()
    
    // Please use .shared
    private init() {}
    
    public func getFiles(completion: () -> Void) {
        guard let documentsPath = documentsPath else { return }
        
        do {
            files = try fileManager.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            completion()
        } catch {
            return
        }
    }
    
    public func createFile(file: Data) {
        guard let documentsPath = documentsPath else { return }
        
        let imagePath = documentsPath.appendingPathComponent("image-\(Date().timeIntervalSince1970).jpg")
        
        fileManager.createFile(atPath: imagePath.path, contents: file)
    }
    
    public func getFile(by url: String) -> UIImage? {
        return UIImage(contentsOfFile: url)
    }
    
    public func removeFile(by fileUrl: URL, completion: () -> Void) {
        do {
            try fileManager.removeItem(atPath: fileUrl.path)
            files.removeAll { url in
                url == fileUrl
            }
            completion()
        } catch {
            return
        }
        
    }
    
}
