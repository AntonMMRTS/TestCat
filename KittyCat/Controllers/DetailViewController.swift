//
//  DetailViewController.swift
//  KittyCat
//
//  Created by Антон Усов on 13.10.2021.
//

import UIKit


enum ArrivedFrom {
    case mainVC
    case favoritesVC
}

class DetailViewController: UIViewController, UIImagePickerControllerDelegate {
    
    var arrivedFrom: ArrivedFrom = .mainVC
    
    var cat = Cat()
    
    var completion: (() -> Void)?
    
    private let realmManager = RealmManager()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let downloadPhoto: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.contentHorizontalAlignment = .center
        button.setTitle("Скачать фото", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addOrDeleteFavorite: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.contentHorizontalAlignment = .center
        button.setTitle("Добавить в избранное", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonsActions()
        
        config()
        
        imageView.image = UIImage(data: cat.image)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        autolayout()
    }
    
    private func config() {
        title = "Котик"
        
        view.backgroundColor = .black
        view.addSubview(imageView)
        view.addSubview(downloadPhoto)
        view.addSubview(addOrDeleteFavorite)
    }
    
    private func autolayout() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.size.width),
            
            downloadPhoto.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            downloadPhoto.widthAnchor.constraint(equalToConstant: 200),
            downloadPhoto.heightAnchor.constraint(equalToConstant: 50),
            downloadPhoto.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            
            addOrDeleteFavorite.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            addOrDeleteFavorite.widthAnchor.constraint(equalToConstant: 300),
            addOrDeleteFavorite.heightAnchor.constraint(equalToConstant: 50),
            addOrDeleteFavorite.topAnchor.constraint(equalTo: downloadPhoto.bottomAnchor)
        ])
    }
    
    private func buttonsActions() {
        downloadPhoto.addTarget(self, action: #selector(savePhoto), for: .touchUpInside)
        
        if arrivedFrom == .favoritesVC {
            addOrDeleteFavorite.setTitle("Удалить из избранного", for: .normal)
            addOrDeleteFavorite.addTarget(self, action: #selector(deleteFromFavorites), for: .touchUpInside)
        } else {
            addOrDeleteFavorite.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        }
    }
    
    @objc private func savePhoto() {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, nil, nil)
    }
    
    @objc private func addToFavorites() {
        realmManager.addNewCat(cat: cat)
    }
    
    @objc private func deleteFromFavorites() {
        realmManager.deleteCat(cat: cat)
        completion?()
        navigationController?.popViewController(animated: true)
    }

}



