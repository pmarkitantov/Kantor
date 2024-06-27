//
//  ContentView.swift
//  Kantor
//
//  Created by Pavel Markitantov on 18/01/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var currencyData: CurrencyData?
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            ScrollView {
                if isLoading {
                    ProgressView()
                } else if let currencyData = currencyData {

                    ForEach(currencyData.data.keys.sorted(), id: \.self) { key in
                        Text("\(key): \(currencyData.data[key]!, specifier: "%.4f")")
                    }
                } else if let errorMessage = errorMessage {
                    Text("Ошибка: \(errorMessage)")
                        .foregroundColor(.red)
                }

                Button("Загрузить курсы валют") {
                    loadCurrencyRates()
                }
                .padding()
            }
            .navigationTitle("Курсы валют")
        }
    }

    private func loadCurrencyRates() {
        isLoading = true
        errorMessage = nil

        NetworkManager.shared.fetchCurrencyRates { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let data):
                    currencyData = data
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
