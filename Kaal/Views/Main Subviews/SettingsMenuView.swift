    //
    //  SettingsMenuView.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 12/12/23.
    //

import SwiftUI



struct SettingsMenuView: View {
    @AppStorage("currentArea") var currentArea: String = ""
    @AppStorage("timeFormat") var storedTimeFormat: String = "hh:mm a"
    @EnvironmentObject var viewModel: DashboardViewModel
    @State var selectedTimeFormat = ""
    @State var shouldAnimate = false
    var link = "https://www.youtube.com/"
    
    var body: some View {
        NavigationView(content: {
            Form {
                Section("Clock") {
                    HStack{
                        Text("Time format")
                        
                        Spacer()
                        
                        Picker("", selection: $selectedTimeFormat) {
                            Text("12 Hour").tag("hh:mm a")
                            Text("24 Hour").tag("HH:mm")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 200)
                    }
                }
                
                Section("Change Address") {
                    NavigationLink {
                        ChangeAddressView(ddViewModel: AddressSearchViewModel(apiManager: APIManager()))
                    } label: {
                        HStack {
                            Text("Current Address")
                            
                            Spacer()
                            
                            Text("\(currentArea)")
                        }
                    }
                }.scaleEffect(shouldAnimate ? 1.2 : 1.0) // Scaled effect for animation
                    .animation(.bouncy, value: 0.5)
                    
                    
                
                Section("Share") {
                    Button {
                        shareLink()
                    } label: {
                        HStack {
                            Text("Share the app")
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
                
            }
            .navigationTitle("Settings")
            .onAppear(perform: {
                selectedTimeFormat = storedTimeFormat
            })
            .onChange(of: selectedTimeFormat) { oldValue, newValue in
                self.storedTimeFormat = newValue
            }
            .onChange(of: currentArea, { oldValue, newValue in
                if oldValue != newValue {
                    viewModel.daylightFromLocation(on: Date())
                }
            })
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ChangeTab"))) { _ in
               shouldAnimate = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    shouldAnimate = false
                }
            }
        })
    }
    
    func shareLink() {
        let activityViewController = UIActivityViewController(activityItems: [URL(string: link)!], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
}


#Preview {
    SettingsMenuView(storedTimeFormat: "hh:mm a")
}
