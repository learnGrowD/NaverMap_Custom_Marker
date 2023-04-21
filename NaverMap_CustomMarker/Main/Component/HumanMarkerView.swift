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
         Image 크기와 DecorateView의 크기가 모두 정해져 있기때문에 정적으로
         View의 크기를 정한다.
         */
        self.frame = .init(x: 0, y: 0, width: 44, height: 64)
        /*
         현재 CustomView의 View 계층 구조에서 필요한 모든 레이아웃의 계산을 강제로 수행
         이 코드를 호출 하기 때문에 AutoLayout을 통한 배치를 완료 할 수 있다.
         */
        self.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    /*
     CustomView 설정하는 부분
     */
    func configure(
        _ data : HumanMarker,
        _ completion : @escaping (UIImage?) -> Void) {
            /*
             서버에서 이미지를 가져와 처리하는 부분
             */
            let url = URL(string: data.imgUrl)
            let resource = ImageResource(downloadURL: url!)
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let value):
                    /*
                     Color 설정
                     */
                    self.imgView.layer.borderColor = UIColor(data.decorateColor).cgColor
                    self.decorateView.backgroundColor = UIColor(data.decorateColor)
                    
                    self.imgView.image = value.image
                    /*
                     layoutIfNeeded을 통해
                     AutoLayout을 통한 View 배치를 완료했다.
                     완료한 시점은 이전이니 Snapshot을 찍는다.
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
