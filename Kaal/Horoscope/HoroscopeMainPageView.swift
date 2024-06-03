//
//  HoroscopeView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 5/22/24.
//

import SwiftUI

struct HoroscopeMainPageView: View {
    @StateObject private var viewModel = HoroscopeViewModel()
    var body: some View {
        VStack {
            if let prediction = viewModel.prediction{
                PredictionView(prediction: prediction)
            } else {
                Text(viewModel.horoscope ?? "")
            }
        }
        .padding()
        .task {
            await viewModel.fetchHoroscope()
        }
    }
}

#Preview {
    HoroscopeMainPageView()
}

@MainActor
class HoroscopeViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @AppStorage("birthplace") var birthplace: String = ""
    @AppStorage("birthday") var birthday: String = ""
    @Published var prediction: Prediction?
    @Published var horoscope: String?
    private let apiKey = "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"
    private let endpoint = "https://api.groq.com/openai/v1/chat/completions"
    
    
    func fetchHoroscope() async {
        guard let request = createRequest() else {
            self.horoscope = "Error Occured"
            return
        }
        do {
            let (data,_) = try await URLSession.shared.data(for: request)
            switch decodeDataToPrediction(data) {
                case .success(let prediction):
                    self.prediction = prediction
                case .failure(_):
                    decodeDataIntoText(data)
            }
        }
        catch(let error) {
            print(error.localizedDescription)
            return
        }
        
    }
    func decodeDataIntoText(_ data: Data) {
        if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let choices = jsonResponse["choices"] as? [[String: Any]],
           let firstChoice = choices.first,
           let message = firstChoice["message"] as? [String: Any],
           let content = message["content"] as? String {
            let horoscope = parseHoroscopeContent(content)
                  
                  // Print out the sections
            let text = """
                        General: \(horoscope.general)
                
                        Personal: \(horoscope.personal)
                
                        Finance: \(horoscope.finance)
                
                        Health: \(horoscope.health)
                
                        Lucky Numbers: \(horoscope.luckyNumbers.map({ num in
                num.description
                
                }).joined(separator: ", "))
                
                        Lucky Colors: \(horoscope.luckyColors.joined(separator: ", "))
                
                """
            self.horoscope = text
            
        } else {
            self.horoscope = "Error Occured"
        }
    }
    func parseHoroscopeContent(_ content: String) -> (general: String, personal: String, finance: String, health: String, luckyNumbers: [Int], luckyColors: [String]) {
        var general = "N/A"
        var personal = "N/A"
        var finance = "N/A"
        var health = "N/A"
        var luckyNumbers: [Int] = []
        var luckyColors: [String] = []
        
        if let data = content.data(using: .utf8),
           let horoscopeJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            
            // Extract individual sections
            general = horoscopeJSON["General"] as? String ?? "N/A"
            personal = horoscopeJSON["Personal"] as? String ?? "N/A"
            finance = horoscopeJSON["Finance"] as? String ?? "N/A"
            health = horoscopeJSON["Health"] as? String ?? "N/A"
            luckyNumbers = horoscopeJSON["Lucky Numbers"] as? [Int] ?? []
            luckyColors = horoscopeJSON["Lucky Colors"] as? [String] ?? []
        }
        
        return (general, personal, finance, health, luckyNumbers, luckyColors)
    }
    
    func decodeDataToPrediction(_ data: Data) -> Result<Prediction, APIError> {
        if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let choices = jsonResponse["choices"] as? [[String: Any]],
           let firstChoice = choices.first,
           let message = firstChoice["message"] as? [String: Any],
           let contentString = message["content"] as? String,
           let contentData = contentString.data(using: .utf8),
           let content = try? JSONSerialization.jsonObject(with: contentData, options: []) as? [String: Any] {

            if let general = content["General"] as? String,
               let personal = content["Personal"] as? String,
               let finance = content["Finance"] as? String,
               let health = content["Health"] as? String,
               let social = content["Social"] as? String,
               let luckyNumbers = content["Lucky Numbers"] as? [Int],
               let luckyColors = content["Lucky Colors"] as? [String] {

                let prediction = Prediction(general: general,
                                            personal: personal,
                                            finance: finance,
                                            health: health,
                                            social: social,
                                            luckyNumbers: luckyNumbers,
                                            luckyColors: luckyColors)
                return .success(prediction)
            }
            return .failure(APIError.badServer)
        } else {
            return .failure(APIError.badServer)
        }
    }
    
    func createRequest() -> URLRequest? {
        guard let url = URL(string: endpoint) else {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "messages": [
                ["role": "system", "content": """
                You will be given a birthday, birthtime, and location of birth. Your job is to give a horoscope for a given day.
                The response should contain horoscope elements such as General, personal, finance, health, social and list of lucky numbers and a list of lucky colors. It needs to be in the following JSON structure.

                {
                  "General": "This is a great day to take a break from your daily routine and indulge in some self-care. Take a relaxing bath, read a book, or practice some yoga to recharge your batteries.",
                  "Personal": "You may feel a sense of restlessness today, but try to channel it into something productive. Use this energy to tackle that pending task or project you've been putting off.",
                  "Finance": "Be cautious with your finances today. Avoid making impulsive decisions, and take your time to think before making any big purchases.",
                  "Health": "Take care of your physical and mental well-being today. Engage in some form of exercise, and prioritize your health.",
                  "Relationship": "Communicate openly and honestly with your loved ones today. Avoid misunderstandings by being clear and concise in your conversations.",
                  "Lucky Numbers": [3, 9, 12, 15, 21],
                  "Lucky Colors": ["Yellow", "Orange", "Pink"]
                }
                """],
                ["role": "user", "content": "give the horoscope for \(Date().description) for a person whose birthday is \(birthday) and birthplace is \(birthplace)"]
            ],
            "model": "llama3-8b-8192",
            "response_format": ["type": "json_object"]
        ]
  
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            return nil
        }
        return request
    }
}

extension Data {
    func printJSON(debugTitle: String) {
        if let JSONString = String(data: self, encoding: String.Encoding.utf8) {
            dump(JSONString, name: "JSONString")
        }
    }
}

struct Prediction {
    let general: String
    let personal: String
    let finance: String
    let health: String
    let social: String
    let luckyNumbers: [Int]?
    let luckyColors: [String]?
}

struct PredictionView: View {
    let prediction: Prediction

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("General").font(.headline)
                Text(prediction.general).padding(.bottom, 10)
                
                Text("Personal").font(.headline)
                Text(prediction.personal).padding(.bottom, 10)
                
                Text("Finance").font(.headline)
                Text(prediction.finance).padding(.bottom, 10)
                
                Text("Health").font(.headline)
                Text(prediction.health).padding(.bottom, 10)
                
                Text("Social").font(.headline)
                Text(prediction.social).padding(.bottom, 10)
                
                Text("Lucky Numbers").font(.headline)
               
                if let nums = prediction.luckyNumbers {
                    let filtered = nums.map({$0.description}).joined(separator: ", ")
                    Text(filtered)
                }
                Text("Lucky Colors").font(.headline)
                if let nums = prediction.luckyColors  {
                    let filtered = nums.map({$0.description}).joined(separator: ", ")
                    Text(filtered)
                }
               
            }
            .padding()
        }
        .navigationTitle("Prediction")
    }
}
