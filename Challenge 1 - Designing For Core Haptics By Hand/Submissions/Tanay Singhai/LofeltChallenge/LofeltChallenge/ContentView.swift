//
//  ContentView.swift
//  LofeltChallenge
//
//  Created by Tanay Singhal on 8/6/20.
//  Copyright © 2020 Tanay Singhal. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Button("Bow Release (old)") {
                    HapticManager.PlayFromAHAP(url: Bundle.main.url(forResource: "vibration1.ahap", withExtension: "")!)
                }.padding()
                
                Button("Bow Release (new))") {
                    HapticManager.PlayFromAHAP(url: Bundle.main.url(forResource: "vibration1_new.ahap", withExtension: "")!)
                }.padding()
            }
            
            Spacer()
            
            HStack {
                Button("Snow (old)") {
                    HapticManager.PlayFromAHAP(url: Bundle.main.url(forResource: "vibration2.ahap", withExtension: "")!)
                }.padding()
                
                Button("Snow (new)") {
                    HapticManager.PlayFromAHAP(url: Bundle.main.url(forResource: "vibration2_new.ahap", withExtension: "")!)
                }.padding()
            }
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
