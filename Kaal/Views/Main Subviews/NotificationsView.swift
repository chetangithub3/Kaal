    //
    //  NotificationsView.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 12/12/23.
    //

import SwiftUI
import UserNotifications

struct NotificationsView: View {
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
    NotificationsView()
}
