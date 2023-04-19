//
//  MainViewController.swift
//  NaverMap_CustomMarker
//
//  Created by 도학태 on 2023/04/19.
//

import Foundation
import UIKit
import NMapsMap
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher
/*
 Naver 회사 주변 좌표
  37.357478091245724 :: 127.10187561957554
  37.36165099950048 :: 127.1027768418333
 
 
  37.36179880924868 :: 127.1068967150116
  37.35967259252379 :: 127.10824139562249
  37.35637513148927 :: 127.10788376796069
  37.35404408055004 :: 127.10595257740817
  37.36324278299436 :: 127.10209019630395
 */


/*
 Marker InterFace
 1. Static Marker
 2. HumanMarker (dynamic Marker)
 3. Information Marker (dynamic Marker)
 */


class MainViewController : UIViewController {
    let disposeBag = DisposeBag()
    
    let naverMap = NMFNaverMapView()
    
    
    var staticMarkerList : [NMFMarker] = []
    var humanMarkerList : [NMFMarker] = []
    var informationMarkerList : [NMFMarker] = []
    
    
    lazy var touchHandler =  { (overlay : NMFOverlay) -> Bool in
        let userInfo = overlay.userInfo
        let type = userInfo["type"] as! MarkerType
        switch type {
        case ._static:
            let data = userInfo["data"] as! StaticMarker
            print("Static Marker ID : \(data.id)")
        case .human:
            let data = userInfo["data"] as! HumanMarker
            print("Human Marker ID : \(data.id)")
        case .information:
            let data = userInfo["data"] as! InformationMarker
            print("Information Marker ID : \(data.id)")
        }
        return true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel : MainViewModel) {
        
        viewModel.staticMarkerList
            .map {
                $0.map { [weak self] data in
                    guard let self = self else { return NMFMarker() }
                    let marker = NMFMarker()
                    marker.width = 24
                    marker.height = 24
                    marker.position = .init(lat: data.lat, lng: data.lng)
                    marker.touchHandler = self.touchHandler
                    marker.userInfo = [
                        "type" : data.type,
                        "data" : data
                    ]
                    
                    let url = URL(string: data.imgUrl)
                    let resource = ImageResource(downloadURL: url!)
                    KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                        switch result {
                        case.success(let value):
                            marker.iconImage = NMFOverlayImage(image: value.image)
                        case.failure(let e):
                            print("StaticMarker Image Render Error : \(e.localizedDescription)")
                        }
                    }
                    return marker
                }
            }
            .drive(onNext : { [weak self] in
                guard let self = self else { return }
                /*
                 맵에서 삭제
                 */
                self.staticMarkerList.forEach {
                    $0.mapView = nil
                }
                
                /*
                 변경된 값 Update
                 */
                self.staticMarkerList.removeAll()
                $0.forEach {
                    self.staticMarkerList.append($0)
                }
                
                /*
                 맵에 표시
                 */
                self.staticMarkerList.forEach {
                    if $0.mapView == nil {
                        $0.mapView = self.naverMap.mapView
                    }
                }
            })
            .disposed(by: disposeBag)
        
        
        
    
        viewModel.humanMarkerList
            .map {
                $0.map { [weak self] data in
                    guard let self = self else { return NMFMarker() }
                    let marker = NMFMarker()
                    let width : CGFloat = 44
                    let height : CGFloat = 64
                    marker.width = width
                    marker.height = height
                    marker.position = .init(lat: data.lat, lng: data.lng)
                    marker.touchHandler = self.touchHandler
                    marker.userInfo = [
                        "type" : data.type,
                        "data" : data
                    ]
                    
                    let customView = HumanMarkerView(frame: .init(x: 0, y: 0, width: width, height: height))
                    customView.configure(data) {
                        marker.iconImage = NMFOverlayImage(image: $0!)
                    }
                    return marker
                }
            }
            .drive(onNext : { [weak self] in
                guard let self = self else { return }
                /*
                 맵에서 삭제
                 */
                self.humanMarkerList.forEach {
                    $0.mapView = nil
                }
                
                /*
                 변경된 값 Update
                 */
                self.humanMarkerList.removeAll()
                $0.forEach {
                    self.humanMarkerList.append($0)
                }
                
                /*
                 맵에 표시
                 */
                self.humanMarkerList.forEach {
                    if $0.mapView == nil {
                        $0.mapView = self.naverMap.mapView
                    }
                }
            })
            .disposed(by: disposeBag)

        
        viewModel.informationMarkerList
            .map {
                $0.map { [weak self] data in
                    guard let self = self else { return NMFMarker() }
                    let marker = NMFMarker()
                    let width : CGFloat = 56
                    let height : CGFloat = 24
                    marker.width = width
                    marker.height = height
                    marker.position = .init(lat: data.lat, lng: data.lng)
                    marker.touchHandler = self.touchHandler
                    marker.userInfo = [
                        "type" : data.type,
                        "data" : data
                    ]
                    let customView = InformationMarkerView(frame: .init(x: 0, y: 0, width: width, height: height))
                    customView.configure(data) {
                        marker.iconImage = NMFOverlayImage(image: $0!)
                    }
                    return marker
                }
            }
            .drive(onNext : { [weak self] in
                guard let self = self else { return }
                /*
                 맵에서 삭제
                 */
                self.informationMarkerList.forEach {
                    $0.mapView = nil
                }
                
                /*
                 변경된 값 Update
                 */
                self.informationMarkerList.removeAll()
                $0.forEach {
                    self.informationMarkerList.append($0)
                }
                
                /*
                 맵에 표시
                 */
                self.informationMarkerList.forEach {
                    if $0.mapView == nil {
                        $0.mapView = self.naverMap.mapView
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setMarkerImage(_ marker : NMFMarker) {
        
    }
    
    private func attribute() {
        naverMap.mapView.touchDelegate = self
    }
    
    private func layout() {
        [
            naverMap
        ].forEach {
            view.addSubview($0)
        }
        
        naverMap.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}


extension MainViewController : NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("lat : \(latlng.lat) /// lng : \(latlng.lng)")
    }
}


