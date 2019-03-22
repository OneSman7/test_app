//
//  IconFullscreenViewController.swift
//  TestApp
//
//  Created by Иван Ерасов on 22/03/2019.
//

import UIKit

class IconFullscreenViewController: UIViewController, ConfigurableModuleController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let unwindToSearchSegueIdentifier = "unwindToSearch"
    var url: URL?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let imageUrl = url else { return }
        imageView.loadAndDisplayImage(from: imageUrl)
    }

    override var shouldAutorotate: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    @IBAction func handleTap() {
        performSegue(withIdentifier: unwindToSearchSegueIdentifier, sender: nil)
    }
    
    //MARK: - ConfigurableModuleController
    
    func configureModule(with object: Any) {
        url = object as? URL
    }
}
