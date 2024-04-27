//
//  LoadingView.swift
//  SwipePlay
//
//  Created by Wei Lu on 2024/4/27.
//

import SwiftUI

struct LoadingView: View {
    @State var show: Bool = false
    var body: some View {
        Image(systemName: "sun.min.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 80, height: 80)
            .rotationEffect(.degrees(show ? 270 : 0))
            .onAppear {
                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                    show.toggle()
                }
                
                self.show = true
            }
    }
}

#Preview {
    LoadingView()
}
