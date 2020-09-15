//
//  ViewController.swift
//  Lofelt_AHAP_Test_Project
//
//  Created by Nick Arner on 8/7/20.
//

import UIKit
import AudioKit
import CoreHaptics

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var audioFilePicker: UIPickerView!
    var playerOne: AKPlayer!
    var playerTwo: AKPlayer!
    var playerThree: AKPlayer!
    
    var bowReleaseAudioFile: AKAudioFile!
    var snowOneAudioFile: AKAudioFile!
    var snowTwoAudioFile: AKAudioFile!
    var audioFiles: [AKAudioFile] = []
    var selectedAudio: String!
    
    // A haptic engine manages the connection to the haptic server.
    var engine: CHHapticEngine!
    
    // Maintain a variable to check for Core Haptics compatibility on device.
    lazy var supportsHaptics: Bool = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.supportsHaptics
    }()
    
    
    //MARK: View Lifecycle
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.audioFilePicker.delegate = self
        self.audioFilePicker.dataSource = self
        
        setupAudioPlayer()
        createHapticEngine()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        do {
            try AudioKit.stop()
        } catch {
            print("AudioKit failed to stop!")
        }
    }
    
    
    //MARK: Audio
    
    func setupAudioPlayer() {
        
        do {
            bowReleaseAudioFile = try AKAudioFile(readFileName: "BowRelease.wav")
            snowOneAudioFile = try AKAudioFile(readFileName: "snow1.wav")
            snowTwoAudioFile = try AKAudioFile(readFileName: "snow2.wav")
        } catch {
            print("Could not create audio files!")
        }
        
        audioFiles.append(bowReleaseAudioFile)
        audioFiles.append(snowOneAudioFile)
        audioFiles.append(snowTwoAudioFile)
        
        playerOne = AKPlayer(audioFile: bowReleaseAudioFile)
        playerOne.isLooping = false
        playerOne.buffering = .always
        playerTwo = AKPlayer(audioFile: snowOneAudioFile)
        playerTwo.isLooping = false
        playerTwo.buffering = .always
        playerThree = AKPlayer(audioFile: snowTwoAudioFile)
        playerThree.isLooping = false
        playerThree.buffering = .always
        
        let mixer = AKMixer(playerOne, playerTwo, playerThree)
        AudioKit.output = mixer
        
        do {
            try AudioKit.start()
        } catch {
            print("AudioKit failed to start!")
        }
    }
    
    
    //MARK: Haptics
    
    func createHapticEngine() {
        // Create and configure a haptic engine.
        do {
            engine = try CHHapticEngine()
        } catch let error {
            print("Engine Creation Error: \(error)")
        }
        
        if engine == nil {
            print("Failed to create engine!")
        }
        
        // The stopped handler alerts you of engine stoppage due to external causes.
        engine.stoppedHandler = { reason in
            print("The engine stopped for reason: \(reason.rawValue)")
            switch reason {
            case .audioSessionInterrupt:
                print("Audio session interrupt")
            case .applicationSuspended:
                print("Application suspended")
            case .idleTimeout:
                print("Idle timeout")
            case .systemError:
                print("System error")
            case .notifyWhenFinished:
                print("Playback finished")
            @unknown default:
                print("Unknown error")
            }
        }
        
        // The reset handler provides an opportunity for your app to restart the engine in case of failure.
        engine.resetHandler = {
            // Try restarting the engine.
            print("The engine reset --> Restarting now!")
            do {
                try self.engine.start()
            } catch {
                print("Failed to restart the engine: \(error)")
            }
        }
    }
    
    
    //MARK: UI Methods
    
    @IBAction func playAudio(_ sender: Any) {
        if selectedAudio == nil {
            selectedAudio = "BowRelease"
        }
        
        if selectedAudio == "BowRelease" {
            playerOne.play()
        } else if selectedAudio == "snow1" {
            playerTwo.play()
        } else {
            playerThree.play()
        }
    }
    
    @IBAction func playHaptics(_ sender: Any) {
        // If the device doesn't support Core Haptics, abort.
        if !supportsHaptics {
            return
        }
        
        var path: String!
        
        if selectedAudio == nil {
            selectedAudio = "BowRelease"
        }
        
        if selectedAudio == "BowRelease"{
            // Express the path to the AHAP file before attempting to load it.
            path = Bundle.main.path(forResource: "BowRelease", ofType: "ahap")
        }
        
        if selectedAudio == "snow1"{
            // Express the path to the AHAP file before attempting to load it.
            path = Bundle.main.path(forResource: "snow1", ofType: "ahap")
        }
        
        if selectedAudio == "snow2"{
            // Express the path to the AHAP file before attempting to load it.
            path = Bundle.main.path(forResource: "snow2", ofType: "ahap")
        }
        
        
        do {
            // Start the engine in case it's idle.
            try engine.start()
            
            // Tell the engine to play a pattern.
            try engine.playPattern(from: URL(fileURLWithPath: path))
            
        } catch { // Engine startup errors
            print("An error occured playing \(String(describing: path)): \(error).")
        }
    }
    
    
    //MARK: UIPickerDelegate Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return audioFiles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return audioFiles[row].fileName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedAudio = audioFiles[row].fileName
    }
}

