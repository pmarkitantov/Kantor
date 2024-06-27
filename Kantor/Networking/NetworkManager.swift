import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    func fetchCurrencyRates(completion: @escaping (Result<CurrencyData, Error>) -> Void) {
        let urlString = "https://api.freecurrencyapi.com/v1/latest?apikey=fca_live_cftQSrgBvmBrvqnXfO77CVsF0WtT7LkfqSWAJtL2"

        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let currencyData = try JSONDecoder().decode(CurrencyData.self, from: data)
                completion(.success(currencyData))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
}


