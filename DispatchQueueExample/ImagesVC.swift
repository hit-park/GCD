//
//  ImagesVC.swift
//  DispatchQueueExample
//
//  Created by heetae.park on 2021/07/29.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    let iv: UIImageView = {
        let _iv: UIImageView = .init()
        _iv.contentMode = .scaleAspectFill
        _iv.clipsToBounds = true
        _iv.translatesAutoresizingMaskIntoConstraints = false
        _iv.backgroundColor = .blue
        return _iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iv)
        iv.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        iv.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        iv.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        iv.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ImagesVC: UIViewController {
    
    private let identifier  : String = "ImageCell"
    private var urls        : [URL] {
        guard
            let url = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
            let contents = try? Data(contentsOf: url),
            let serial = try? PropertyListSerialization.propertyList(from: contents, format: nil),
            let serialUrls = serial as? [String]
        else { return [] }
        return serialUrls.compactMap { URL(string: $0) }
    }
    
    private let cv: UICollectionView = {
        let fl      : UICollectionViewFlowLayout = .init()
        let spacing : CGFloat = 1
        let width   : CGFloat = (UIScreen.main.bounds.width / 3) - (spacing * 2)
        fl.minimumInteritemSpacing  = spacing
        fl.minimumLineSpacing       = spacing
        fl.itemSize                 = .init(width: width, height: width)
        
        let _cv: UICollectionView = .init(frame: .zero, collectionViewLayout: fl)
        _cv.translatesAutoresizingMaskIntoConstraints = false
        _cv.showsHorizontalScrollIndicator            = false
        _cv.backgroundColor                           = .white
        return _cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(cv)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        cv.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        cv.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        cv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        cv.register(ImageCell.self, forCellWithReuseIdentifier: identifier)
        cv.delegate     = self
        cv.dataSource   = self
    }
}

extension ImagesVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            if let data = try? Data(contentsOf: self.urls[indexPath.item]) {
                DispatchQueue.main.async {
                    cell.iv.image = UIImage(data: data)
                }
            }
        }
        
        return cell
    }
    
    
}
