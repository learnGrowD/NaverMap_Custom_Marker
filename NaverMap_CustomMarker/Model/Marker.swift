//
//  Marker.swift
//  NaverMap_CustomMarker
//
//  Created by 도학태 on 2023/04/19.
//

import Foundation

/*
 0 -> static
 1 -> human
 2 -> information
 */

enum MarkerType {
    case _static
    case human
    case information
}

/*
 Marker의 기본이 되는 데이터
 */
protocol MarKerProtocol {
    var type : MarkerType { get set }
    var id : Int { get set }
    var lat : Double { get set }
    var lng : Double { get set }
}


/*
 크기와 모양이 정해진 정적인 마커 데이터
 */
struct StaticMarker : MarKerProtocol {
    var type: MarkerType
    
    var id: Int
    
    var lat: Double
    
    var lng: Double
    
    
    let imgUrl : String
}


/*
 사용자를 표현하는 마커 데이터
 */
struct HumanMarker : MarKerProtocol {
    var type: MarkerType
    
    var id: Int
    
    var lat: Double
    
    var lng: Double
    
    let imgUrl : String
    
    let decorateColor : String
}


/*
 매물 수 등과 같은 정보를 표현하기 위한 마커 데이터
 */
struct InformationMarker : MarKerProtocol {
    var type: MarkerType
    
    var id: Int
    
    var lat: Double
    
    var lng: Double
    
    let imgUrl : String
    
    let docorateColor : String
    
    let count : Int
}
