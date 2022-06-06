//
//  KeychainService.swift
//  KeychainService
//
//  Created by t.lolaev on 04.06.2022.
//

import Security

public struct KeychainRecord {
    let username: String
    let service: String
    let password: String
    
    public init(username: String, service: String, password: String) {
        self.username = username
        self.service = service
        self.password = password
    }
}

public struct KeychainRecordGetting {
    let username: String
    let service: String
    
    public init(username: String, service: String) {
        self.username = username
        self.service = service
    }
}

public enum KeychainServiceError: Error {
    case duplicate
    case passToData
    case notFound
    case unknown(OSStatus)
}

public class KeychainService {
    
    public init() {}
    
    public func get(recordGetting: KeychainRecordGetting) throws -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: recordGetting.service,
            kSecAttrAccount: recordGetting.username,
            kSecReturnData: kCFBooleanTrue as AnyObject,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var result: AnyObject?
        
        let status = SecItemCopyMatching(query, &result)
        
        guard status != errSecItemNotFound else {
            throw KeychainServiceError.notFound
        }
        
        guard status == errSecSuccess else {
            throw KeychainServiceError.unknown(status)
        }
        
        return result as? Data
    }
    
    public func save(record: KeychainRecord) throws {
        do {
            guard let passwordData = record.password.data(using: .utf8) else {
                throw KeychainServiceError.passToData
            }
            
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: record.service,
                kSecAttrAccount: record.username,
                kSecValueData: passwordData
            ] as CFDictionary
            
            let status = SecItemAdd(query, nil)
            
            guard status != errSecDuplicateItem else {
                throw KeychainServiceError.duplicate
            }
            
            guard status == errSecSuccess else {
                throw KeychainServiceError.unknown(status)
            }
        } catch {
            throw error
        }
    }
    
    public func update(record: KeychainRecord) throws {
        do {
            guard let passwordData = record.password.data(using: .utf8) else {
                throw KeychainServiceError.passToData
            }
            
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: record.service,
                
            ] as CFDictionary
            
            let attributes = [
                kSecAttrAccount: record.username,
                kSecValueData: passwordData
            ] as CFDictionary
            
            let status = SecItemUpdate(query, attributes)
            
            guard status == errSecSuccess else {
                throw KeychainServiceError.unknown(status)
            }
        } catch {
            throw error
        }
    }
    
}
