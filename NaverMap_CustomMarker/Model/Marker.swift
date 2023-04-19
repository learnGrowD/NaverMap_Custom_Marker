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
protocol MarKerProtocol {
    var type : MarkerType { get set }
    var id : Int { get set }
    var lat : Double { get set }
    var lng : Double { get set }
}


struct StaticMarker : MarKerProtocol {
    var type: MarkerType
    
    var id: Int
    
    var lat: Double
    
    var lng: Double
    
    
    let imgUrl : String
}

struct HumanMarker : MarKerProtocol {
    var type: MarkerType
    
    var id: Int
    
    var lat: Double
    
    var lng: Double
    
    let imgUrl : String
    
    let decorateColor : String
}


struct InformationMarker : MarKerProtocol {
    var type: MarkerType
    
    var id: Int
    
    var lat: Double
    
    var lng: Double
    
    let imgUrl : String
    
    let docorateColor : String
    
    let count : Int
}
