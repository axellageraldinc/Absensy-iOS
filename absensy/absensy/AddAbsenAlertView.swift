//
//  AddAbsenAlertView.swift
//  absensy
//
//  Created by Axellageraldinc Adryamarthanino on 23/05/18.
//  Copyright © 2018 Axellageraldinc Adryamarthanino. All rights reserved.
//

import UIKit

class AddAbsenAlertView: UIViewController {
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lblIdMataKuliah: UILabel!
    @IBOutlet weak var lblNamaMataKuliah: UILabel!
    @IBOutlet weak var lblJumlahAbsen: UILabel!
    
    var delegate: AddAbsenAlertViewDelegate?
    let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    
    var id: String?
    var namaMataKuliah: String?
    var jumlahKosong: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblIdMataKuliah.text = id!
        lblNamaMataKuliah.text = namaMataKuliah!
        lblJumlahAbsen.text = "Jumlah kosong : " + String(jumlahKosong!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    func setupView() {
        alertView.layer.cornerRadius = 5
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    @IBAction func btnAbsenKuliahClicked(_ sender: UIButton) {
        delegate?.btnAbsenKuliahIniClicked(mataKuliah: MataKuliah(id: id!, nama: namaMataKuliah!, jumlahAbsen: jumlahKosong!))
        self.dismiss(animated: true, completion: nil)
    }
}
