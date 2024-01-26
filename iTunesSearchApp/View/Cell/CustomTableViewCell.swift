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
    var callBack: ((Bool) ->Void)?
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    var songRepo = SongRepository()
    var tapped = false
    

    
    @IBAction func likebuttonTapped(_ sender: UIButton) {
        likeButton.isSelected = !likeButton.isSelected
        callBack?(likeButton.isSelected)
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
        Task {
            do {
                try await AudioPlayerManager.shared.downloadAndPlayAudio(urlSong: songUrl)
                
                tapped = !tapped
                checkStateButton?(self)
                
                // Mettre à jour la propriété isPlaying de trackInfo en fonction de l'état du lecteur audio
                
            } catch {
                print("Erreur lors de la lecture: \(error)")
            }
        }
    }
}

