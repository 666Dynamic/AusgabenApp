//
//  ExchangeRateService.swift
//  AusgabenApp
//
//  Created by Lukas on 13.10.26.
//

import Foundation

struct ExchangeRatesResponse: Decodable {
    let base: String
    let date: String
    let rates: [String: Double]
}

struct ExchangeRateService {
    func fetchRates(base: String, symbols: [String]) async throws -> ExchangeRatesResponse {
        var components = URLComponents(string: "https://api.frankfurter.dev/v1/latest")!
        components.queryItems = [
            URLQueryItem(name: "base", value: base),
            URLQueryItem(name: "symbols", value: symbols.joined(separator: ","))
        ]
        let (data, response) = try await URLSession.shared.data(from: components.url!)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(ExchangeRatesResponse.self, from: data)
    }
}
