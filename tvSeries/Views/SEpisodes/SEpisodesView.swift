//
//  SEpisodesView.swift
//  tvSeries
//
//  Created by mobile consulting on 12/8/17.
//  Copyright © 2017 daniel. All rights reserved.
//

import UIKit

class SEpisodesView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    private func customInit() {
        Bundle.main.loadNibNamed("SEpisodesView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
