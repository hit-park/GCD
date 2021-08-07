//
//  ViewController.swift
//  DispatchQueueExample
//
//  Created by heetae.park on 2021/07/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var iv1: UIImageView!
    @IBOutlet weak var iv2: UIImageView!
    @IBOutlet weak var iv3: UIImageView!
    @IBOutlet weak var btnDownload: UIButton!
    
    private let imgUrl1: String = "https://media.triple.guide/triple-cms/c_limit,f_auto,h_2048,w_2048/cd94b8df-c7a1-4efc-82a8-9df855e51731.jpeg"
    private let imgUrl2: String = "https://media.triple.guide/triple-cms/c_limit,f_auto,h_2048,w_2048/d292f47c-609f-477c-a24a-5d4bde07ccdf.jpeg"
    private let imgUrl3: String = "https://media.triple.guide/triple-cms/c_limit,f_auto,h_2048,w_2048/b4dca112-9580-48c5-b865-1528ca99d14f.jpeg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private enum ImageType {
        case first
        case second
        case third
    }
    private func imageUrl(type: ImageType) -> URL? {
        switch type {
        case .first : return URL(string: imgUrl1)
        case .second: return URL(string: imgUrl2)
        case .third : return URL(string: imgUrl3)
        }
    }
    
    private func downloadImage(type: ImageType) {
        if let url = imageUrl(type: type) {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async { [weak self] in
                    switch type {
                    case .first : self?.iv1.image = UIImage(data: data)
                    case .second: self?.iv2.image = UIImage(data: data)
                    case .third : self?.iv3.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    @IBAction func clickDownload(_ sender: Any) {
        DispatchQueue.global().async { [weak self] in
            self?.downloadImage(type: .first)
            self?.downloadImage(type: .second)
            self?.downloadImage(type: .third)
        }
    }
    
}

