//
//  LikeViewController.swift
//  iTunesSearchApp
//
//  Created by Lion on 22/01/2024.
//

import UIKit

class LikeViewController: UIViewController {
    
    @IBOutlet weak var tableLike: UITableView!
    private let songRepo = SongRepository()
    private var songArray: [Song] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableLike.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          getSong() // Recharger les chansons chaque fois que la vue apparaît
      }
    
    private func getSong() {
        songRepo.fetchSong(completion: { [weak self] song in
            guard let strongSelf = self else {return }
            strongSelf.songArray = song
            DispatchQueue.main.async { // Assurez-vous de recharger la table sur le thread principal
                strongSelf.tableLike.reloadData()
            }
        })
    }
}

extension LikeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let songInfo = songArray[indexPath.row] // Recupère l'index actuelle de notre variable Film
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "likeCell", for: indexPath)  as! LikeViewCell
        cell.artistSaved.text  = songInfo.artistName
        cell.titleSaved.text = songInfo.titleName
        cell.onDelete = { [weak self] title in
            self?.songRepo.deleteSong(withTitle: title)
            self?.getSong()
        }
        cell.imageSaved.image = UIImage(data: songInfo.image!)
        // Pour chaque element du tableau on afffiche l'element du tableau qui l'index qui lui attribuer
        return cell
    }
}
