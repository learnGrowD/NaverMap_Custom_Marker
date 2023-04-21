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
    
    lazy var imgView = UIImageView(frame: .init(x: 0, y: 0, width: 44, height: 44)).then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor.clear.cgColor
    }
    
    lazy var decorateView = UIView(frame: .init(x: 44 / 2 - 10 / 2, y: 44 + 8, width: 10, height: 10)).then {
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     HumanMarkerView 설정
     */
    func configure(
        _ data : HumanMarker,
        _ completion : @escaping (UIImage?) -> Void) {
            let url = URL(string: data.imgUrl)
            let resource = ImageResource(downloadURL: url!)
            
            /*
            Color 설정
            */
            self.imgView.layer.borderColor = UIColor(data.decorateColor).cgColor
            self.decorateView.backgroundColor = UIColor(data.decorateColor)
            
            /*
             서버에서 가져오는 Image를 처리하는 부분
             */
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                
                switch result {
                case .success(let value):
                    self.imgView.image = value.image
                    /*
                     CustomMarkerView에 대해서 Snapshot을 하는 부분
                     */
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
