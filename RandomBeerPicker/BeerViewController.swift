//
//  BeerViewController.swift
//  RandomBeerPicker
//
//  Created by 강민혜 on 8/1/22.
//

import UIKit

import SwiftyJSON
import Alamofire
import Kingfisher

class BeerViewController: UIViewController {
    
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var beerNameLabel: UILabel!
    @IBOutlet weak var beerDescriptionLabel: UILabel!
    
    @IBOutlet weak var randomButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()   
        requestLotto()
    }
    
    // MARK: - 데이터 통신
    func requestLotto() {
        
        let url = "https://api.punkapi.com/v2/beers/random"
        
        AF.request(url,
                   method: .get)
        .validate(statusCode: 200..<400)
        .responseJSON {
            [self] response in
            
            switch response.result {
                
            case .success(let value):
                
                // 통신받아온 데이터를 JSON으로 변형하여 json에 저장
                let json = JSON(value)
                
                // 랜덤픽 맥주이미지 표기
                let imageURL = json[0]["image_url"].stringValue
                let url = URL(string: imageURL)
                beerImageView.kf.setImage(with: url)
                
                // 랜덤픽 맥주이름 표기
                let name = json[0]["name"].stringValue
                beerNameLabel.text = name
                
                // 랜덤픽 맥주설명 표기
                let description = json[0]["description"].stringValue
                beerDescriptionLabel.text = description
                
            case .failure(let error):
                print(error)
            }
        }
    }

    
    @IBAction func randomButtonTapped(_ sender: UIButton) {
        requestLotto()
    }
    
}
