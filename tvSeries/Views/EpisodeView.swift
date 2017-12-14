//
//  EpisodeView.swift
//  tvSeries
//
//  Created by mobile consulting on 12/11/17.
//  Copyright © 2017 daniel. All rights reserved.
//

import UIKit

class EpisodeView: UIScrollView {

    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    private func customInit() {
        Bundle.main.loadNibNamed("EpisodeView", owner: self, options: nil)
        addSubview(scrolView)
        scrolView.frame = self.bounds
        scrolView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
