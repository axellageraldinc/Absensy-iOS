//
//  MakulTableViewCell.swift
//  absensy
//
//  Created by Axellageraldinc Adryamarthanino on 21/05/18.
//  Copyright © 2018 Axellageraldinc Adryamarthanino. All rights reserved.
//

import UIKit

class MakulTableViewCell: UITableViewCell {

    @IBOutlet weak var lblIdMataKuliah: UILabel!
    @IBOutlet weak var lblNamaMataKuliah: UILabel!
    @IBOutlet weak var lblJumlahAbsen: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
