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
    
    lazy var imgView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor.clear.cgColor
    }
    
    lazy var decorateView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 5
    }
    
    override var intrinsicContentSize: CGSize {
        let imgSize = 44
        let decorationHeight = 10 + 8
        return CGSize(width: imgSize, height: imgSize + decorationHeight)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()

        /*
         이게 핵심임
         */
        self.frame = .init(x: 0, y: 0, width: 44, height: 64)
        self.layoutIfNeeded()
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
        
        
        imgView.snp.makeConstraints {
            $0.width.height.equalTo(44)
            $0.top.leading.trailing.equalToSuperview()
        }

        decorateView.snp.makeConstraints {
            $0.width.height.equalTo(10)
            $0.top.equalTo(imgView.snp.bottom).offset(8)
            $0.centerX.equalTo(imgView)
        }
    }
}
