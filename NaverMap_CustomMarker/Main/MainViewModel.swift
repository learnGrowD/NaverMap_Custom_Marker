//
//  MainViewModel.swift
//  NaverMap_CustomMarker
//
//  Created by 도학태 on 2023/04/19.
//

import Foundation
import RxSwift
import RxCocoa

struct MainViewModel {
    
    
    var staticMarkerList : Driver<[StaticMarker]>! = nil
    
    
    var humanMarkerList : Driver<[HumanMarker]>! = nil
    
    var informationMarkerList : Driver<[InformationMarker]>! = nil
    
    init() {
        
        staticMarkerList = Driver.just([
            .init(type: ._static, id: 0, lat: 37.356136344215585, lng: 127.10234768837722, imgUrl: "https://cdn-icons-png.flaticon.com/512/3658/3658773.png"),
            .init(type: ._static, id: 1, lat: 37.3561477148818, lng: 127.10529454232739, imgUrl: "https://cdn-icons-png.flaticon.com/512/1250/1250683.png"),
            .init(type: ._static, id: 2, lat: 37.356284164825, lng: 127.10819848027683, imgUrl: "https://cdn-icons-png.flaticon.com/512/307/307325.png")
        ])
        
        humanMarkerList = Driver.just([
            .init(type: .human, id: 3, lat: 37.358455959863576, lng: 127.10274823138474, imgUrl: "https://cdn.pixabay.com/photo/2022/02/23/17/08/planets-7031048__480.jpg", decorateColor: "#3B7B0D"),
            .init(type: .human, id: 4, lat: 37.35854692389589, lng: 127.10692532546011, imgUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRb4WbK-3RFO7_c7cP1fZ0AEK1sVBvEqwFNDx6emzQIm5wN49FKbxo3WECcpKrBeOXbmxM&usqp=CAU", decorateColor: "#D8E337"),
            .init(type: .human, id: 5, lat: 37.35842184838813, lng: 127.11020119662356, imgUrl: "https://upload.wikimedia.org/wikipedia/commons/b/b4/Lionel-Messi-Argentina-2022-FIFA-World-Cup_%28cropped%29.jpg", decorateColor: "#9113C3")
        ])
        
        
        informationMarkerList = Driver.just([
            .init(type: .information, id: 6, lat: 37.36184428899243, lng: 127.102276162583, imgUrl: "https://cdn-icons-png.flaticon.com/512/1515/1515636.png", docorateColor: "#3E7D47", count: 3),
            .init(type: .information, id: 7, lat: 37.36196935879643, lng: 127.10566647488639, imgUrl: "https://cdn-icons-png.flaticon.com/512/5050/5050019.png", docorateColor: "#6B26B0", count: 5),
            .init(type: .information, id: 8, lat: 37.36199209888029, lng: 127.10944302529919, imgUrl: "https://cdn-icons-png.flaticon.com/512/6570/6570907.png", docorateColor: "#2C1C77", count: 8),
        ])
        
        
        
        
    }
    
}
