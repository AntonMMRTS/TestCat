//
//  MainCell.swift
//  KittyCat
//
//  Created by Антон Усов on 12.10.2021.
//

import UIKit


class MainCell: UICollectionViewCell {
    
    static let identifier = "MainCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        autolayoutSetup()
    }
    
    func setupImage(image: Data) {
        imageView.image = UIImage(data: image)
    }
    
    private func config() {
        contentView.addSubview(imageView)
        contentView.backgroundColor = UIColor(red: 36/255, green: 36/255, blue: 38/255, alpha: 1)
        contentView.layer.cornerRadius = 12
        imageView.layer.cornerRadius = 12
    }
    
    private func autolayoutSetup() {
        let offset: CGFloat = 5
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: offset),
            imageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                               constant: offset),
            imageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                constant: -offset),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
    
}
