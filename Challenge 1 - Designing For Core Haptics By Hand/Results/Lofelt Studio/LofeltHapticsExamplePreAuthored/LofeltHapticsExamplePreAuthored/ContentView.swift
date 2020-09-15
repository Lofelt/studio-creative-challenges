//
//  ContentView.swift
//  LofeltHapticsExamplePreAuthored
//
//  Created by Tomash Ghz on 09.07.20.
//  Copyright © 2020 Lofelt GmbH. All rights reserved.
//

import SwiftUI
import LofeltHaptics
import AVFoundation

var audioPlayer: AVAudioPlayer?
var haptics: LofeltHaptics?

struct ContentView: View {
    
    init(){
        // instantiate haptics player
        haptics = try? LofeltHaptics.init()
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // load audio clip
                    let audioData = NSDataAsset(name: "BowRelease-audio")
                    audioPlayer = try? AVAudioPlayer(data: audioData!.data)
                    
                    // load haptic clip
                    try? haptics?.load(self.loadHapticData(fileName: "BowRelease.haptic"))
                    
                    // play audio and haptic clip
                    audioPlayer?.play()
                    try? haptics?.play()
                }) {
                    HStack {
                        Text("Bow Release")
                    }
                }
                .shadow(radius: 20.0)
                .padding()
                .background(Color.gray)
                .cornerRadius(10.0)
                
                Button(action: {
                    // load audio clip
                    let audioData = NSDataAsset(name: "snow 1-audio")
                    audioPlayer = try? AVAudioPlayer(data: audioData!.data)
                    
                    // load haptic clip
                    try? haptics?.load(self.loadHapticData(fileName: "snow 1.haptic"))
                    
                    // play audio and haptic clip
                    audioPlayer?.play()
                    try? haptics?.play()
                }) {
                    HStack {
                        Text("Snow Footstep")
                    }
                }
                .shadow(radius: 20.0)
                .padding()
                .background(Color.gray)
                .cornerRadius(10.0)
                
            }.padding()
            
        }
        .foregroundColor(Color.white)
        .font(.subheadline)
    }
    
    func loadHapticData(fileName: String) -> String {
        let hapticData = NSDataAsset(name: fileName)
        let dataString = NSString(data: hapticData!.data , encoding: String.Encoding.utf8.rawValue)
        return dataString! as String
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
