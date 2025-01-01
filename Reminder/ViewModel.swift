//
//  ViewModel.swift
//  Task Forge
//
//  Created by Carter Hawkins on 8/26/24.
//

import SwiftUI
import Vortex
import AVFoundation

struct DelayItem: Equatable, Hashable {
    var id: String
    var delay = Delay()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: DelayItem, rhs: DelayItem) -> Bool {
        return lhs.id == rhs.id
    }
}


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
    
    
    var pendingCompletion = Set<DelayItem>()
    
    //Anything inside storage class will be saved to device automatically
    var storage: Storage = Storage() {
        
        //did set for saving data to the disk
        
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(storage) {
                
                let str = encoded
                let url = savePath
                
                do {
                    //AtomicWrite: This makes sure all the data is saved at once. Prevents missing data from occurring.
                    //CompleteFileProtection: Encryptes our data. Can remove if causing data access issues
                    try str.write(to: url, options: [.atomicWrite, .completeFileProtection])
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    //init for loading data from the disk
        init() {
            if let savedItems = try? Data(contentsOf: savePath) {
                if let decodedItems = try? JSONDecoder().decode(Storage.self, from: savedItems) {
                    storage = decodedItems
                    return
                }
            }
            storage = Storage()
        }
    
    
    //Helper info and functions for saving and retrieving data
    
    private static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    private let savePath = getDocumentsDirectory().appendingPathComponent("SavedStorageData")
    
    //
     
}

 struct Storage: Codable {
    //Variables that data can be stored to anywhere in the app
    var showingOnboardingScreen = true
}
    
    
    

