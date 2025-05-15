//
//  InfoViewController.swift
//  WeatherApp
//
//  Created by Rodrigo Jehu Nieves Guzman on 15/05/25.
//

import UIKit

class InfoViewController: UIViewController {
    @IBOutlet weak var ivProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ivProfile.contentMode = .scaleAspectFill
        ivProfile.clipsToBounds = true
        ivProfile.layer.cornerRadius = ivProfile.frame.size.width / 2
    }

    @IBAction func openGithub(_ sender: Any) {
        guard let githubURL = URL(string: "https://github.com/jehux") else { return }
        if UIApplication.shared.canOpenURL(githubURL) {
            UIApplication.shared.open(githubURL, options: [:], completionHandler: nil)
        }
    }

}
