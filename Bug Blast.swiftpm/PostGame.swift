import SwiftUI

struct PostGame: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State var score = 0
    var body: some View {
        ZStack {
            
            Color.init(hex: "#969696")
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
            
            VStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(.init(hex: "#82a6a5"))
                        .frame(width: screenWidth * 0.8, height: screenHeight * 0.55)
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 10, style: .circular)
                                    .stroke(Color.init(hex: "#515c5c"), lineWidth: 15))
                    if score == 22 {
                        VStack {
                            Text("YAY!")
                                .foregroundColor(Color.init(hex: "#a7ecca"))
                                .font(.system(size: 40, weight: .bold , design: .rounded))
                            
                            Text("You fixed all \(score) bugs!")
                                .font(.system(size: 75, weight: .semibold, design: .rounded))
                                .foregroundColor(.black)
                            
                            Text("Thank you for saving Planet Apple")
                                .font(.system(size: 30, weight: .semibold, design: .rounded))
                                .foregroundColor(.init(hex: "#515c5c"))
                            
                            Text("I hope you enjoyed your time in space :)")
                                .font(.system(size: 30, weight: .semibold, design: .rounded))
                                .foregroundColor(.init(hex: "#515c5c"))
                            
                        }
                        .offset(y: -50)
                    } else {
                        VStack {
                            Text("TIME IS UP")
                                .foregroundColor(Color.init(hex: "#a91b1b"))
                                .font(.system(size: 40, weight: .bold , design: .rounded))
                            
                            Text("You fixed \(score) bugs!")
                                .font(.system(size: 80, weight: .semibold, design: .rounded))
                                .foregroundColor(.black)
                            
                            Text("I hope you enjoyed your time in space :)")
                                .font(.system(size: 30, weight: .semibold, design: .rounded))
                                .foregroundColor(.init(hex: "#515c5c"))
                        }
                        .offset(y: -50)
                        
                    }
                    
                    
                }
                .offset(y: 80)
                
                Spacer()
            }
            
            Button {
                viewRouter.currentScreen = .Game
            } label: {
                ZStack {
                    Rectangle()
                        .foregroundColor(.init(hex: "#a7ecca"))
                        .frame(width: screenWidth * 0.2, height: screenHeight * 0.1)
                        .overlay(RoundedRectangle(cornerRadius: 10, style: .circular)
                            .stroke(Color.init(hex: "#24b48b"), lineWidth: 8))

                    Text("Play Again")
                        .foregroundColor(Color.init(hex: "#24b48b"))
                        .font(.system(size: 40, weight: .semibold, design: .rounded))
                }

            }
            .offset(y: 20)
        }
        .ignoresSafeArea()
        .onAppear {
            score = UserDefaults.standard.value(forKey: "numbugs") as! Int
            
         }
    }
}
