//
//  StationDetailViewController.swift
//  Subway
//
//  Created by Terry on 2022/01/28.
//

import SnapKit
import UIKit
import Alamofire

class StationDetailViewController: UIViewController {

    //MARK: -Properties
    private let refreshControl = UIRefreshControl()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: view.frame.width - 32.0, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(StationDetaillCollectionViewCell.self , forCellWithReuseIdentifier: "StationDetailViewCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.refreshControl = refreshControl
        return collectionView
        
    }()
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "왕십리"
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        fetchData()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        
    }
    
    //MARK: -Function
    @objc private func fetchData(){

        let stationName = "서울역"
        
        let urlString = "http://swopenapi.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/0/5/\(stationName.replacingOccurrences(of: "역", with: ""))"
        AF
            .request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" )
            .responseDecodable(of: StationArrivalDatResponseModel.self) { [weak self] response in
                self?.refreshControl.endRefreshing()
                
                guard case .success(let data) = response.result else { return }
                print(data.realtimeArrivalList)
                
            }.resume()
    }
}

extension StationDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StationDetailViewCell", for: indexPath) as? StationDetaillCollectionViewCell else { return UICollectionViewCell() }
        cell.uiConfigure()
        return cell
    }
    
    
}

extension StationDetailViewController : UICollectionViewDelegateFlowLayout{
    
}
