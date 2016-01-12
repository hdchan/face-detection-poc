//
//  ViewController.swift
//  Camera PoC
//
//  Created by Henry Chan on 12/9/15.
//  Copyright © 2015 Henry Chan. All rights reserved.
//

import UIKit
import ImageIO

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var imageView: FacePhoto!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePhotoButtonTapped(sender: AnyObject) {
        openCamera()
    }
    
    @IBAction func selectPhotoButtonTapped(sender: AnyObject) {
        openPhotoLibrary();
    }
    
    func openCamera () {
        imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
//        imageView = FacePhoto()
        imageView.image = image
        self.tableView.reloadData()
        
    }
    
    func openPhotoLibrary() {
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self;
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if imageView.faceFeatures == nil {
            return 0
        }
        else {
            return (imageView.faceFeatures?.count)!
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "facesCell")
        cell.textLabel!.text="row#\(indexPath.row)"
        cell.detailTextLabel!.text="subtitle#\(indexPath.row)"
        let faceFeature = imageView?.faceFeatures![indexPath.row] as! CIFaceFeature
        cell.imageView?.image = imageView?.getFaceImage(faceFeature)
        
        return cell
    }

}