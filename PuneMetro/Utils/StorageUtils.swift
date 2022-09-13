//
//  StorageUtils.swift
//  PuneMetro
//
//  Created by Admin on 20/04/21.
//

import Foundation
import CommonCrypto

class StorageUtils {
    enum AESError: Error {
        case KeyError((String, Int))
        case IVError((String, Int))
        case CryptorError((String, Int))
    }
    public static func encryptString(string: String, keyData: Data) throws -> Data {
        let data: Data = string.data(using: String.Encoding.utf8) ?? Data()
        let keyLength = keyData.count
        let validKeyLengths = [kCCKeySizeAES128, kCCKeySizeAES192, kCCKeySizeAES256]
        if validKeyLengths.contains(keyLength) == false {
            throw AESError.KeyError(("Invalid key length", keyLength))
        }

        let ivSize = kCCBlockSizeAES128
        let cryptLength = size_t(ivSize + data.count + kCCBlockSizeAES128)
        var cryptData = Data(count: cryptLength)
        
        try cryptData.withUnsafeMutableBytes { dataBytes in
            
            guard let dataBytesBaseAddress = dataBytes.baseAddress else {
                throw AESError.IVError(("IV generation failed", 0))
            }
            
            let status: Int32 = SecRandomCopyBytes(
                kSecRandomDefault,
                kCCBlockSizeAES128,
                dataBytesBaseAddress
            )
            
            guard status == 0 else {
                throw AESError.IVError(("IV generation failed", Int(status)))
            }
        }
        
//        let status = cryptData.withUnsafeMutableBytes {ivBytes in
//            SecRandomCopyBytes(kSecRandomDefault, kCCBlockSizeAES128, ivBytes)
//        }
//        if status != 0 {
//            throw AESError.IVError(("IV generation failed", Int(status)))
//        }

        var numberBytesEncrypted: size_t = 0
        let options   = CCOptions(kCCOptionPKCS7Padding)
//
//
//
//        let cryptStatus = cryptData.withUnsafeMutableBytes {cryptBytes in
//            data.withUnsafeBytes {dataBytes in
//                keyData.withUnsafeBytes {keyBytes in
//                    CCCrypt(CCOperation(kCCEncrypt),
//                            CCAlgorithm(kCCAlgorithmAES),
//                            options,
//                            keyBytes, keyLength,
//                            cryptBytes,
//                            dataBytes, data.count,
//                            cryptBytes+kCCBlockSizeAES128, cryptLength,
//                            &numBytesEncrypted)
//                }
//            }
//        }
//
//        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
//            cryptData.count = numBytesEncrypted + ivSize
//        } else {
//            throw AESError.CryptorError(("Encryption failed", Int(cryptStatus)))
//        }
        
        do {
            try keyData.withUnsafeBytes { keyBytes in
                try data.withUnsafeBytes { dataToEncryptBytes in
                    try cryptData.withUnsafeMutableBytes { bufferBytes in
                        
                        guard let keyBytesBaseAddress = keyBytes.baseAddress,
                              let dataToEncryptBytesBaseAddress = dataToEncryptBytes.baseAddress,
                              let bufferBytesBaseAddress = bufferBytes.baseAddress else {
                            throw AESError.CryptorError(("Encryption failed", 0))
                        }
                        
                        let cryptStatus: CCCryptorStatus = CCCrypt( // Stateless, one-shot encrypt operation
                            CCOperation(kCCEncrypt),                // op: CCOperation
                            CCAlgorithm(kCCAlgorithmAES),           // alg: CCAlgorithm
                            options,                                // options: CCOptions
                            keyBytesBaseAddress,                    // key: the "password"
                            keyData.count,                              // keyLength: the "password" size
                            bufferBytesBaseAddress,                 // iv: Initialization Vector
                            dataToEncryptBytesBaseAddress,          // dataIn: Data to encrypt bytes
                            dataToEncryptBytes.count,               // dataInLength: Data to encrypt size
                            bufferBytesBaseAddress + ivSize,        // dataOut: encrypted Data buffer
                            cryptLength,                             // dataOutAvailable: encrypted Data buffer size
                            &numberBytesEncrypted                   // dataOutMoved: the number of bytes written
                        )
                        
                        guard cryptStatus == CCCryptorStatus(kCCSuccess) else {
                            throw AESError.CryptorError(("Encryption failed", Int(cryptStatus)))
                        }
                    }
                }
            }
        } catch let e {
            MLog.log(string: "Encryption Error:", e.localizedDescription)
            throw AESError.CryptorError(("Encryption failed", 1))
        }
        
        let encryptedData: Data = cryptData[..<(numberBytesEncrypted + ivSize)]
        return encryptedData

//        return cryptData
    }

    // The iv is prefixed to the encrypted data
    public static func decryptData(data: Data?, keyData: Data) throws -> String? {
        if data == nil {
            return nil
        }
        let keyLength = keyData.count
        let validKeyLengths = [kCCKeySizeAES128, kCCKeySizeAES192, kCCKeySizeAES256]
        if validKeyLengths.contains(keyLength) == false {
            throw AESError.KeyError(("Invalid key length", keyLength))
        }

        let ivSize = kCCBlockSizeAES128
        let clearLength = size_t(data!.count - ivSize)
        var clearData = Data(count: clearLength)

        var numBytesDecrypted: size_t = 0
        let options   = CCOptions(kCCOptionPKCS7Padding)

//        let cryptStatus = clearData.withUnsafeMutableBytes {cryptBytes in
//            data!.withUnsafeBytes {dataBytes in
//                keyData.withUnsafeBytes {keyBytes in
//                    CCCrypt(CCOperation(kCCDecrypt),
//                            CCAlgorithm(kCCAlgorithmAES128),
//                            options,
//                            keyBytes, keyLength,
//                            dataBytes,
//                            dataBytes+kCCBlockSizeAES128, clearLength,
//                            cryptBytes, clearLength,
//                            &numBytesDecrypted)
//                }
//            }
//        }
//
//        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
//            clearData.count = numBytesDecrypted
//        } else {
//            throw AESError.CryptorError(("Decryption failed", Int(cryptStatus)))
//        }
        
        do {
            try keyData.withUnsafeBytes { keyBytes in
                try data!.withUnsafeBytes { dataToDecryptBytes in
                    try clearData.withUnsafeMutableBytes { bufferBytes in
                        
                        guard let keyBytesBaseAddress = keyBytes.baseAddress,
                              let dataToDecryptBytesBaseAddress = dataToDecryptBytes.baseAddress,
                              let bufferBytesBaseAddress = bufferBytes.baseAddress else {
                            throw AESError.CryptorError(("Decryption failed", 0))
                        }
                        
                        let cryptStatus: CCCryptorStatus = CCCrypt( // Stateless, one-shot encrypt operation
                            CCOperation(kCCDecrypt),                // op: CCOperation
                            CCAlgorithm(kCCAlgorithmAES128),        // alg: CCAlgorithm
                            options,                                // options: CCOptions
                            keyBytesBaseAddress,                    // key: the "password"
                            keyData.count,                              // keyLength: the "password" size
                            dataToDecryptBytesBaseAddress,          // iv: Initialization Vector
                            dataToDecryptBytesBaseAddress + ivSize, // dataIn: Data to decrypt bytes
                            clearLength,                             // dataInLength: Data to decrypt size
                            bufferBytesBaseAddress,                 // dataOut: decrypted Data buffer
                            clearLength,                             // dataOutAvailable: decrypted Data buffer size
                            &numBytesDecrypted                   // dataOutMoved: the number of bytes written
                        )
                        
                        guard cryptStatus == CCCryptorStatus(kCCSuccess) else {
                            throw AESError.CryptorError(("Decryption failed", Int(cryptStatus)))
                        }
                    }
                }
            }
        } catch let e {
            MLog.log(string: "Encryption Error:", e.localizedDescription)
            throw AESError.CryptorError(("Decryption failed", 1))
        }
        
        let decryptedData: Data = clearData[..<numBytesDecrypted]
        
        guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
            throw AESError.CryptorError(("Decryption failed", 5))
        }
        
        return decryptedString

//        return String.init(data: clearData, encoding: String.Encoding.utf8)
    }
}
