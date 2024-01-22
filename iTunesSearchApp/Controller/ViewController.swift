//
//  ViewController.swift
//  iTunes Store Lookup App
//
//  Created by Lion on 30/11/2023.
//

import UIKit

class ViewController: UIViewController {
    var searchBar: UISearchBar!
    private var loadingView: LoadView!
    @IBOutlet weak var resultTableView: UITableView!
    var trackData = [Track]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        resultTableView.backgroundColor = .black
        resultTableView.delegate = self
        resultTableView.dataSource = self
        setupLoadView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        searchBar.endEditing(true)
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    private func setupLoadView(){
        loadingView = LoadView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        loadingView.isHidden = true
    }
    
    func launchLoadView(){
        self.loadingView.isHidden = false
        self.loadingView.startLoading()
    }
    
    private func setupSearchBar(){
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search Artist"
        searchBar.searchTextField.textColor = .white
        searchBar.backgroundImage = UIImage()
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}
         
  
extension ViewController: UISearchBarDelegate {  // Extension to handle SearchTab behaviour
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        searchBar.endEditing(true)
        
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        launchLoadView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in   //CountDown to fetch result correctly
            guard let self = self else { return }
            
            Task {
                do {
                    guard let results = try await SearchApiRequest.shared.makeRequest(query: searchText) else { return }
                    if results.isEmpty {
                        self.showErrorAlert(message: "No result found")

                    }
                    await MainActor.run {
                        self.trackData = results
                        self.resultTableView.reloadData()
                        self.loadingView.stopLoading()
                        self.loadingView.isHidden = true
                    }
                } catch {
                }
            }
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchBar.endEditing(true)
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return trackData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trackInfo = trackData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.artistLabel.text = trackInfo.artistName
        cell.songLabel.text = trackInfo.trackName
        cell.imageViewCell.image = nil
        cell.songUrl = trackInfo.previewUrl
        cell.checkStateButton = { [weak self] tappedCell in
            guard let strongSelf = self else { return }
            //Unselect button if not push
            for cell in strongSelf.resultTableView.visibleCells {
                guard let customCell = cell as? CustomTableViewCell, customCell != tappedCell else { return }
                customCell.playButton.setImage(UIImage(named: "playButton"), for: .normal)
            }
        }

        Task {
            do {
                let image = try await SearchApiRequest().downloadImageArtist(urlImage: trackInfo.artworkUrl60)
                
                await MainActor.run {
                    if tableView.cellForRow(at: indexPath) == cell {
                        
                        cell.imageViewCell.image = image
                        cell.playButton.setImage(UIImage(named: "playButton"), for: .normal)
                    }
                    
                    
                }
                //Handle error
            } catch ApiError.invalidResponse {
                showErrorAlert(message: "Invalid response from server. Please try again later.")
            } catch URLError.notConnectedToInternet, URLError.cannotFindHost, URLError.cannotConnectToHost {
                showErrorAlert(message: "Network error occurred. Please check your connection.")
            } catch  {
                showErrorAlert(message: "An unknown error occurred.")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
