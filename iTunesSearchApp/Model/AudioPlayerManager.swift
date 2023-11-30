//
//  AudioPlayerManager.swift
//  iTunes Store Lookup App
//
//  Created by Lion on 30/11/2023.
//

import Foundation
import AVFoundation

// This class aims to play music
class AudioPlayerManager {
    static let shared = AudioPlayerManager()
    private var audioPlayer: AVAudioPlayer?
     var currentUrl: URL?

    func downloadAndPlayAudio(urlSong: URL?) async throws {
        guard let urlSong = urlSong else { return }

        if currentUrl == urlSong && audioPlayer?.isPlaying == true {
            audioPlayer?.stop()
            currentUrl = nil
            return
        }

        let (data, response) = try await URLSession.shared.data(from: urlSong)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        do {
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            currentUrl = urlSong 
        } catch {
            throw error
        }
    }
}
