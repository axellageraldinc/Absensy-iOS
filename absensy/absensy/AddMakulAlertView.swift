//
//  AddMakulAlertView.swift
//  absensy
//
//  Created by Axellageraldinc Adryamarthanino on 23/05/18.
//  Copyright © 2018 Axellageraldinc Adryamarthanino. All rights reserved.
//

import UIKit

class AddMakulAlertView: UIViewController {
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var txtInputNamaMataKuliah: UITextField!
    @IBOutlet weak var txtInputJumlahAbsen: UITextField!
    @IBOutlet weak var btnSimpan: UIButton!
    
    var delegate: AddMakulAlertViewDelegate?
    let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtInputNamaMataKuliah.becomeFirstResponder()
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
    
    @IBAction func btnSimpanMataKuliahClicked(_ sender: UIButton) {
        txtInputNamaMataKuliah.resignFirstResponder()
        txtInputJumlahAbsen.resignFirstResponder()
        delegate?.btnSimpanClicked(namaMakul: txtInputNamaMataKuliah.text!, jumlahAbsen: Int(txtInputJumlahAbsen.text!)!)
        self.dismiss(animated: true, completion: nil)
    }
    
}
