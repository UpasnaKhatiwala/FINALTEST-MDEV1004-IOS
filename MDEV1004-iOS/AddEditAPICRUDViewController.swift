//
//  AddEditAPICRUDViewController.swift
//  MDEV1004-iOS
//
//  Created by Upasna Khatiwala on 2023-08-18.
//

import UIKit

class AddEditAPICRUDViewController: UIViewController
{
    // UI References
    @IBOutlet weak var AddEditTitleLabel: UILabel!
    @IBOutlet weak var UpdateButton: UIButton!
    
    // Movie Fields
    @IBOutlet weak var IDTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var platformsTextField: UITextField!
    @IBOutlet weak var genresTextField: UITextField!
    @IBOutlet weak var developersTextField: UITextField!
    @IBOutlet weak var designersTextField: UITextField!
    @IBOutlet weak var publishersTextField: UITextField!
    @IBOutlet weak var releaseDateTextField: UITextField!
    @IBOutlet weak var ratingTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var artistsTextField: UITextField!
    @IBOutlet weak var modesTextField: UITextField!
    
    @IBOutlet weak var imageURLTextField: UITextField!
    
    
    
    
    
    
    var game: Games?
    var crudViewController: APICRUDViewController? // Updated from MovieViewController
    var gameUpdateCallback: (() -> Void)? // Updated from MovieViewController
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let game = game
        {
            // Editing existing movie
            IDTextField.text = "\(game.ID)"
            titleTextField.text = game.title
            platformsTextField.text = game.platforms.joined(separator: ", ")
            genresTextField.text = game.genres.joined(separator: ", ")
            developersTextField.text = game.developers
            designersTextField.text = game.designers
            publishersTextField.text = game.publishers
            releaseDateTextField.text = game.releaseDate
            ratingTextField.text = "\(game.rating)"
            descriptionTextView.text = game.description
            imageURLTextField.text = game.imageURL
            artistsTextField.text = game.artists
            modesTextField.text = game.modes.joined(separator: ", ")
            
            AddEditTitleLabel.text = "Edit Game"
            UpdateButton.setTitle("Update", for: .normal)
        }
        else
        {
            AddEditTitleLabel.text = "Add Game"
            UpdateButton.setTitle("Add", for: .normal)
        }
    }
    
    @IBAction func CancelButton_Pressed(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func UpdateButton_Pressed(_ sender: UIButton)
    {
        // Retrieve AuthToken
        guard let authToken = UserDefaults.standard.string(forKey: "AuthToken") else
        {
            print("AuthToken not available.")
            return
        }
        
        // Configure Request
        let urlString: String
        let requestType: String
        
        if let game = game {
            requestType = "PUT"
            urlString = "https://mdev1004-m2023-livesite-18la.onrender.com/api/update/\(game._id)"
        } else {
            requestType = "POST"
            urlString = "https://mdev1004-m2023-livesite-18la.onrender.com/api/add"
        }
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return
        }
        
        // Explicitly mention the types of the data
        let id: String = game?._id ?? UUID().uuidString
        let ID: Int32 = Int32(IDTextField.text ?? "") ?? 0
        let title: String = titleTextField.text ?? ""
        let platforms: String = platformsTextField.text ?? ""
        let genres: String = genresTextField.text ?? ""
        let developers: String = developersTextField.text ?? ""
        let designers: String = designersTextField.text ?? ""
        let publishers: String = publishersTextField.text ?? ""
        let releaseDate: String = releaseDateTextField.text ?? ""
        let artists: String = artistsTextField.text ?? ""
        let modes: String = modesTextField.text ?? ""
        let description: String = descriptionTextView.text ?? ""
        let imageURL: String = imageURLTextField.text ?? ""
        let rating: Double = Double(ratingTextField.text ?? "") ?? 0

        // Create the movie with the parsed data
        let game = Games(
            _id: id,
            ID: ID,
            title: title,
            platforms: [platforms],
            genres: [genres], // Wrap the value in an array
            developers: developers, // Wrap the value in an array
            designers: designers, // Wrap the value in an array
            publishers: publishers, // Wrap the value in an array
            description: description,
            imageURL: imageURL,
            modes: [modes],
            artists: artists,
            rating: rating,
            releaseDate: releaseDate
        )
        
        var request = URLRequest(url: url)
        request.httpMethod = requestType
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Add the AuthToken to the request headers
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        // Request
        do {
            request.httpBody = try JSONEncoder().encode(game)
        } catch {
            print("Failed to encode game: \(error)")
            return
        }
        
        // Response
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error
            {
                print("Failed to send request: \(error)")
                return
            }
            
            DispatchQueue.main.async
            {
                self?.dismiss(animated: true)
                {
                    self?.gameUpdateCallback?()
                }
            }
        }
        
        task.resume()
    }
}
