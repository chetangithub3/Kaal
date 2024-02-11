    //
    //  NotificationsView.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 12/12/23.
    //

import SwiftUI
import UserNotifications

struct NotificationsTabView: View {
    @AppStorage("currentArea") var currentArea: String = ""
    @State var areNotificationsEnabled = true
    
    var body: some View {
        VStack {
            if !areNotificationsEnabled{
                NotificationsDeniedView()
            }
            else {
                VStack {
                    Spacer()
                    Image(systemName: "alarm.waves.left.and.right")
                        .resizable()
                        .scaledToFit()
                        .symbolEffect(.variableColor.iterative)
                        .frame(width: 100, height: 100)
                        .symbolVariant(.slash)
                    
                    
                    HStack{
                        Spacer()
                        Image(systemName: "quote.opening")
                        Text("Schedule notifications to keep track of the muhurtas")
                            .font(.italic(.subheadline)())
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                        Image(systemName: "quote.closing")
                        Spacer()
                    }
                    Text("Coming Soon")
                        .font(.italic(.caption)())
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    
                    Spacer()
                }.edgesIgnoringSafeArea(.all)
                    .background(getBackgroundColor())
                   
            }
            
        }
        .onAppear(perform: {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                self.areNotificationsEnabled = granted
            }
            
        })
        
        .edgesIgnoringSafeArea(.all)
        .background(getBackgroundColor())
        
    }
    
    func scheduleNotification() {
            let content = UNMutableNotificationContent()
            content.title = ""
            content.body = "Kaal starts in 10 mins for \(currentArea)"
            
            var dateComponents = DateComponents()
            dateComponents.hour = 13  // 1 PM
            dateComponents.minute = 30
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: "yourNotificationIdentifier", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                } else {
                    print("Notification scheduled successfully!")
                }
            }
        }
}
struct NotificationsDeniedView: View {
    
    var body: some View {
        
        Button(action: {
            openAppSettings()
        }) {
            Text("Open Notification Settings")
                .padding()
        }
    }
    
    private func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
    
}
#Preview {
    NotificationsTabView()
}
