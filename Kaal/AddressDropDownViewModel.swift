//
//  AddressDropDownViewModel.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/20/23.
//
// https://geocode.maps.co/search?q={String}
import Foundation
import Combine

class AddressDropDownViewModel: ObservableObject {
    var cancellebles = Set<AnyCancellable>()
    var apiManager: APIManager
    
    @Published var searchTex = ""
    @Published var showDropDown = false
    @Published var results = [AddressesListResponseElement]()
    @Published var searchResults: [String] = []
    
    init(apiManager: APIManager){
        self.apiManager = apiManager
        searchFieldListener()
    }
    func searchFieldListener(){
        
        $searchTex
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .sink { text in
                print(text)
                if text.count > 2 {
                    self.callAPI(text: text)
                }
            }.store(in: &cancellebles)
    }
    func callAPI(text: String){
        let baseURL = "https://geocode.maps.co/search?q="
        let url = baseURL + "\(text)"
        guard let URL = URL(string: url) else {return}
        fetchData(from: URL)
    }
    
    func fetchData(from url: URL) {
        apiManager.publisher(for: url)
            .sink (receiveCompletion: { (completion) in
                switch completion {
                    case .finished:
                        return
                    case .failure(let error):
                        print(error.localizedDescription)
                        
                        
                }
            }, receiveValue: { (addresses: AddressesListResponse) in
                
                let addressLines = addresses
                
                let jhfj = addressLines.map({$0.displayName ?? ""})
               
                
                for address in jhfj {
                    
                    print("=--------\(address)")
                    
                }
                
                self.searchResults = jhfj
                if jhfj.count > 0 {
                    self.showDropDown = true
                }
            })
            .store(in: &cancellebles)
    }
}
