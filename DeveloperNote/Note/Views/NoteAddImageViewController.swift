//
//  NoteAddImageViewController.swift
//  DeveloperNote
//
//  Created by jsj on 2020/07/20.
//  Copyright © 2020 Tomatoma. All rights reserved.
//

import UIKit

protocol NoteAddImageDelegate: class {
    func didDoneInputImage(_ image: UIImage)
}


class NoteAddImageViewController: UIViewController {
    weak var delegate: NoteAddImageDelegate?
    var noteImages: [UIImage] = []
    private let picker = UIImagePickerController()
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "note_item_image_title".localized()
        doneButton.title = "button_done".localized()
        closeButton.title = "button_close".localized()
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 20 // 아래 간격
            layout.minimumInteritemSpacing = 0
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 10, left: 14, bottom: 0, right: 14)
            collectionView.collectionViewLayout = layout
        }
    }
    
    
    @IBAction func touchedAddButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker.sourceType = .photoLibrary
            picker.allowsEditing = false
            present(picker, animated: false, completion: nil)
          }
    }
    
    
    @IBAction func touchedCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchedDoneButton(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
}


// MARK:- ImagePicker delegate
extension NoteAddImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let selectedImage = info[.originalImage] as? UIImage {
//            image$.accept(selectedImage)
            noteImages.append(selectedImage)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}


// MARK:- collection view delegate & datasource
extension NoteAddImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noteImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addImageCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }

}
