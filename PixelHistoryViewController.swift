//
//  PixelHistoryViewController.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/16/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class PixelHistoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var data: [AnyObject]?
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var noDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data != nil {
            if data!.count == 0 {
                self.noDataLabel.isHidden = false
            }
            else {
                self.noDataLabel.isHidden = true
            }
            
            return data!.count
        }
        else {
            self.noDataLabel.isHidden = false
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PixelHistoryItemCell", for: indexPath) as! PixelHistoryCollectionViewCell
        
        let dataObj = data![indexPath.row] as! [String: AnyObject]
        
        let color = dataObj["color"] as! Int32
        let name = dataObj["name"] as! String
        let level = dataObj["level"] as! Int
        let timestamp = dataObj["timestamp"] as! Int
        
        cell.nameLabel.text = name + " (" + String(level) + ")"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        
        dateFormatter.dateFormat = "MM-dd-yy"
        
        let date = Date(timeIntervalSince1970: Double(timestamp))
        cell.dateLabel.text = dateFormatter.string(from: date)
        
        cell.colorView.backgroundColor = UIColor(argb: color)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 60)
    }
}
