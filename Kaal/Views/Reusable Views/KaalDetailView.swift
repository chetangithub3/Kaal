    //
    //  KaalDetailView.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 1/1/24.
    //

import SwiftUI

struct KaalDetailView: View {
    @AppStorage("currentArea") var currentArea: String = ""
    var kaalRange: ClosedRange<Date>
    @AppStorage("timeFormat") private var storedTimeFormat = "hh:mm a"
    @State var date = Date()
    @EnvironmentObject var viewModel: DashboardViewModel
    @State var startTime = ""
    @State var endTime = ""
    @State var shotting = false
    @State var sharedImage: UIImage?
    @State private var isShareSheetPresented = false
    var body: some View {
        
        VStack{
            Button {
                // change layout : todo
                isShareSheetPresented = true
            } label: {
                Text("Share")
            }
//            ScreenshotablView(shotting: $shotting) { img in
//                sharedImage = img
//            } content: { style in
//                screenshottableView(isAnimated: true)
//            }

            GeometryReader { proxy in
                screenshottableView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1){
                            let frame = proxy.frame(in: .global)
                            let screenshot = screenshottableView().takeScreenshot(frame: frame, afterScreenUpdates: true)
                            sharedImage = screenshot
                        }
                    }
            }
        }
        
        .onAppear(perform: {
            convertDateRangeToStrings()
            shotting = true
        })
        .onChange(of: date) { oldValue, newValue in
            viewModel.daylightFromLocation(on: date)
        }
        .onChange(of: viewModel.kaal) { oldValue, newValue in
            convertDateRangeToStrings()
        }
        .onChange(of: sharedImage) { oldValue, newValue in
            // to do: enable share button
            if newValue != nil{
                print("Hurray")
            }
        }
        .sheet(isPresented: $isShareSheetPresented) {
            ActivityView(activityItems: [ sharedImage]) // Replace this with the content you want to share
        }
        
        
    }
    
    func screenshottableView() -> some View {
        
        return
        VStack{
            CustomDatePickerView(date: $date)
                .padding(.vertical)
                .background(Color.secondary.opacity(0.3))
            
            
            if storedTimeFormat == "hh:mm a" {
                Highlighted12HourClockView(range: kaalRange).padding(.vertical)
            } else {
                Highlighted24HourClockView(range: kaalRange).padding(.vertical)
            }
            HStack{
                VStack(alignment: .leading) {
                    Text("Start time").font(.subheadline)
                    Text(startTime).font(.title2).bold()
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("End time").font(.subheadline)
                    Text(endTime).font(.title2).bold()
                }
                
            }
            .padding()
            
        }
        .background(Color.secondary.opacity(0.2))
        .cornerRadius(10)
        .padding()
    }
    
    func convertDateRangeToStrings() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = storedTimeFormat
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let lowerBound = dateFormatter.string(from: viewModel.kaal.rahuKaal.lowerBound)
        startTime = lowerBound
        let upperbound = dateFormatter.string(from: viewModel.kaal.rahuKaal.upperBound)
        endTime = upperbound
    }
}

#Preview {
    KaalDetailView(kaalRange: Date()...(DateFormatter().calendar.date(byAdding: .hour, value: +8, to: Date()) ?? Date()))
}

struct ActivityView: UIViewControllerRepresentable {
    var activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
            // Update the view controller if needed
    }
}


extension UIView {
    func takeScreenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return capturedImage
    }
    
    func takeScreenshot(afterScreenUpdates: Bool) -> UIImage {
        if !self.responds(to: #selector(drawHierarchy(in:afterScreenUpdates:))) {
            return self.takeScreenshot()
        }
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, UIScreen.main.scale)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: afterScreenUpdates)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot!
    }
}

extension View {
    func takeScreenshot(frame:CGRect, afterScreenUpdates: Bool) -> UIImage {
        let hosting = UIHostingController(rootView: self)
        hosting.overrideUserInterfaceStyle = UIApplication.shared.currentUIWindow()?.overrideUserInterfaceStyle ?? .unspecified
        hosting.view.frame = frame
        return hosting.view.takeScreenshot(afterScreenUpdates: afterScreenUpdates)
    }
}

extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
        
        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }
        
        return window
    }
}
