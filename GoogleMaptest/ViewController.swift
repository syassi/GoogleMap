//
//  ViewController.swift
//  GoogleMaptest
//
//  Created by yasushi saitoh on 2018/02/21.
//  Copyright © 2018年 SunQ. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    private var mapView: GMSMapView!
    private var locationManager: CLLocationManager!
    private var initView: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let camera = GMSCameraPosition.camera(withLatitude: 35.68154,                                                      longitude: 139.752498, zoom: 15)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        //青い点（現在地）表示
        mapView.isMyLocationEnabled = true
        //現在地ボタン
        mapView.settings.myLocationButton = true
        //階数ピッカー
        mapView.settings.indoorPicker = true
        
        mapView.delegate = self
        
        self.view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(35.68154,139.752498)
        marker.title = "The Imperial Palace"
        marker.snippet = "Tokyo"
        marker.map = mapView
        
        
        //宮内庁を追加 35.683819,139.754274
        let markerKunaiCho = GMSMarker()
        markerKunaiCho.icon = GMSMarker.markerImage(with: .purple)
        markerKunaiCho.position = CLLocationCoordinate2DMake(35.683819,139.754274)
        markerKunaiCho.title = "宮内庁"
        markerKunaiCho.snippet = "Tokyo"
        markerKunaiCho.map = mapView
        
//        locationManager = CLLocationManager() // インスタンスの生成
//        locationManager.delegate = self
//        locationManager.distanceFilter = 100.0 // 水平方向の最小移動距離（メートル単位）を指定します。
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        print("pin \(String(describing: marker.title)) was tapped")
        
        return false
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        print("--- Position : \(position)")
    }
}

extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !self.initView {
            // 初期描画時のマップ中心位置の移動
            let camera = GMSCameraPosition.camera(withTarget: (locations.last?.coordinate)!, zoom: 15)
            self.mapView.camera = camera
            self.locationManager.stopUpdatingLocation()
            self.initView = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("ユーザーはこのアプリケーションに関してまだ選択を行っていません")
            // 許可を求めるコードを記述する（後述）
            locationManager.requestWhenInUseAuthorization() // 起動中のみの取得許可を求める
            break
        case .denied:
            print("ローケーションサービスの設定が「無効」になっています (ユーザーによって、明示的に拒否されています）")
            // 「設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい」を表示する
            break
        case .restricted:
            print("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
            // 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
            break
        case .authorizedAlways:
            print("常時、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            
            locationManager.startUpdatingLocation()
            
            break
        case .authorizedWhenInUse:
            print("起動時のみ、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            
            locationManager.startUpdatingLocation()
            
            break
        }
    }
}

