//
//  DetailViewController.swift
//  challenge4
//
//  Created by Ivan Pavic on 3.2.22..
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage : String?
    var imageCaption: String?
    let placeHolder = "Click to add captions..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = imageCaption
        navigationItem.largeTitleDisplayMode = .never
        if imageCaption == placeHolder {
            title = ""
        }
        if let imageToLoad = selectedImage {
            let path = getDocumentsDirectory().appendingPathComponent(imageToLoad)
            imageView.image = UIImage(contentsOfFile: path.path)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

}
