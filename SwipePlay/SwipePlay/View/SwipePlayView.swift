//
//  SwipePlayView.swift
//  SwipePlay
//
//  Created by Wei Lu on 2024/4/27.
//

import SwiftUI

struct SwipePlayView: View {
    @State private var videos: [ModelMediaInfo]=[
        ModelMediaInfo(id:1, url:"url"),
        ModelMediaInfo(id:2, url:"url"),
        ModelMediaInfo(id:3, url:"url"),
        ModelMediaInfo(id:4, url:"url"),
        ModelMediaInfo(id:5, url:"url"),
    ]
    
    @State private var prePage: Int = -1
    @State private var currentPage: Int = 0
    @GestureState private var translation: CGFloat = 0
    
    @State private var endId: String = "0"
    
    var body: some View {
        ZStack{
            GeometryReader { geometry in
                let screenHeight = geometry.size.height
                let threshold = screenHeight * 0.1
                
                if self.videos.count == 0 {
                    LoadingView().frame(maxWidth: .infinity, maxHeight: .infinity)
                }else {
                    ScrollViewReader { scrollView in
                        List{
                            ForEach(videos.indices, id: \.self) { index in
                                VideoView(videoUrl: videos[index].url ?? "")
                                    .id(index)
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .gesture(
                                        DragGesture()
                                            .updating(self.$translation) { value, state, _ in
                                                state = value.translation.height
                                            }
                                            .onEnded { value in
                                                let offset = value.translation.height
                                                if abs(offset) > threshold {
                                                    withAnimation {
                                                        if offset < 0 && self.currentPage < self.videos.count - 1 {
                                                            self.currentPage += 1
                                                        } else if offset > 0 && self.currentPage > 0 {
                                                            self.currentPage -= 1
                                                        }
                                                        
                                                        if offset < 0 && (self.currentPage == self.videos.count - 3 || self.currentPage == self.videos.count - 1) {
                                                            self.fetchData()
                                                        }else if offset > 0 && self.currentPage == 0 {
                                                            self.fetchData(force: true)
                                                        }
                                                    }
                                                }
                                            }
                                    )
                            }
                        }
                        .onChange(of: currentPage){ target in
                            withAnimation {
                                if self.prePage != self.currentPage {
                                    scrollView.scrollTo(target, anchor: .top)
                                    self.prePage = self.currentPage
                                }
                            }
                        }
                        .listStyle(.plain)
                        .environment(\.defaultMinListRowHeight, 0)
                        .offset(y: self.translation)
                        .animation(.interactiveSpring(response: 0.3, dampingFraction: 1), value: self.translation)
                    }
                }
                
            }.onAppear(){
                if self.videos.count == 0 {
                    self.fetchData(force:true)
                }
            }
        }
    }
    
    private func fetchData(force: Bool = false) {
        
    }
}

//#Preview {
//    SwipePlayView()
//}
