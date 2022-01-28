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
    private let tableView = UITableView()
    private var numberOfCell: Int = 0
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItems()
        setTableViewLayout()
        
        reqeustStationName()
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
    
    private func reqeustStationName(){
        let urlString = "http://openapi.seoul.go.kr:8088/sample/json/SearchInfoBySubwayNameService/1/5/서울역"

        AF
            .request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" )
            .responseDecodable(of: StationResponseModel.self) { response in
                guard case .success(let data) = response.result else { return }
                
                print(data.stations)
            }
            .resume()
    }
}

//MARK: -UITableViewDataSource
extension StationSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}

//MARK: -UITableViewDelegate
extension StationSearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = StationDetailViewController()
        navigationController?.pushViewController(VC, animated: true)
        
    }
}

//MARK: -UISearchBarDelegate
extension StationSearchViewController: UISearchBarDelegate{

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        numberOfCell = 10
        tableView.reloadData()
        tableView.isHidden = false
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        numberOfCell = 0
        tableView.isHidden = true
    }
}
