    //
    //  KaalDetailView.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 1/1/24.
    //

import SwiftUI
import Shimmer
struct KaalDetailView: View {
    
    @AppStorage("currentArea") var currentArea: String = ""
    var kaalRange: ClosedRange<Date>
    var kaal: Kaal
    @AppStorage("timeFormat") private var storedTimeFormat = "hh:mm a"
    @Binding var date: Date
    @EnvironmentObject var viewModel: DashboardViewModel
    @State var startTime = ""
    @State var endTime = ""
    @State var sharedImage: UIImage?
    @State private var isShareSheetPresented = false
    @State var isEnableShared = false
    @State var buttonHeight: CGFloat = 30
    @State var geometry: GeometryProxy?
    
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
                                self.geometry = geometry
                            }
                        })
                    }
                )
  
            HStack{
                Spacer()
                Button {
                    if let geometry = self.geometry{
                        takeScreenshot(geometry: geometry) {
                            isShareSheetPresented = true
                        }
                    }
                } label: {
                    HStack{
                        Text("Share").font(.subheadline)
                        Image(systemName: "square.and.arrow.up")
                    }
                    .padding(8)
                    .frame(height: buttonHeight)
                    .foregroundColor(getTintColor())
                    .background(Color.secondary.opacity(0.3))
                    .cornerRadius(10)
                    .opacity(viewModel.isLoading ? 0.2 : 1.0)
                    .disabled(viewModel.isLoading)
                }
            }.padding(.horizontal)
            Spacer()
        }
        .onPreferenceChange(ButtonHeightKey.self) { newValue in
            buttonHeight = newValue
        }
        .onAppear(perform: {
            convertDateRangeToStrings(range: kaalRange)
        })
        .onChange(of: viewModel.kaal.date) { oldValue, newValue in
            viewModel.daylightFromLocation(on: viewModel.kaal.date)
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
    
    func takeScreenshot(geometry: GeometryProxy,  completion : @escaping () -> Void) {
        let frame = geometry.frame(in: .global)
        let screenshot = screenshottableView().takeScreenshot(frame: frame, afterScreenUpdates: true)
        sharedImage = screenshot
        if sharedImage != nil {
            completion()
        }
    }
    
    func screenshottableView() -> some View {
        VStack{
            CustomDatePickerView(date: $date, timezone: viewModel.kaal.timezone)
                .padding(.vertical)
                .background(Color.secondary.opacity(0.3))
            VStack{
                HStack(spacing: 4){
                    Text(kaal.title).font(.title3).bold()
                    Text(":")
                    Text(kaal.nature.description)
                        .foregroundStyle(kaal.color)
                        .font(.title3).bold()
                        
                }

                if storedTimeFormat == "hh:mm a" {
                    Highlighted12HourClockView(theme: kaal.nature, timezone: viewModel.kaal.timezone, range: kaalRange).padding(.vertical)
                } else {
                    Highlighted24HourClockView(theme: kaal.nature, timezone: viewModel.kaal.timezone, range: kaalRange).padding(.vertical)
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
            }
            .padding()
            .shimmering(
                active: viewModel.isLoading,
                animation: .easeInOut(duration: 2).repeatCount(5, autoreverses: false).delay(1)
            )
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
            
            
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
    KaalDetailView(kaalRange: Date()...(DateFormatter().calendar.date(byAdding: .hour, value: +8, to: Date()) ?? Date()), kaal: Kaal.brahma, date: .constant(Date()))
}




struct ButtonHeightKey: PreferenceKey {
    typealias Value = CGFloat
    
    static var defaultValue: CGFloat = 30 // Default value
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
