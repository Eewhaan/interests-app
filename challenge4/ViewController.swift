//
//  ViewController.swift
//  challenge4
//
//  Created by Ivan Pavic on 3.2.22..
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var items = [Items]()
    let placeholder = "Click to add captions..."

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My interests"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        let defaults = UserDefaults.standard
        
        if let savedItems = defaults.object(forKey: "items") as? Data {
            if let decodedItems = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedItems) as? [Items] {
                items = decodedItems
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        
        
    }
    
    @objc func addNewItem () {
        let picker = UIImagePickerController()
        let cameraPicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraPicker.sourceType = .camera
            cameraPicker.allowsEditing = true
            cameraPicker.delegate = self
            present (cameraPicker, animated: true)
        } else {
            picker.allowsEditing = true
            picker.delegate = self
            present (picker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let Item = Items(imageName: imageName, caption: placeholder)
        items.append(Item)
        save()
        tableView.reloadData()
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Image", for: indexPath) as? ItemsCell else {
            fatalError("Unable to load ItemsCell")
        }
        
        let item = items[indexPath.row]
        
        let path = getDocumentsDirectory().appendingPathComponent(item.imageName)
        cell.itemImage?.image = UIImage(contentsOfFile: path.path)
        cell.itemImage?.layer.borderColor = UIColor(white: 0, alpha: 0.4).cgColor
        cell.itemImage?.layer.borderWidth = 1
        cell.itemImage?.layer.cornerRadius = 7
        
        cell.caption.text = item.caption
        if cell.caption.text == placeholder {
            cell.caption.textColor = UIColor(white: 0, alpha: 0.6)
        } else {
            cell.caption.textColor = UIColor(white: 0, alpha: 1)
        }
        
        cell.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 5
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "Choose action", message: "Do you want to change captions or view image?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "View image", style: .default) {
            [weak self] _ in
            if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
                let item = self?.items[indexPath.row]
                guard let image = item?.imageName else {return}
                vc.selectedImage = image
                vc.imageCaption = item?.caption ?? ""
                self?.navigationController?.pushViewController(vc, animated: true)
                     }
        })
        ac.addAction(UIAlertAction(title: "Add caption", style: .default) {
            [weak self] _ in
            let ac = UIAlertController(title: "Add caption", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Ok", style: .default) {
                [weak self] _ in
                let item = self?.items[indexPath.row]
                guard let newCaption = ac.textFields?[0].text else {return}
                item?.caption = newCaption
                if newCaption == "" {
                    item?.caption = self?.placeholder ?? ""
                }
                self?.tableView.reloadData()
                self?.save()
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
            self?.present (ac, animated: true)
            self?.save()
            self?.tableView.reloadData()
        })
        present(ac, animated: true)
    }
    
    func save() {
        if let savedItems = try? NSKeyedArchiver.archivedData(withRootObject: items, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedItems, forKey: "items")
        }
    }


}

