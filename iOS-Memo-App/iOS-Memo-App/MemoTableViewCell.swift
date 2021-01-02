//
//  MemoTableViewCell.swift
//  iOS-Memo-App
//
//  Created by taehy.k on 2021/01/01.
//

import UIKit

// MARK: - Protocol
protocol MemoTableViewCellDelegate {
    func selectedToggleButton(index: Int)
}

class MemoTableViewCell: UITableViewCell {
    
    
    // MARK: - Variables
    var isClicked: Bool? {
        didSet {
            if isClicked == true {
                self.memoToggleButton.isOn = true
            } else {
                self.memoToggleButton.isOn = false
            }
        }
    }
    var index: Int? = 0
    var delegate: MemoTableViewCellDelegate?
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var memoImageLabel: UIImageView!
    @IBOutlet weak var memoTitleLabel: UILabel!
    @IBOutlet weak var memoContentLabel: UILabel!
    @IBOutlet weak var memoToggleButton: UISwitch!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
    }
    
    
    // MARK: - IBAction
    @IBAction func toggleButtonClicked(_ sender: Any) {
        
        self.delegate?.selectedToggleButton(index: index ?? -1)
        
    }
    
}
