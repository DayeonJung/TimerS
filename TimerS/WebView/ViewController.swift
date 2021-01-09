//
//  ViewController.swift
//  TimerS
//
//  Created by Dayeon Jung on 04/02/2020.
//  Copyright © 2020 Dayeon Jung. All rights reserved.
//
// 참고: https://www.theteams.kr/teams/866/post/64575
//      https://leejigun.github.io/CoreBlutooth

import UIKit
import WebKit
import PureLayout
import GoogleMobileAds
import AVFoundation
import AudioToolbox
import PWSwitch
import CoreBluetooth

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    enum Handler: String {
        case timeOut = "timeoutHandler"
        case hamburger = "hamburgerHandler"
        case interstitial = "interstitialHandler"
    }
    
    enum Effect: String {
        case vibration
        case sound
        case all
    }
    
    var bannerView: GADBannerView!
    var bannerContainer: UIView?
    
    var webView: WKWebView?

    var indicator: UIActivityIndicatorView?
    
    var interstitial: GADInterstitial!

    var alertSound: AVAudioPlayer?

    private let serviceUUID: CBUUID = CBUUID(string: "6135D146-0D7A-4395-A6CF-6C5B50B830F9")
    
    var peripheral: CBPeripheralManager!
    var central: CBCentralManager!

    let btnCentral = NBButton(forAutoLayout: ())
    let btnPeripheral = NBButton(forAutoLayout: ())
    let btnNext = NBButton(forAutoLayout: ())
    
    var nextBtnClicked: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setIndicator()
            
        self.setWebView()
        
        self.setBannerView()

        self.interstitial = createAndLoadInterstitial()
        
        self.setButtonsUI()
        self.setButtonsEvent()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func setIndicator() {
        self.indicator = UIActivityIndicatorView(forAutoLayout: ())
        self.view.addSubview(self.indicator!)
        self.indicator?.autoCenterInSuperview()
    }
    
    func setButtonsUI() {
        self.view.addSubview(self.btnPeripheral)
        self.btnPeripheral.autoSetDimensions(to: CGSize(width: 110, height: 40))
        self.btnPeripheral.autoPinEdge(.top, to: .top, of: self.view, withOffset: 50)
        self.btnPeripheral.autoPinEdge(toSuperviewEdge: .right)
        self.btnPeripheral.setTitle("Peripheral", for: .normal)
        
        self.view.addSubview(self.btnNext)
        self.btnNext.autoSetDimensions(to: CGSize(width: 40, height: 40))
        self.btnNext.autoPinEdge(.top, to: .top, of: self.view, withOffset: 50)
        self.btnNext.autoPinEdge(.trailing, to: .leading, of: self.btnPeripheral, withOffset: 10)
        self.btnNext.setTitle("->", for: .normal)

        
        self.view.addSubview(self.btnCentral)
        self.btnCentral.autoSetDimensions(to: CGSize(width: 80, height: 40))
        self.btnCentral.autoPinEdge(.top, to: .top, of: self.view, withOffset: 50)
        self.btnCentral.autoPinEdge(.leading, to: .leading, of: self.view, withOffset: 50)
        self.btnCentral.setTitle("Central", for: .normal)
    }
    
    
    func setButtonsEvent() {
        
        self.btnPeripheral.onClick = {
            self.peripheral = CBPeripheralManager(delegate: self, queue: nil)
            self.peripheral.delegate = self
            
        }
        
        self.btnNext.onClick = {
            self.nextBtnClicked = !self.nextBtnClicked
            self.peripheral.startAdvertising([
                CBAdvertisementDataLocalNameKey: self.nextBtnClicked,
                CBAdvertisementDataServiceUUIDsKey: [self.serviceUUID],
            ])
        }
        
        self.btnCentral.onClick = {
            self.central = CBCentralManager(delegate: self, queue: nil)
        }

    }
}

extension ViewController: CBPeripheralManagerDelegate {
    
    // 2. 사용가능한 상태가 되면 특정 UUID를 가진 서비스를 추가
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            
            let service = CBMutableService(type: self.serviceUUID, primary: true)
            self.peripheral.add(service)
            print("bt peripheral powered on")
            
        }
    }

    // 3. 원하는 정보를 advertising
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        var passingValue = "스위치끔"
        if self.nextBtnClicked {
            passingValue = "스위치켬"
            self.nextBtnClicked = false
        }
        self.peripheral.startAdvertising([
            CBAdvertisementDataLocalNameKey: passingValue,
            CBAdvertisementDataServiceUUIDsKey: [self.serviceUUID],
        ])
        print("bt peripheral advertising")
        
    }
    
    
}

extension ViewController: CBCentralManagerDelegate {
    
    // 2. 사용가능한 상태가 되면 특정 UUID를 가진 서비스를 스캔
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            // 이미 한 번 스캔된 정보라도 계속 스캔.
            let options = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
            self.central.scanForPeripherals(withServices: [self.serviceUUID], options: options)
            print("bt central powered on")
        }
    }
    
    // 3. Peripheral이 스캔되면 이 메서드가 호출.
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let data = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
           print(data)
        }
    }
    
    
}

