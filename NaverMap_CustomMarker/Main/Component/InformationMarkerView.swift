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
    
    let imgView = UIImageView(frame: .init(x: 0, y: 0, width: 24, height: 24)).then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
    }
    
    let informationLabel = UILabel(frame: .init(x: 24 + 4, y: 0 , width: 24, height: 24)).then {
        $0.font = .systemFont(ofSize: 16)
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
                    let img = self.toImage()
                    completin(img)
                case .failure(let e):
                    print("Information Image Render Error : \(e.localizedDescription)")
                    completin(nil)
                }
            }
        }
    
    func attribute() {
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    func layout() {
        [
            imgView,
            informationLabel,
        ].forEach {
            addSubview($0)
        }
    }

}
