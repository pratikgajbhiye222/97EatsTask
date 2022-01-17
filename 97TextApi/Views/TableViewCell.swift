//
//  TableViewCell.swift
//  97TextApi
//
//  Created by Vinay Gajbhiye on 17/01/22.
//

import UIKit

class TableViewCell: UITableViewCell {
    var tapUpdateBtn: (()->Void)? = nil
    var tapDeleteBtn: (()-> Void)? = nil
    static var nib: UINib {
        UINib(nibName: "TableViewCell", bundle: nil)
    }
    
    
    static var identifier = "TableViewCell"
    @IBOutlet weak var picture: UIImageView!
    
    @IBOutlet weak var fullname: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func updateBtnClick(_ sender: Any) {
        tapUpdateBtn?()
    }
    
    @IBAction func deleteBtnClick(_ sender: Any) {
        tapDeleteBtn?()
    }
    
    
}
