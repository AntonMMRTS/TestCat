//
//  CollectionReusableView.swift
//  KittyCat
//
//  Created by Антон Усов on 12.10.2021.
//

import UIKit


class CollectionReusableView: UICollectionReusableView {
    
    static let identifier = "CollectionReusableView"
    
    private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.color = .white
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(spinner)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        spinner.frame = CGRect(x: frame.size.width/2-10, y: frame.size.height/2-10, width: 20, height: 20)
        spinner.startAnimating()
    }
}

