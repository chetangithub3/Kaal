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
    var kaal: Kaal
    @AppStorage("timeFormat") private var storedTimeFormat = "hh:mm a"
    @State var date = Date()
    @EnvironmentObject var viewModel: DashboardViewModel
    @State var startTime = ""
    @State var endTime = ""
    @State var sharedImage: UIImage?
    @State private var isShareSheetPresented = false
    @State var isEnableShared = false
    @State var buttonHeight: CGFloat = 30
    
    var body: some View {
        ScrollView{
                screenshottableView()
                    .background(
                        GeometryReader { geometry in
                            VStack{
                            }
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .onAppear(perform: {
                                    DispatchQueue.main.async{
                                        let frame = geometry.frame(in: .global)
                                        let screenshot = screenshottableView().takeScreenshot(frame: frame, afterScreenUpdates: true)
                                        sharedImage = screenshot
                                    }
                                })
                        }
                    )
                    .redacted(reason: viewModel.isLoading == true ? .placeholder : [])
//
            
            HStack{
                Spacer()
                Button {
                    isShareSheetPresented = true
                } label: {
                    HStack{
                        Text("Share").font(.subheadline)
                        Image(systemName: "square.and.arrow.up")
                    }
                    .padding(8)
                    .frame(height: buttonHeight)
                    .foregroundColor(.primary)
                    .background(Color.secondary)
                    .cornerRadius(10)
                }
            }
            Spacer()
        }
        .onPreferenceChange(ButtonHeightKey.self) { newValue in
            buttonHeight = newValue
        }
        .onAppear(perform: {
            convertDateRangeToStrings(range: kaalRange)
        })
        .onChange(of: date) { oldValue, newValue in
            viewModel.daylightFromLocation(on: date)
        }
        .onChange(of: viewModel.kaal) { oldValue, newValue in
            convertDateRangeToStrings(range: kaalRange)
        }
        .onChange(of: sharedImage) { oldValue, newValue in
            if newValue != nil{
                isEnableShared = true
            }
        }
        .sheet(isPresented: $isShareSheetPresented) {
            ActivityView(activityItems: [sharedImage as Any]) // Replace this with the content you want to share
        }
        
        
    }
    
    func screenshottableView() -> some View {
        VStack{
            CustomDatePickerView(date: $date, timezone: viewModel.kaal.timezone)
                .padding(.vertical)
                .background(Color.secondary.opacity(0.3))
            
                HStack{
                        Text(kaal.title).font(.title3).bold()
                        Text(":")
                        Text(kaal.nature.description).font(.title3).bold()
                }
            
            .padding()
            
            if storedTimeFormat == "hh:mm a" {
                Highlighted12HourClockView(timezone: viewModel.kaal.timezone, range: kaalRange).padding(.vertical)
            } else {
                Highlighted24HourClockView(timezone: viewModel.kaal.timezone, range: kaalRange).padding(.vertical)
            }
            VStack{
                HStack{
                    VStack(alignment: .leading) {
                        Text("Starts at:").font(.subheadline)
                        Text(startTime).font(.title2).bold()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Ends at:").font(.subheadline)
                        Text(endTime).font(.title2).bold()
                    }
                    
                }
                Text("Note: All times are according to the local time of the saved location.")
                               .italic()
                               .font(.subheadline)
                               .foregroundColor(.gray)
                               .lineLimit(1)
                               .minimumScaleFactor(0.5)
            }
            .padding()
      
            LocationItemView()
                .padding(.vertical)
                .padding(.horizontal)
                .background(Color.secondary.opacity(0.3))
            
        }
        .background(Color.secondary.opacity(0.2))
        .cornerRadius(10)
        .padding()
    }
    
    func convertDateRangeToStrings(range: ClosedRange<Date>) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = storedTimeFormat
        dateFormatter.timeZone = TimeZone(identifier: viewModel.kaal.timezone)
        let lowerBound = dateFormatter.string(from: range.lowerBound)
        startTime = lowerBound
        let upperbound = dateFormatter.string(from: range.upperBound)
        endTime = upperbound
    }
}

#Preview {
    KaalDetailView(kaalRange: Date()...(DateFormatter().calendar.date(byAdding: .hour, value: +8, to: Date()) ?? Date()), kaal: Kaal.brahma)
}

struct ActivityView: UIViewControllerRepresentable {
    var activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}


struct ButtonHeightKey: PreferenceKey {
    typealias Value = CGFloat
    
    static var defaultValue: CGFloat = 30 // Default value
 
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
