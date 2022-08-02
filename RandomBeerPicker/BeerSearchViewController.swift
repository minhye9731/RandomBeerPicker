//
//  BeerSearchViewController.swift
//  RandomBeerPicker
//
//  Created by 강민혜 on 8/3/22.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class BeerSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    var list: [BeerModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchBar.delegate = self
        
        searchTableView.register(UINib(nibName: BeerSearchTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: BeerSearchTableViewCell.reuseIdentifier)
        
        // 데이터 연동함수
        requestBeerData()
    }
    
    func configureView() {
        searchTableView.backgroundColor = .clear
        searchTableView.separatorColor = .clear
        searchTableView.rowHeight = 168
    }

    // MARK: - 맥주 API 연결
    func requestBeerData() {
        
        list.removeAll()
        
        // 25개니까 하나하나 꺼내서 배열에 추가해줘야지
        
        let url = "https://api.punkapi.com/v2/beers"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                // 맥주정보 25개 모두 list 배열에 담기
//                for i in 0...4 { -> 이거는 필요없었다!

                for beer in json.arrayValue {
                        
                        let imageUrl = beer["image_url"].stringValue
                        let beerName = beer["name"].stringValue
                        let firstBrewedDt = beer["first_brewed"].stringValue
                        let alchol = beer["abv"].intValue
                        let description = beer["description"].stringValue
                        
                        let data = BeerModel(imageUrl: imageUrl, beerName: beerName, firstBrewed: firstBrewedDt, abv: alchol, description: description)
                        
                        self.list.append(data)
                    }

                // 데이터 갱신!
                self.searchTableView.reloadData()
                
                print(self.list)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }

}

// MARK: - tableview 함수
extension BeerSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BeerSearchTableViewCell.reuseIdentifier, for: indexPath) as? BeerSearchTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .clear
        
        // 기타 cell 데이터와 레이아웃 설정 -> cell 컨뷰에 정리
        let imgURL = URL(string: list[indexPath.row].imageUrl)
        cell.beerImageView.kf.setImage(with: imgURL)
        
        cell.beerNameLabel.text = list[indexPath.row].beerName
        cell.beerNameLabel.font = .boldSystemFont(ofSize: 18)
        
        cell.firstBrewedLabel.text = list[indexPath.row].firstBrewed
        cell.firstBrewedLabel.font = .systemFont(ofSize: 15)
        cell.firstBrewedLabel.textColor = .darkGray
        
        cell.abvLabel.text = "\(list[indexPath.row].abv) %"
        cell.abvLabel.font = .systemFont(ofSize: 15)
        cell.abvLabel.textColor = .darkGray
        
        cell.descriptionLabel.text = list[indexPath.row].description
        cell.descriptionLabel.font = .systemFont(ofSize: 13)
        cell.descriptionLabel.textColor = .lightGray
        
        return cell
    }
    
}

// MARK: - searchbar 함수
extension BeerSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 맥주 이름 검색시 검색된 리스트가 나타나도록
    }
}
