//
//  SoundItemSource.swift
//  TranquilForest
//
//  Created by David Ritchie on 11/17/19.
//  Copyright © 2019 David Ritchie. All rights reserved.
//

import Foundation
import UIKit

class SoundItemSource : NSObject, UITableViewDataSource {
    var soundItems : [SoundItem]
    var cellStateStore: CellStateStore = CellStateStore()
    
    init(soundItems items : [SoundItem]){
        soundItems = items
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SoundItemCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SoundItemCell  else {
            fatalError("The dequeued cell is not an instance of SoundItemCell.")
        }

        let item = soundItems[indexPath.row]
        
        cell.updateCell(soundItem: item, cellStateStore: &cellStateStore)
        return cell
    }

}
