//
//  StationSearchViewController.swift
//  Subway
//
//  Created by Terry on 2022/01/27.
//

import SnapKit
import UIKit
import Alamofire

class StationSearchViewController: UIViewController {
    
    
    //MARK: - Properties
    private var stations:[Station] = []
    private let tableView = UITableView()
    //    private var numberOfCell: Int = 0
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItems()
        setTableViewLayout()
        
        
    }
    
    //MARK: - Function
    private func setNavigationItems(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "지하철 도착 정보"
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "지하철 역을 입력해 주세요."
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        
    }
    
    private func setTableViewLayout(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    private func reqeustStationName(from stationName: String){
        let urlString = "http://openapi.seoul.go.kr:8088/sample/json/SearchInfoBySubwayNameService/1/5/\(stationName)"
        
        AF
            .request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" )
            .responseDecodable(of: StationResponseModel.self) {[weak self] response in
                guard let self = self,
                      case .success(let data) = response.result else { return }
                
                self.stations = data.stations
                self.tableView.reloadData()
            }
            .resume()
    }
}

//MARK: -UITableViewDataSource
extension StationSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let station = stations[indexPath.row]
        cell.textLabel?.text = "\(station.stationName)"
        cell.detailTextLabel?.text = "\(station.lineNumber)"
        return cell
    }
}

//MARK: -UITableViewDelegate
extension StationSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let station = stations[indexPath.row]
        let VC = StationDetailViewController(station: station)
        navigationController?.pushViewController(VC, animated: true)
        
    }
}

//MARK: -UISearchBarDelegate
extension StationSearchViewController: UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //        numberOfCell = 10
        tableView.reloadData()
        tableView.isHidden = false
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //        numberOfCell = 0
        tableView.isHidden = true
        stations = [] //텍스트 입력이 끝났을 경우 지하철 정보 초기화
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reqeustStationName(from: searchText)
    }
}
