//
//  DoubleSoundsCollectionViewCell.swift
//  aePronunciation
//
//  Created by MongolSuragch on 10/3/15.
//  Copyright © 2015 Suragch. All rights reserved.
//

import UIKit

class DoubleSoundsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    
    override var highlighted: Bool {
        didSet {
            if (highlighted) {
                self.layer.opacity = 0.6;
            } else {
                self.layer.opacity = 1.0;
            }
        }
    }
}
