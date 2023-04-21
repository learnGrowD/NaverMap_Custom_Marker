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
    
    /*
     컨텐츠의 동적 사이즈를 결정하는데 주요한 역할
     */
    override var intrinsicContentSize: CGSize {
        let labelSize = informationLabel.intrinsicContentSize
        let height = max(labelSize.height, 24)
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
    
    /*
     CustomView 설정하는 부분
     */
    func configure(
        _ data : InformationMarker,
        _ completin : @escaping (UIImage?) -> Void) {
            
            /*
             서버에서 이미지를 가져와 처리하는 부분
             */
            let url = URL(string: data.imgUrl)
            let resource = ImageResource(downloadURL: url!)
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let value):
                    self.imgView.image = value.image
                    
                    /*
                     Color 설정
                     */
                    self.informationLabel.text = "\(data.count)"
                    self.informationLabel.textColor = UIColor(data.docorateColor)
                    self.layer.borderColor = UIColor(data.docorateColor).cgColor
                    
                    self.frame = CGRect(origin: .zero, size: self.intrinsicContentSize)
                    
                    /*
                     현재 CustomView의 View 계층 구조에서 필요한 모든 레이아웃의 계산을 강제로 수행
                     이 코드를 호출 하기 때문에 AutoLayout을 통한 배치를 완료 할 수 있다.
                     */
                    self.layoutIfNeeded()
                    
                    /*
                     완료가 되어 View의 배치가 모두 완료가 되었을때 Snapshot을 찍어 View를 Image로 치환한다.
                     */
                    let img = self.toImage()
                    
                    completin(img)
                case .failure(let e):
                    print("Information Image Render Error : \(e.localizedDescription)")
                    completin(nil)
                }
            }
            
            /*
             view의 frame은
             informationLabel의 text가 결정 된 후 informationLabel의 intrinsicContentSize를 판단하여
             동적으로 결정한다.
             */
            self.frame = .zero
            
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
        
        /*
         AutoLayout 배치 코드
         */
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
