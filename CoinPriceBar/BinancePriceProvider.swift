//
//  BinancePriceProvider.swift
//  CoinPriceBar
//
//  Created by Thanh Pham on 23/12/17.
//  Copyright © 2017 Thanh Pham. All rights reserved.
//

struct BinancePriceProvider: CoinPriceProvider {
    
    func getPrice(of coin: Coin, in currency: FiatMoney, completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://cuitor.cn/proxy/?url=https://api.binance.com/api/v3/ticker/price?symbol=\(coin)\(currency)")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                let json = jsonObject as? [String: Any],
                let price = json["price"] as? String else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
            }
            DispatchQueue.main.async {
                completion(String(format:"%.02f", Float(price)!))
            }
            }.resume()
    }
}
