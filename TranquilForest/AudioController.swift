//
//  AudioController.swift
//  TranquilForest
//
//  Created by David Ritchie on 11/19/19.
//  Copyright © 2019 David Ritchie. All rights reserved.
//

import Foundation
import AVFoundation

class AudioController {
    var audioPlayers: Dictionary<String, AVAudioPlayer>
    
    init() {
        audioPlayers = Dictionary<String, AVAudioPlayer>()
        NotificationCenter.default.addObserver(self, selector: #selector(onCmdStartPlaying), name: .cmdStartPlaying, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onCmdStopPlaying), name: .cmdStopPlaying, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onCmdSetVolume), name: .cmdSetVolume, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onCmdPausePlaying), name: .cmdPausePlaying, object: nil)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
    }
    
    @objc func onCmdStartPlaying(_ notification:Notification) {
        if let data = notification.userInfo as? [String: String] {
            for (name, value) in data {
                if(name == "AudioFile"){
                    play(fileName: value)
                }
            }
        }
    }
    
    @objc func onCmdPausePlaying(_ notification:Notification) {
       if let data = notification.userInfo as? [String: Bool] {
            for (name, value) in data {
                if(name == "pause"){
                    for (audioPlayer) in audioPlayers {
                        pause(fileName: audioPlayer.key, pausePlaying: value)
                    }
                }
            }
        }
    }
    
    @objc func onCmdStopPlaying(_ notification:Notification) {
        if let data = notification.userInfo as? [String: String] {
            for (name, value) in data {
                if(name == "AudioFile"){
                    stop(fileName: value)
                }
            }
        }
    }
    
    @objc func onCmdSetVolume(_ notification:Notification) {
        if let data = notification.userInfo as? [String: Float] {
            for (name, value) in data {
                    setVolume(fileName: name, volume: value)
            }
        }
    }

    func play(fileName file: String) {
        if let audioPlayer = audioPlayers[file] {
            audioPlayer.stop()
        }

        if let soundFile = Bundle.main.path(forResource: file, ofType: "mp3") {
            do {
                audioPlayers[file] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundFile))
            }
            catch {
                print(error)
            }
            
            audioPlayers[file]?.numberOfLoops = -1
            audioPlayers[file]?.play()
        }
    }
    
    func pause(fileName file: String, pausePlaying pause: Bool){
        if let audioPlayer = audioPlayers[file] {
            if pause {
                audioPlayer.pause()
            }
            else {
                audioPlayer.play()
            }
        }
    }
    
    func stop(fileName file: String) {
        if let audioPlayer = audioPlayers[file] {
            audioPlayer.stop()
            audioPlayers.removeValue(forKey: file)
        }
    }

    func setVolume(fileName file: String, volume: Float) {
        if let audioPlayer = audioPlayers[file] {
            audioPlayer.volume = volume
        }
    }
}


