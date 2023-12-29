//
//  ContentView.swift
//  GeminiChat
//
//  Created by Ary Sugiarto on 29/12/23.
//

import SwiftUI
import Combine
import GoogleGenerativeAI

struct ContentView: View {
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    @State var textInput = ""
    @State var aiResponse = "Hello ! How can i help you today"
    @State var logoAnimating = false
    @State private var timer: Timer?
    
    
    
    var body: some View {
        VStack{
            Image(.geminiLogo)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                            .opacity(logoAnimating ? 0.5 : 1)
                            .animation(.easeInOut, value: logoAnimating)
            
            //MARK: AI response
            ScrollView{
                Text(aiResponse)
                    .font(.title)
                    .multilineTextAlignment(.leading)
            }
            
            //MARK: Input fields
            HStack{
                TextField("Enter a message", text: $textInput)
                    .textFieldStyle(.roundedBorder)
                    .foregroundStyle(.black)
                Button(action: sendMessage, label: {
                    Image(systemName: "paperplane.fill")
                })
            }
            
        }.foregroundStyle(.white)
            .padding()
            .background{
                ZStack{
                    Color.black
                }
                .ignoresSafeArea()
            }
    }
    
    //MARK: Fect response
    func sendMessage(){
        aiResponse = ""
        startLoadingAnimation()
        
        Task{
            do{
                let response = try await model.generateContent(textInput)
                
                stopLoadingAnimation()
                
                guard let text = response.text else {
                    textInput = "Sorry, I could not process that. \nPlease try again."
                    return
                }
                
                textInput = ""
                aiResponse = text
                
            }catch{
                stopLoadingAnimation()
                aiResponse = "Something went wrong!\n\(error.localizedDescription)"
            }
        }
    }
    
    // MARK: Response loading animation
        func startLoadingAnimation() {
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
                logoAnimating.toggle()
            })
        }
        
        func stopLoadingAnimation() {
            logoAnimating = false
            timer?.invalidate()
            timer = nil
        }
}

#Preview {
    ContentView()
}
