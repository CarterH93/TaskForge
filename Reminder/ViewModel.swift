//
//  ViewModel.swift
//  Task Forge
//
//  Created by Carter Hawkins on 8/26/24.
//

import SwiftUI
import Vortex
import AVFoundation


@Observable class ViewModel {
    var loadingICSData = false
    var toggleConfetti: Bool = false
    
    let confetti = VortexSystem(
        tags: ["square", "circle"],
        position: [0.5, 0],
        shape: .box(width: 1, height: 0),
        birthRate: 0,
        lifespan: 10,
        speed: 0.2,
        speedVariation: 0.5,
        angle: .degrees(180),
        angleRange: .degrees(90),
        acceleration: [0, 0.7],
        angularSpeedVariation: [4, 4, 4],
        colors: .random(.white, .red, .green, .blue, .pink, .orange, .cyan),
        size: 0.5,
        sizeVariation: 0.5
    )
    
    
    //Playing sounds
    var soundEngine: AVAudioPlayer?
    
    func playCompletionSound() {
        let path = Bundle.main.path(forResource: "completion.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            soundEngine = try AVAudioPlayer(contentsOf: url)
            
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSession.Category.ambient,
                options: AVAudioSession.CategoryOptions.mixWithOthers
            )
            
            soundEngine?.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    //Haptics
    var toggleCompletionHaptics = false
    static let buttonPressHapticImpact: SensoryFeedback = .impact(weight: .medium, intensity: 0.8)
    
    func completionActions() {
        self.toggleConfetti.toggle()
        self.playCompletionSound()
        self.toggleCompletionHaptics.toggle()
    }
    
    
    
}
