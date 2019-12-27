//
//  SoundItemCell.swift
//  TranquilForest
//
//  Created by David Ritchie on 11/16/19.
//  Copyright © 2019 David Ritchie. All rights reserved.
//

import UIKit

class SoundItemCell: UITableViewCell {
    var headerLabel: UILabel!
    var levelSlider: UISlider!
    var toggleSwitch: UISwitch!
    var iconImageView: UIImageView!
    var cellStateStore: CellStateStore = CellStateStore()
    
    required init(coder: NSCoder){
        super.init(coder: coder)!
        
        let screenSize: CGRect = UIScreen.main.bounds
        let width = Int(screenSize.width)
        let rightMargin = 10

        iconImageView = UIImageView(frame: CGRect(x: 4, y: 4, width: 72, height: 72))
        addSubview(iconImageView)
        
        headerLabel = UILabel(frame: CGRect(x: 90, y: 10, width: width - (90 + rightMargin), height: 20))
        addSubview(headerLabel)

        levelSlider = UISlider(frame: CGRect(x: 150, y: 38, width: width - (150 + rightMargin), height: 20))
        levelSlider.addTarget(self, action: #selector(sliderChanged), for: UIControl.Event.valueChanged)
        addSubview(levelSlider)

        toggleSwitch = UISwitch(frame: CGRect(x: 90, y: 38, width: 47, height: 31))
        toggleSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        addSubview(toggleSwitch)
    }
   
    @objc func switchChanged(aSwitch: UISwitch) {
        updateCellState()
        if(aSwitch.isOn) {
            NotificationCenter.default.post(name: .cmdStartPlaying, object: self, userInfo: ["AudioFile": AudioFile])
        }
        else {
            NotificationCenter.default.post(name: .cmdStopPlaying, object: self, userInfo: ["AudioFile": AudioFile])
        }
    }
    
    @objc func sliderChanged(aSlider: UISlider) {
        updateCellState()
        NotificationCenter.default.post(name: .cmdSetVolume, object: self, userInfo: [AudioFile: Volume])
    }

    var Text : String {
        get {
            return headerLabel.text ?? ""
        }
        set {
            headerLabel.text = newValue
        }
    }
    
    var Volume : Float {
        get {
            return levelSlider.value
        }
        set {
            levelSlider.value = newValue
        }
    }
    
    var IsOn : Bool {
        get {
            return toggleSwitch.isOn
        }
        set {
            toggleSwitch.isOn = newValue
        }
    }
    
    var AudioFile : String = ""
 
    func updateCell( soundItem: SoundItem, cellStateStore store: inout CellStateStore) {
        cellStateStore = store
        
        if let cellState = cellStateStore.getCellState(cellIdentifier: soundItem.AudioFile, createIfNotFound: true) {
            IsOn = cellState.isOn
            Volume = cellState.volume
        }
        
        Text = soundItem.Name
        iconImageView.image = UIImage(named: soundItem.ImageName)
        AudioFile = soundItem.AudioFile
    }
    
    func updateCellState() {
        var cellState = CellState()
        cellState.isOn = IsOn
        cellState.volume = Volume
        
        cellStateStore.saveCellState(cellIdentifier: AudioFile, newCellState: cellState)
    }
}
