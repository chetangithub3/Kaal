//
//  HoroscopeView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 5/22/24.
//

import SwiftUI

struct HoroscopeMainPageView: View {
    @StateObject private var viewModel = ChatViewModel()
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                ScrollView{
                    Text(viewModel.chatCompletion)
                        .padding()
                }
               
            }
        }
        .padding()
    }
}

#Preview {
    HoroscopeMainPageView()
}


class HoroscopeViewModel: ObservableObject {
    
    func fetchCompletion() -> String {
        let messages = [
                    ["role": "user", "content": "Explain the importance of fast language models"]
                ]
        let model = "llama3-8b-8192"
        return ""
    }
    
}

struct GroqClient {
    
    func getChatCompletion(messages: [[String: String]], model: String, completion: @escaping (String?) -> Void) {
           
           let dummyResponse = "Fast language models are important because..."
           completion(dummyResponse)
       }
}

class ChatViewModel: ObservableObject {
    @Published var chatCompletion: String = "Loading..."
    @Published var isLoading: Bool = true
    @AppStorage("birthArea") var birthArea: String = ""
    @AppStorage("birthday") var birthday: String = ""
    private let apiKey = "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"
    private let endpoint = "https://api.groq.com/openai/v1/chat/completions"

    init() {
        fetchChatCompletion()
    }

    func fetchChatCompletion() {
        guard let url = URL(string: endpoint) else {
            DispatchQueue.main.async {
                self.chatCompletion = "Invalid URL"
                self.isLoading = false
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = [
            "messages": [
                ["role": "user", "content": "give the horoscope for \(Date().description) for a person whose birthday is \(birthday) and birthplace is \(birthArea)"]
            ],
            "model": "llama3-8b-8192"
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            DispatchQueue.main.async {
                self.chatCompletion = "Error creating request body: \(error.localizedDescription)"
                self.isLoading = false
            }
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.chatCompletion = "Error: \(error.localizedDescription)"
                } else if let data = data,
                          let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                          let choices = jsonResponse["choices"] as? [[String: Any]],
                          let firstChoice = choices.first,
                          let message = firstChoice["message"] as? [String: Any],
                          let content = message["content"] as? String {
                    self.chatCompletion = content
                } else {
                    self.chatCompletion = "Unexpected response"
                }
                self.isLoading = false
            }
        }

        task.resume()
    }
}

struct SunSignClassifier {
    static func getSunSign(for date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: date)
        
        guard let month = components.month, let day = components.day else {
            return "Unknown"
        }
        
        switch (month, day) {
        case (3, 21...31), (4, 1...19):
            return "Aries"
        case (4, 20...30), (5, 1...20):
            return "Taurus"
        case (5, 21...31), (6, 1...20):
            return "Gemini"
        case (6, 21...30), (7, 1...22):
            return "Cancer"
        case (7, 23...31), (8, 1...22):
            return "Leo"
        case (8, 23...31), (9, 1...22):
            return "Virgo"
        case (9, 23...30), (10, 1...22):
            return "Libra"
        case (10, 23...31), (11, 1...21):
            return "Scorpio"
        case (11, 22...30), (12, 1...21):
            return "Sagittarius"
        case (12, 22...31), (1, 1...19):
            return "Capricorn"
        case (1, 20...31), (2, 1...18):
            return "Aquarius"
        case (2, 19...29), (3, 1...20):
            return "Pisces"
        default:
            return "Unknown"
        }
    }
}
