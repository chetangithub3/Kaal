    //
    //  SettingsMenuView.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 12/12/23.
    //

import SwiftUI
import MessageUI
import StoreKit

struct SettingsMenuView: View {
    @AppStorage("genderSaved") var genderSaved: Gender?
    @AppStorage("name") var name = ""
    @AppStorage("birthday") var birthday: String = ""
    @AppStorage("birthtime") var birthtime: String = ""
    @AppStorage("birthplace") var birthplace: String = ""
    var firstName: String {
        return name.components(separatedBy: " ").first ?? name
    }
    @AppStorage("currentArea") var currentArea: String = ""
    @EnvironmentObject var viewModel: DashboardViewModel
    @State var shouldAnimate = false
    var link = "https://apps.apple.com/us/app/muhurta-daily/id6477121908"
    let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown Version"
    @AppStorage("horoscopeObDone") var horoscopeObDone: Bool = false
    var body: some View {
        NavigationView(content: {
            List {
                Section("Astrology") {
                    ClockThemeSelectorView()
                    NavigationLink {
                        ChangeAddressView()
                    } label: {
                        HStack {
                            Text("Current Address")
                            Spacer()
                            Text("\(currentArea)")
                                .underline()
                        }
                    }
                }.scaleEffect(shouldAnimate ? 1.2 : 1.0)
                    .animation(.bouncy, value: 1)
                
                if horoscopeObDone {
                    Section("Horoscope") {
                        NavigationLink {
                            ChangeNameView()
                        } label: {
                            HStack{
                                Text("Name")
                                Spacer()
                                Text("\(firstName)")
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.7)
                            }
                        }
                        NavigationLink {
                            ChangeBirthdayView()
                        } label: {
                            HStack{
                                Text("Birthday")
                                Spacer()
                                Text("\(birthday)")
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.7)
                            }
                        }
                        NavigationLink {
                            ChangeBirthplaceView()
                        } label: {
                            HStack{
                                Text("Birthplace")
                                Spacer()
                                Text("\(birthplace)")
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.7)
                            }
                        }
                        NavigationLink {
                            ChangeBirthtimeView()
                        } label: {
                            HStack{
                                Text("Birthtime")
                                Spacer()
                                Text("\(birthtime)")
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.7)
                            }
                        }
                    }
                }

                Section("Misc") {
                    NavigationLink(destination: WebView(url:URL(string: "https://www.termsfeed.com/live/53b19986-13af-451c-a59e-726efa238cd7")! )) {
                        Text("Privacy policy")
                    }
                    
                    HStack{
                        Text("App version")
                        Spacer()
                        Text(appVersion)
                    }
                    
                 
                    Button(action: {
                        sendFeedback()
                    }) {
                        HStack {
                            Text("Share feedback")
                            Spacer()
                            Image(systemName: "at.badge.plus")
                        }.foregroundColor(.primary)
                    }
                    
                    Button(action: {
                        requestAppRating()
                    }) {
                        HStack {
                            Text("Rate the app")
                            Spacer()
                            Image(systemName: "star")
                        }.foregroundColor(.primary)
                    }
                    Button {
                        shareLink()
                    } label: {
                        HStack {
                            Text("Share the app")
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                        }.foregroundColor(.primary)
                    }
                }
                
                BannerAd320x50View()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: currentArea, { oldValue, newValue in
                if oldValue != newValue {
                    viewModel.daylightFromLocation(on: Date())
                }
            })
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ChangeTab"))) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                    withAnimation {
                        shouldAnimate = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7){
                        withAnimation {
                            shouldAnimate = false
                        }
                        
                    }
                }
            }
        })
    }
    
    func shareLink() {
        let activityViewController = UIActivityViewController(activityItems: [URL(string: link)!, "To know the accurate Muhurta timings based on your precise location on your device, please download Muhurta Daily from the following link:\n"], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    
    func sendFeedback() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.setToRecipients(["chetan.getsmail@gmail.com"]) // Replace with your feedback email
            mailComposer.setSubject("Feedback for Your App")
            mailComposer.setMessageBody("Version: \(appVersion)\n\nFeedback:\n", isHTML: false)

            UIApplication.shared.windows.first?.rootViewController?.present(mailComposer, animated: true, completion: nil)
        } else {
            // Handle the case where the device can't send emails
            print("Device cannot send emails.")
        }
    }
    
    func requestAppRating() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}


#Preview {
    SettingsMenuView()
}
