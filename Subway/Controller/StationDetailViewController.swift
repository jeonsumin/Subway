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
    
    private let station: Station
    private var realtimeArrivalList: [StationArrivalDatResponseModel.RealTimeArrival] = []
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: view.frame.width - 32.0, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(StationDetaillCollectionViewCell.self , forCellWithReuseIdentifier: "StationDetailViewCell")
        
        collectionView.dataSource = self
        
        collectionView.refreshControl = refreshControl
        return collectionView
        
    }()
    
    init(station: Station){
        self.station = station
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = station.stationName
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        fetchData()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        
    }
    
    //MARK: -Function
    @objc private func fetchData(){

        let stationName = station.stationName
        
        let urlString = "http://swopenapi.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/0/5/\(stationName.replacingOccurrences(of: "역", with: ""))"
        AF
            .request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" )
            .responseDecodable(of: StationArrivalDatResponseModel.self) { [weak self] response in
                self?.refreshControl.endRefreshing()
                
                guard case .success(let data) = response.result else { return }
//                print(data.realtimeArrivalList)
                
                self?.realtimeArrivalList = data.realtimeArrivalList
                self?.collectionView.reloadData()
                
            }.resume()
    }
}

extension StationDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realtimeArrivalList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StationDetailViewCell", for: indexPath) as? StationDetaillCollectionViewCell else { return UICollectionViewCell() }
        cell.uiConfigure(with: realtimeArrivalList[indexPath.row])
        return cell
    }
}

