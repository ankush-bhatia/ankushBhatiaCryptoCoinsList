//
//  CryptoListDBDataSource.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/21/25.
//

import Foundation
import CoreData

protocol CryptoListDBDataSourceProtocol {
    
    func geCryptoCoins(completion: @escaping (Result<[CryptoItem], DBError>) -> Void)
    func saveCryptoCoins(cryptoCoins: [CryptoItem],
                         completion: @escaping (Result<Bool, DBError>) -> Void)
}

struct CryptoListDBDataSource: CryptoListDBDataSourceProtocol {
    
    func geCryptoCoins(completion: @escaping (Result<[CryptoItem], DBError>) -> Void) {
        let readerContext = CrpytoListCoreDataStack.shared.mainContext
        readerContext.perform {
            let fetchRequest = CryptoDBItem.fetchRequest()
            guard let result = try? readerContext.fetch(fetchRequest) else {
                completion(.failure(.unableToGetData))
                return
            }
            let cryptoCoins: [CryptoItem] = result.compactMap {
                guard let name = $0.name,
                      let symbol = $0.symbol,
                      let type = $0.type,
                      let cryptoType = CryptoType(rawValue: type) else {
                    return nil
                }
                return CryptoItem(name: name,
                                  symbol: symbol,
                                  isNew: $0.isNew, 
                                  isActive: $0.isActive,
                                  type: cryptoType)
            }
            completion(.success(cryptoCoins))
        }
    }
    
    func saveCryptoCoins(cryptoCoins: [CryptoItem], completion: @escaping (Result<Bool, DBError>) -> Void) {
        let writerContext = CrpytoListCoreDataStack.shared.writerContext
        writerContext.performAndWait {
            for coin in cryptoCoins {
                let fetchRequest = CryptoDBItem.fetchRequest()
                let result = try? writerContext.fetch(fetchRequest)
                if let matchedEntry = result?.first(where: { ($0.name ?? "").lowercased() == coin.name.lowercased() }) {
                    matchedEntry.name = coin.name
                    matchedEntry.symbol = coin.symbol
                    matchedEntry.isActive = coin.isActive
                    matchedEntry.isNew = coin.isNew
                    matchedEntry.type = coin.type.rawValue
                } else {
                    let newEntry = NSEntityDescription.insertNewObject(forEntityName: "CryptoDBItem", into: writerContext) as? CryptoDBItem
                    newEntry?.name = coin.name
                    newEntry?.symbol = coin.symbol
                    newEntry?.isActive = coin.isActive
                    newEntry?.isNew = coin.isNew
                    newEntry?.type = coin.type.rawValue
                }
            }
            do {
                if writerContext.hasChanges {
                    try writerContext.save()
                }
                try CrpytoListCoreDataStack.shared.saveMainContext()
            } catch {
                completion(.failure(.unableToSaveData))
            }
        }
    }
}
