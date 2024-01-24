//
//  SongRepository.swift
//  iTunesSearchApp
//
//  Created by Lion on 23/01/2024.
//

import Foundation
import CoreData
import UIKit

class SongRepository {
    
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack = CoreDataStack.sharedInstance) {
        self.coreDataStack = coreDataStack
    }
    
    func saveSong(image: UIImage?, artistName: String?, title: String?){
        let request: NSFetchRequest<Song> = Song.fetchRequest()
        let predicate = NSPredicate(format: "titleName == %@ AND artistName == %@", title ?? "", artistName ?? "")
        request.predicate = predicate
        
        
        
        do {
            let results =  try CoreDataStack.sharedInstance.viewContext.fetch(request)
            if results.isEmpty {
                let song = Song(context: CoreDataStack.sharedInstance.viewContext)
                let imageData = image?.pngData()
                song.artistName = artistName
                song.image = imageData
                song.titleName = title
                try CoreDataStack.sharedInstance.viewContext.save()
                
            } else {
            // Chanson déjà existante
            print("La chanson existe déjà dans la base de données.")
        }
    } catch {
        print("Erreur lors de la recherche ou de l'enregistrement de la chanson: \(error)")
    }
    
}
    func fetchSong(completion: ([Song]) -> Void) {
        
        let request: NSFetchRequest<Song> = Song.fetchRequest()
        
        do {
            let song = try coreDataStack.viewContext.fetch(request)
            completion(song)
        }
        catch {
            completion([])
            print("Nous n'avons pas pu récupérer les donnée du tableau")
        }
        
    }
    
    func deleteSong(withTitle title: String) {
        
        let request : NSFetchRequest<Song> = Song.fetchRequest()
        request.predicate =  NSPredicate(format: "titleName == %@", title)
        
        do {
            let songsToDelete = try coreDataStack.viewContext.fetch(request)
            for song in songsToDelete {
                       coreDataStack.viewContext.delete(song)
                   }
            try coreDataStack.viewContext.save()
        } catch {
            print("Erreur lors de la suppression de la chanson: \(error)")
        }
    }
    
}
