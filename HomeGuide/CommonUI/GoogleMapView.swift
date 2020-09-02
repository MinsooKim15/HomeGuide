//
//  GoogleMapView.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/09/02.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import SwiftUI
import UIKit
import GoogleMaps

struct GoogleMapViewController : UIViewRepresentable{
    
    var geocode : Geocode
    let zoom = 15
    init(geocode:Geocode){
        self.geocode = geocode
    }
    let marker : GMSMarker = GMSMarker()

    /// Creates a `UIView` instance to be presented.
    func makeUIView(context: Self.Context) -> GMSMapView {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: geocode.latitude, longitude: geocode.longitude, zoom: Float(self.zoom))
        return GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
    }

    /// Updates the presented `UIView` (and coordinator) to the latest
    /// configuration.
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: geocode.latitude, longitude: geocode.longitude)
        marker.title = "Boston"
        marker.snippet = "USA"
        marker.map = mapView
    }
}

struct GoogleMapView:View{
    var geocode : Geocode
    var body: some View{
        ZStack{
            Color.red
            GoogleMapViewController(geocode:geocode)
        }

    }
}
struct GoogleMapWholeView:View{
    var geocode : Geocode
    var body: some View{
        VStack{
            CustomNavigationBar(hasTitleText: false, titleText: "")
            Spacer().frame(height:10)
            GoogleMapView(geocode:geocode)
        }.navigationBarTitle("")
        .navigationBarHidden(true)
    }
}
