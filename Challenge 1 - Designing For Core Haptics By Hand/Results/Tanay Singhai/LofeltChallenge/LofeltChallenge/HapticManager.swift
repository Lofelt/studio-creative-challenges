//
//  HapticManager.swift
//  JuicePlayground
//
//  Created by Tanay Singhal on 7/21/20.
//  Copyright © 2020 Tanay Singhal. All rights reserved.
//

import AVFoundation
import CoreHaptics

@available(iOS 13.0, *)
public class HapticManager: NSObject {
    
    static let shared = HapticManager()
    
    static var _engineNeedsStart : Bool = true
    static var _debugMode : Bool = false
    
    static var _engine: CHHapticEngine!
    static var Engine: CHHapticEngine! {
        get {
            if (_engine == nil) {
                CreateEngine()
            }
            if (_engineNeedsStart) {
                StartEngine()
            }
            return _engine
        }
    }
    
    static var _supportsHaptics: Bool?
    static var SupportsHaptics: Bool {
        get {
            if (_supportsHaptics == nil) {
                _supportsHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics
                Debug(log: "Supports haptics \(_supportsHaptics!)")
            }
            return _supportsHaptics!
        }
    }
    
    static var EngineCreatedCallback : (() -> Void)?;
    static var EngineErrorCallback : (() -> Void)?;
    
    static func Debug(log: String) {
        if (_debugMode) {
            print("--- \(log) ---")
        }
    }
    
    /// - Tag: CreateEngine
    public static func CreateEngine() {
        Debug(log: "Create engine")
        // Create and configure a haptic engine.
        do {
            _engine = try CHHapticEngine()
            try _engine.start()
        } catch let error {
            print("Engine Creation Error: \(error)")
            if let errorCallback = EngineErrorCallback { errorCallback() }
            return
        }
        
        if let createdCallback = EngineCreatedCallback { createdCallback() }
        _engineNeedsStart = false
        
        // The stopped handler alerts you of engine stoppage due to external causes.
        _engine.stoppedHandler = { reason in
            print("The engine stopped for reason: \(reason.rawValue)")
            switch reason {
            case .audioSessionInterrupt: print("Audio session interrupt")
            case .applicationSuspended: print("Application suspended")
            case .idleTimeout: print("Idle timeout")
            case .systemError: print("System error")
            case .notifyWhenFinished: print("Playback finished")
            @unknown default:
                print("Unknown error")
            }
            
            _engineNeedsStart = true
        }
        
        // The reset handler provides an opportunity for your app to restart the engine in case of failure.
        _engine.resetHandler = {
            Debug(log: "Engine was reset")
            
            // Tell the rest of the app to start the engine the next time a haptic is necessary.
            _engineNeedsStart = true
        }
    }
    
    static func StartEngine() {
        // Start haptic engine to prepare for use.
        do {
            Debug(log: "Start engine")
            try _engine.start()
            
            // Indicate that the next time the app requires a haptic, the app doesn't need to call engine.start().
            _engineNeedsStart = false
        } catch let error {
            print("The engine failed to start with error: \(error)")
        }
    }
    
    public static func SetDebug(bool: Bool) {
        _debugMode = bool
    }
    
    public static func SupportsCoreHaptics() -> Bool {
        return SupportsHaptics
    }
    
    public static func PlayTransient(intensity: Float, sharpness: Float) {
        Debug(log: "Playing transient haptic")
        if (!SupportsHaptics)
        {
            return;
        }
        
        let clampedIntensity = Clamp(value: intensity, min: 0, max: 1);
        let clampedSharpness = Clamp(value: sharpness, min: 0, max: 1);
        
        let hapticIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: clampedIntensity);
        let hapticSharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: clampedSharpness);
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [hapticIntensity, hapticSharpness], relativeTime: 0);
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: []);
            let player = try Engine.makePlayer(with: pattern);
            try player.start(atTime: CHHapticTimeImmediate);
        }
        catch let error
        {
            print("Failed to play transient pattern: \(error.localizedDescription).");
            if let errorCallback = EngineErrorCallback { errorCallback() }
        }
    }
    
    
    public static func PlayContinuous(intensity: Float, sharpness: Float, duration: Double) {
        Debug(log: "PlayContinuousHaptic method, intensity : \(intensity) sharpness : \(sharpness) duration : \(duration)");
        
        if (!SupportsHaptics)
        {
            return;
        }
        
        let clampedIntensity = Clamp(value: intensity, min: 0, max: 1);
        let clampedSharpness = Clamp(value: sharpness, min: 0, max: 1);
        
        let hapticIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: clampedIntensity);
        let hapticSharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: clampedSharpness);
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [hapticIntensity, hapticSharpness], relativeTime: 0, duration: duration);
        
        do
        {
            let pattern = try CHHapticPattern(events: [event], parameters: []);
            let player = try Engine.makePlayer(with: pattern);
            try player.start(atTime: CHHapticTimeImmediate);
        }
        catch let error
        {
            print("Failed to play continuous pattern: \(error.localizedDescription).");
            if let errorCallback = EngineErrorCallback { errorCallback() }
        }
    }
    
    public static func PlayFromAHAP(url: URL) {
        Debug(log: "Playing haptic from file \(url)")
        
        if !SupportsHaptics {
            return
        }
        
        
        do {
            // These are needed so the sound plays through the proper speaker (and is loud enough)
            // These settings can change if the user moves this app to the background, which
            // is why we have to set them again whenever we play audio
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            try Engine.playPattern(from: url)
            
            // Engine.notifyWhenPlayersFinished { (Error) -> CHHapticEngine.FinishedAction in
            //     if let completeCallback = onComplete { completeCallback() }
            //     return CHHapticEngine.FinishedAction.leaveEngineRunning;
            // }
            
        } catch {
            print("Failed to play haptic pattern from url: \(url)");
            if let errorCallback = EngineErrorCallback { errorCallback() }
        }
    }
    
    //MARK: Helper functions
    static func Clamp(value: Float, min: Float, max: Float ) -> Float {
        if (value > max)
        {
            return max;
        }
        if (value < min)
        {
            return min;
        }
        return value;
    }
}
