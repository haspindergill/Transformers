
//
//  InternetActivity.swift
//  Transformers
//
//  Created by Haspinder Gill on 2020-07-11.
//  Copyright © 2020 Haspinder Gill. All rights reserved.
//

import Foundation
import UIKit

class InternetActivity: UIView {

    @IBOutlet var contentView: UIView!
    
    // MARK: View Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: Private
    
    private func commonInit() {
        Bundle.main.loadNibNamed("InternetActivity", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }


}




