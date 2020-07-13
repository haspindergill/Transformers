//
//  ListTableViewCell.swift
//  Transformers
//
//  Created by Haspinder Gill on 2020-07-11.
//  Copyright © 2020 Haspinder Gill. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var transformerIcon: UIImageView!
    @IBOutlet weak var transformerName: UILabel!
    @IBOutlet weak var tansformerRank: UILabel!
    @IBOutlet var transformerCharacteristics: [UIProgressView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for bar in transformerCharacteristics {
            bar.transform = CGAffineTransform(scaleX: 1, y: 4)
            bar.progressTintColor = .systemTeal
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var transformer: Transformer? {didSet{
        self.updateCellUI()
        }}
    
    func updateCellUI() {
        self.transformerName.text = transformer?.name
        self.tansformerRank.text = "Rank #\(transformer?.rank ?? 1)"
        self.setProgress(progressBar: self.transformerCharacteristics[0], withValue: transformer?.strength)
        self.setProgress(progressBar: self.transformerCharacteristics[1], withValue: transformer?.skill)
        self.setProgress(progressBar: self.transformerCharacteristics[2], withValue: transformer?.firepower)
        self.setProgress(progressBar: self.transformerCharacteristics[3], withValue: transformer?.intelligence)
        self.setProgress(progressBar: self.transformerCharacteristics[4], withValue: transformer?.speed)
        self.setProgress(progressBar: self.transformerCharacteristics[5], withValue: transformer?.endurance)
        self.setProgress(progressBar: self.transformerCharacteristics[6], withValue: transformer?.courage)
        self.setImage()
    }
    
    func setProgress(progressBar: UIProgressView,withValue value: Int?) {
        guard let value = value else { print("returning value")
            return }
        progressBar.setProgress((Float(value)/10.0), animated: progressBar.progress > 0 ? false : true)
    }
    
    func setImage() {
        APIManager.sharedInstance.downloadImage(withurl: API.DownloadImage(url: transformer?.teamIcon ?? "")) { (response) in
            switch response {
            case .Failure:
                print("")
                self.transformerIcon.image = nil
            case .Success(let data):
                DispatchQueue.main.async {
                    self.transformerIcon?.image = UIImage(data: data)
                }
            }
        }
    }

}
