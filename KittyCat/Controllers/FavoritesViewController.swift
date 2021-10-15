//
//  FavoritesViewController.swift
//  KittyCat
//
//  Created by Антон Усов on 13.10.2021.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    private var cats: [Cat] = []
    
    private var collectionView: UICollectionView!
    
    private let realmManager = RealmManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Избранное"
        view.backgroundColor = .black
        
        cats = realmManager.obtainCats()
        
        collectionViewConfig()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func collectionViewConfig() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: view.frame.size.width/2-5, height: view.frame.size.width/2+50)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: MainCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        self.collectionView = collectionView
        self.collectionView.showsVerticalScrollIndicator = true
        self.collectionView.indicatorStyle = .white
    }
    
}


extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cats.count
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
        vc.arrivedFrom = .favoritesVC
        
        vc.completion = { [weak self] in
            self?.cats = self?.realmManager.obtainCats() ?? []
            self?.collectionView.reloadData()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
