//
//  StorageViewController.swift
//  FireFast_Example
//
//  Created by Behrad Kazemi on 4/5/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import FireFast
class StorageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var urlLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  var imagePicker = UIImagePickerController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @IBAction func pickImage(_ sender: UIButton) {
    self.imageView.image = UIImage(named: "\(sender.tag)")
  }
  @IBAction func upload(_ sender: Any) {
    if let image = imageView.image, let data = UIImagePNGRepresentation(image) {
      _ = FireFast.StorageUseCases(bucketURLPath: nil).upload(data: data, path: "image/test.png") { (info) in
        print("Success", info)
      } progressCompleted: { (progress) in
        
      } onError: { (error) in
        print("Error", error)
      }
    }
  }
}
