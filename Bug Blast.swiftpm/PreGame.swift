import SwiftUI

struct PreGame: View {
    @EnvironmentObject var viewRouter: ViewRouter
    let pregameURL = Bundle.main.path(forResource: "pregame", ofType: "jpg")!
    var body: some View {
        ZStack {
            Color.init(hex: "101444")
                .ignoresSafeArea()
            
            Image(uiImage: UIImage(contentsOfFile: pregameURL)!)
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth * 0.5)
            .offset(x: -screenWidth * 0.2, y: -screenHeight * 0.1)
            
            Color.init(hex: "#969696")
                .reverseMask {
                    Ellipse()
                        .frame(width: screenWidth * 0.95, height: screenHeight * 0.95)
                }
                .ignoresSafeArea()
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
            
            HStack {
                Spacer()
                ZStack {
                    Rectangle()
                        .foregroundColor(.init(hex: "#82a6a5"))
                        .frame(width: screenWidth * 0.4, height: screenHeight * 0.7)
                        .cornerRadius(30)
                        .overlay(RoundedRectangle(cornerRadius: 10, style: .circular)
                                    .stroke(Color.init(hex: "#515c5c"), lineWidth: 15))

                    VStack {
                        Text("Message from Mission Control:\n")
                            .foregroundColor(.black)
                            .font(.system(size: screenWidth * 0.02, weight: .bold, design: .rounded))
                        Text("Planet Apple is in DANGER!\n")
                            .foregroundColor(Color.init(hex: "#a91b1b"))
                            .font(.system(size: 30, weight: .bold , design: .rounded))
                            .foregroundColor(Color.init(hex: "#a91b1b"))
                        
                        Text("A bug invasion is about to wreak havoc!")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(Color.init(hex: "#515c5c"))
                        Text("Fix these bugs before time runs out!")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(Color.init(hex: "#515c5c"))
                        
                        Button {
                            viewRouter.currentScreen = .Game
                        } label: {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.init(hex: "#a7ecca"))
                                    .frame(width: screenWidth * 0.2, height: screenHeight * 0.15)
                                    .overlay(RoundedRectangle(cornerRadius: 10, style: .circular)
                                        .stroke(Color.init(hex: "#24b48b"), lineWidth: 8))

                                Text("GO")
                                    .foregroundColor(Color.init(hex: "#24b48b"))
                                    .font(.system(size: 60, weight: .semibold, design: .rounded))
                            }

                        }
                        .padding(20)

                        Text("\nTips: Make sure to have enough space to\nmove around in this virtual reality game\nand turn on sound to enjoy the music!\n\n(Make sure that Silent Mode is off)")
                            .foregroundColor(.init(hex: "515c5c"))
                            .font(.system(size: 20, weight: .semibold, design: .rounded))

                    }


                }
                .padding(.trailing, 30)
            }
            // controls
            
        }
        .ignoresSafeArea()
        .onAppear {
            UserDefaults.standard.setValue(0, forKey: "numbugs")
         }
    }
}
