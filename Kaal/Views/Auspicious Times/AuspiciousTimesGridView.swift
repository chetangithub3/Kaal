//
//  AuspiciousTimesGridView.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/9/23.
//

import SwiftUI

struct AuspiciousTimesGridView: View {
    @EnvironmentObject var viewModel: DashboardViewModel
    var body: some View {
    
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible())]) {
          
                
                
              
            }
            
      
    }
}

#Preview {
    AuspiciousTimesGridView()
}
