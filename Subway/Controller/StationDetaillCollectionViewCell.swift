//
//  StationDetaillCollectionViewCell.swift
//  Subway
//
//  Created by Terry on 2022/01/28.
//

import SnapKit
import UIKit

class StationDetaillCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    private let lineLabel = UILabel()
    private let remainTimeLabel = UILabel()
    
    
    func uiConfigure(){
        
        backgroundColor = .systemBackground
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 10
        
        
        
        lineLabel.font = .systemFont(ofSize: 15, weight: .bold)
        remainTimeLabel.font = .systemFont(ofSize: 15, weight: .medium)
        
        [lineLabel,remainTimeLabel].forEach{
            addSubview($0)
        }
        
        lineLabel.text = "한양대 방면"
        lineLabel.snp.makeConstraints{
            $0.leading.top.equalToSuperview().inset(16)
        }
        remainTimeLabel.text = "뚝섬 도착"
        remainTimeLabel.snp.makeConstraints{
            $0.leading.equalTo(lineLabel)
            $0.top.equalTo(lineLabel.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
    }
}
