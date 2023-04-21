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
    
    let informationLabel = UILabel(frame: .init(x: 24 + 8, y: 24 / 2 - 16 / 2, width: 16, height: 16)).then {
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
    
    /*
     InformationMarkerView 설정
     */
    func configure(
        _ data : InformationMarker,
        _ completin : @escaping (UIImage?) -> Void) {
            /*
             Color 설정
             */
            self.informationLabel.text = "\(data.count)"
            self.informationLabel.textColor = UIColor(data.docorateColor)
            self.layer.borderColor = UIColor(data.docorateColor).cgColor
            
            /*
             서버에서 가져오는 Image를 처리하는 부분
             */
            let url = URL(string: data.imgUrl)
            let resource = ImageResource(downloadURL: url!)
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.imgView.image = value.image
                    /*
                     CustomMarkerView에 대해서 Snapshot을 하는 부분
                     */
                    let img = self.toImage()
                    
                    completin(img)
                case .failure(let e):
                    print("Information Image Render Error : \(e.localizedDescription)")
                    completin(nil)
                }
            }
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
    }
}
