//
//  StatsViewController.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/22/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var backAction: ActionButtonView!
    
    var data: [[String: String]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xFF333333"))
        collectionView.backgroundColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xFF333333"))
        
        backAction.type = .backSolid
        
        backAction.setOnClickListener {
            self.performSegue(withIdentifier: "UnwindToMenu", sender: nil)
        }
        
        data = [[String: String]]()
        
        data!.append([String: String]())
        
        data![0]["Pixels Single"] = String(StatTracker.instance.numPixelsPaintedSingle)
        data![0]["Pixels World"] = String(StatTracker.instance.numPixelsPaintedWorld)
        data![0]["Pixel Overwrites In"] = String(StatTracker.instance.numPixelOverwritesIn)
        data![0]["Pixel Overwrites Out"] = String(StatTracker.instance.numPixelOverwritesOut)
        data![0]["Paint Accrued"] = String(StatTracker.instance.totalPaintAccrued)
        data![0]["World Level"] = String(StatTracker.instance.getWorldLevel())
        
        data!.append([String: String]())
        
        data![1]["Pixels Single"] = StatTracker.instance.getAchievementProgressString(eventType: .pixelPaintedSingle)
        data![1]["Pixels World"] = StatTracker.instance.getAchievementProgressString(eventType: .pixelPaintedWorld)
        data![1]["Pixel Overwrites In"] = StatTracker.instance.getAchievementProgressString(eventType: .pixelOverwriteIn)
        data![1]["Pixel Overwrites Out"] = StatTracker.instance.getAchievementProgressString(eventType: .pixelOverwriteOut)
        data![1]["Paint Accrued"] = StatTracker.instance.getAchievementProgressString(eventType: .paintReceived)
        
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if data != nil {
            count = data![section].count
        }
        
        return count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatAchievementCell", for: indexPath) as! StatAchievementCollectionViewCell
        
        let key = Array(data![indexPath.section].keys)[indexPath.item]
        
        cell.statName.text = key
        cell.statAmt.text = data![indexPath.section][key]
        
        cell.contentView.backgroundColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xFF333333"))
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "StatHeaderView", for: indexPath) as! ActionViewReusableView
        
        view.backgroundColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xFF333333"))
        
        if indexPath.section == 0 {
            view.actionView.type = .stats
            view.actionViewWidth.constant = 200
        }
        else {
            view.actionView.type = .play
            view.actionViewWidth.constant = 160
        }
        
        return view
    }
}
