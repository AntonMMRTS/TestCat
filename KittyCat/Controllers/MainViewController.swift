//
//  ViewController.swift
//  KittyCat
//
//  Created by Антон Усов on 12.10.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    
    private let networkManager = NetworkManager()
    
    private var cats: [Cat] = []
    
    private var pagination = false
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.color = .white
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navControllerConfig()
        
        collectionViewConfig()
        
        favoritesButtonConfig()
        
        spinnerConfig()
        
        getCats()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func getCats() {
        networkManager.getCats { [weak self] newCats in
            self?.cats = newCats
            self?.collectionView.reloadData()
            self?.spinner.stopAnimating()
            self?.pagination = true
        }
    }
    
    private func spinnerConfig() {
        view.addSubview(spinner)
        spinner.center = view.center
        spinner.startAnimating()
    }
    
    private func collectionViewConfig() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: view.frame.size.width/2-5, height: view.frame.size.width/2-5)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: MainCell.identifier)
        
        collectionView.register(CollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: CollectionReusableView.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        self.collectionView = collectionView
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.collectionView.showsVerticalScrollIndicator = true
        self.collectionView.indicatorStyle = .white
    }
    
    private func navControllerConfig() {
        title = "Котики"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func favoritesButtonConfig() {
        let favoritesButton = UIBarButtonItem(title: "Избранное", style: .done,
                                              target: self, action: #selector(showFavorites))
        favoritesButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = favoritesButton
    }
    
    @objc private func showFavorites() {
        let vc = FavoritesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCell.identifier,
                                                      for: indexPath) as! MainCell
        let image = cats[indexPath.item].image
        cell.setupImage(image: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        let cat = cats[indexPath.item]
        vc.cat = cat
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let cell = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CollectionReusableView.identifier,
            for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if cats.count != 0 {
            return CGSize(width: view.frame.size.width, height: 40)
        }
        return CGSize.zero
    }
    
}


extension MainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if position > ((collectionView!.contentSize.height) - 100 - scrollView.frame.size.height) && pagination {
            pagination = false
            networkManager.getCats { [weak self] newCats in
                self?.cats += newCats
                self?.collectionView.reloadData()
                self?.pagination = true
            }
        }
    }
}
