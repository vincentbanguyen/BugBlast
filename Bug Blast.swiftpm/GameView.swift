import SwiftUI

struct GameView: View {
    @State var isPropelling = false
    @State var isReversing = false
    @State var isShooting = false
    let shootPlayer = MusicPlayer(audioName: "shoot", volume: 0.3, fileType: "wav", playInfinite: false)
    var body: some View {
        ZStack {
            SpaceARView(isPropelling: $isPropelling, isReversing: $isReversing, isShooting: $isShooting)
            
            Color.init(hex: "#969696")
                .reverseMask {
                    Ellipse()
                        .frame(width: screenWidth * 0.95, height: screenHeight * 0.95)
                }
                .ignoresSafeArea()
            
            Circle()
                .frame(width: 10, height: 10)
                .foregroundColor(.white)
            
            Circle()
                .stroke(Color.white, lineWidth: 4)
                .foregroundColor(.clear)
                .frame(width: 40, height: 40)
            
            VStack {
                HStack {
                    Spacer()
                    HStack {
                        Text("WWDC2022")
                            .font(.system(size: screenWidth * 0.02, weight: .semibold, design: .rounded))
                            .foregroundColor(.black)
                        Image(systemName: "swift")
                            .foregroundColor(.black)
                            .font(.system(size: screenWidth * 0.02, weight: .semibold))
                    }
                    .padding(30)
                    
                }
                Spacer()
                ControlBoard()
                    .frame(width: screenWidth, height: screenHeight * 0.25)
                    .foregroundColor(.init(hex: "#c6c4bc"))
            }
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                HStack {
                    ZStack {
                        // shoot button
                        Circle()
                            .foregroundColor(.orange)
                            .frame(width: screenWidth * 0.15, height: screenWidth * 0.15)
                        Image(systemName: "wrench.and.screwdriver.fill")
                            .foregroundColor(.white)
                            .font(.system(size: screenWidth * 0.08))
                    }
                    .padding(.leading, screenWidth * 0.045)
                    .padding(.bottom, 15)
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged({ _ in
                                isShooting = true
                                shootPlayer.play()
                            })
                            .onEnded({ _ in
                                isShooting = false
                            })
                    )
                    
                    Spacer()
                    VStack {
                        // propel button
                        Image(systemName: "chevron.compact.up")
                            .foregroundColor(.init(hex: "#24b48b"))
                            .font(.system(size: screenWidth * 0.16, weight: .semibold))
                            .simultaneousGesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged({ _ in
                                        isPropelling = true
                                    })
                                    .onEnded({ _ in
                                        isPropelling = false
                                    })
                            )
                        
                        // reverse button
                        Image(systemName: "chevron.compact.down")
                            .foregroundColor(.init(hex: "#a91b1b"))
                            .font(.system(size: screenWidth * 0.16, weight: .semibold))
                            .simultaneousGesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged({ _ in
                                        isReversing = true
                                    })
                                    .onEnded({ _ in
                                        isReversing = false
                                    })
                            )
                    }
                    .padding(.trailing, screenWidth * 0.045)
                    .padding(.bottom, screenHeight * 0.02)
                    
                }
            }
        }
        .onAppear {
            UserDefaults.standard.setValue(0, forKey: "numbugs")
        }
        .onDisappear {
            isShooting = false
        }
    }
}
