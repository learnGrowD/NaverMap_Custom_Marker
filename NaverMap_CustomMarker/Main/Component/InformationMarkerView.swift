//
//  InformationMarkerView.swift
//  NaverMap_CustomMarker
//
//  Created by 도학태 on 2023/04/19.
//

import Foundation
import UIKit
import Kingfisher

class InformationMarkerView : UIView {
    
    let imgView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
    }
    
    let informationLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
    }
    
    override var intrinsicContentSize: CGSize {
        let labelSize = informationLabel.intrinsicContentSize
        let height = max(labelSize.height, 24) // minimum height of 24 for the image view
        return CGSize(width: labelSize.width + 16 + 24, height: height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        _ data : InformationMarker,
        _ completin : @escaping (UIImage?) -> Void) {
            /*
             Color 설정
             */
            informationLabel.text = "\(data.count)"
            informationLabel.textColor = UIColor(data.docorateColor)
            self.layer.borderColor = UIColor(data.docorateColor).cgColor
            
            /*
             img 설정
             */
            let url = URL(string: data.imgUrl)
            let resource = ImageResource(downloadURL: url!)
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.imgView.image = value.image
                    self.layoutIfNeeded() // update layout after setting image
                    
                    let img = self.toImage()
                    completin(img)
                case .failure(let e):
                    print("Information Image Render Error : \(e.localizedDescription)")
                    completin(nil)
                }
            }
            
            /*
             Size 결정 후...
             이게 핵심
             */
            self.frame = CGRect(origin: .zero, size: intrinsicContentSize)
        }
    
    private func attribute() {
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func layout() {
        [
            imgView,
            informationLabel,
        ].forEach {
            addSubview($0)
        }
        
        imgView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        informationLabel.snp.makeConstraints {
            $0.leading.equalTo(imgView.snp.trailing).offset(8)
            $0.centerY.equalTo(imgView)
        }
    }
}
