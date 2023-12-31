//
//  CustomTableViewCell.swift
//  iTunes Store Lookup App
//
//  Created by Lion on 30/11/2023.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    var songUrl: URL? 
    var checkStateButton: ((CustomTableViewCell) ->())? //watch the event when the button pushed

    @IBOutlet weak var playButton: UIButton!
 
    @IBAction func playButtonTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()

        Task {
            do {
                try await AudioPlayerManager.shared.downloadAndPlayAudio(urlSong: songUrl)

                await MainActor.run {
                    let buttonImageName = AudioPlayerManager.shared.currentUrl == nil ? "playButton" : "pausedButton"
                    playButton.setImage(UIImage(named: buttonImageName), for: .normal)
                    checkStateButton?(self)
                }
            } catch {
                print("Erreur lors de la lecture: \(error)")
            }
        }
    }
    }
    

