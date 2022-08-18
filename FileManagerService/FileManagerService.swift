//
//  FileManagerService.swift
//  FileManagerService — сервис, который я обязательно буду переиспользовать
//
//  Created with love by t.lolaev for Timur Saidov on 02.06.2022.
//

import UIKit

public class FileManagerService {
    
    private lazy var fileManager = FileManager.default
    
    private var documentsPath: URL? {
        do {
            return try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        } catch {
            return nil
        }
    }
    
    public init() {}
    
    public func getFiles() -> [URL] {
        guard let documentsPath = documentsPath else { return [] }
        
        do {
            return try fileManager.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
        } catch {
            return []
        }
    }
    
    public func createFile(file: Data) {
        guard let documentsPath = documentsPath else { return }
        
        let imagePath = documentsPath.appendingPathComponent("image-\(Date().timeIntervalSince1970).jpg")
        
        fileManager.createFile(atPath: imagePath.path, contents: file)
        
    }
    
    public func getImage(by url: String) -> UIImage? {
        return UIImage(contentsOfFile: url)
    }
    
    public func removeFile(by fileUrl: URL, callback: @escaping () -> Void) {
        do {
            try fileManager.removeItem(atPath: fileUrl.path)
            callback()
        } catch {
            return
        }
        
    }
    
}
