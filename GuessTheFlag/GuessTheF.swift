//
//  GuessTheF.swift
//  GuessTheFlag
//
//  Created by Daps Owolabi on 30/10/2021.
//

import SwiftUI


struct FlagImage: View {
    
    var name:String
    
    var body: some View{
        Image(name)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.weight(.bold))
            .foregroundColor(.white)
    }
}

extension View {
    func titleStyleB() -> some View {
        modifier(TitleModifier())
    }
}

struct GuessTheF: View {
    
    @State private var questionCounter = 1
    @State private var showingScore = false
    @State private var showingResults = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var countries = allCountries.shuffled()
    
    static let allCountries =  ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
    
        ZStack{
            RadialGradient(
                stops: [.init(color:Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                        .init(color:Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)],
                center: .top, startRadius:200 , endRadius: 700)
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                
                Text("Guess The Flag")
                    .titleStyleB()
                
                VStack(spacing:15) {
                    VStack{
                        Text("Tap the Flag Of").foregroundStyle(.secondary).font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer]).font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) {number in
                        Button(action:{
                            flagTapped(number)
                        })
                        {
                            FlagImage(name: countries[number])
                        }
                    }
                }
                .frame(maxWidth:.infinity)
                .padding(.vertical,20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                Text("Score \(score)")
                    .font(.title.weight(.semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
            }.padding()
            
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue",action: askQuestion)
        }  message: {
            if scoreTitle == "Wrong"{
                VStack{
                    Text(" Your score is \(score)")
                }
            } else {
                Text("Your score is \(score)")
            }
        }
        .alert("Game Over", isPresented:$showingResults){
            Button("Start Again",action: reset)
        } message: {
            Text("Your final score was \(score)")
        }
         
       
                 
                 
                 
                 
                 
                 
    }
    
    func flagTapped(_ number:Int){
        
        if number == correctAnswer{
            scoreTitle = "Correct"
            score += 1
        } else {
            
            let theirAnswer = countries[number]
            let needsThe = ["UK", "US"]
            
            if needsThe.contains(theirAnswer){
                scoreTitle = "Wrong! That's the flag of The \(theirAnswer)"
            } else {
                scoreTitle = "Wrong! That's the flag of \(theirAnswer)"
            }
            
            if score > 0 {
                score -= 1
            }
           
        }
        
        if questionCounter == 8 {
           showingResults = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion(){
        countries.remove(at: correctAnswer)
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionCounter += 1
    }
    
    func reset() {
        score = 0
        questionCounter = 0
        countries = Self.allCountries
        askQuestion()
    }
                 
}

struct GuessTheF_Previews: PreviewProvider {
    static var previews: some View {
        GuessTheF()
    }
}
