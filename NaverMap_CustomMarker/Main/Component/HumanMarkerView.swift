//
//  HumanMarkerView.swift
//  NaverMap_CustomMarker
//
//  Created by 도학태 on 2023/04/19.
//

import Foundation
import UIKit
import SnapKit
import Then
import Kingfisher
import UIColor_Hex_Swift

class HumanMarkerView : UIView {
    
    
    var imgSize = 44
    var decorateSize = 10
    
    lazy var imgView = UIImageView(frame: .init(x: 0, y: 0, width: imgSize, height: imgSize)).then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor.clear.cgColor
    }
    
    lazy var decorateView = UIView(frame: .init(x: imgSize / 2 - decorateSize / 2, y: imgSize + 8, width: decorateSize, height: decorateSize)).then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 5
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        _ data : HumanMarker,
        _ completion : @escaping (UIImage?) -> Void) {
        
        /*
         Color 설정
         */
        imgView.layer.borderColor = UIColor(data.decorateColor).cgColor
        decorateView.backgroundColor = UIColor(data.decorateColor)
        
        /*
         Profile Img 설정
         */
        let url = URL(string: data.imgUrl)
        let resource = ImageResource(downloadURL: url!)
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                self.imgView.image = value.image
                let img = self.toImage()
                completion(img)
            case .failure(let e):
                print("HumanMarker Image Render Error : \(e.localizedDescription)")
                completion(nil)
            }
        }
        
    }
    
    private func layout() {
        [
            imgView,
            decorateView,
        ].forEach {
            addSubview($0)
        }
    }
}
