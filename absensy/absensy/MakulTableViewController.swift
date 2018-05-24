//
//  MakulTableViewController.swift
//  absensy
//
//  Created by Axellageraldinc Adryamarthanino on 21/05/18.
//  Copyright © 2018 Axellageraldinc Adryamarthanino. All rights reserved.
//

import UIKit

class MakulTableViewController: UITableViewController {
    let sqliteHelper = SqliteHelper()
    var makulList = [MataKuliah]()

    @IBOutlet weak var xview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        makulList = sqliteHelper.getAllMataKuliahData()
        tableView.dataSource=self
        tableView.delegate=self
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return makulList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MakulTableViewCell", for: indexPath) as! MakulTableViewCell
        let mataKuliah = makulList[indexPath.row]
        cell.lblIdMataKuliah.text = mataKuliah.id
        cell.lblNamaMataKuliah.text = mataKuliah.nama
        cell.lblJumlahAbsen.text = "Jumlah kosong : " + String(mataKuliah.jumlahAbsen)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let indexPath2 = tableView.indexPathForSelectedRow
//
//        let currentCell = tableView.cellForRow(at: indexPath2!)! as! MakulTableViewCell
        
        let id = self.makulList[indexPath.row].id
        let mataKuliah = self.makulList[indexPath.row].nama
        let jumlahAbsen = self.makulList[indexPath.row].jumlahAbsen
        
        print("id : " + id + " mataKuliah : " + mataKuliah + " jumlahAbsen : " + String(jumlahAbsen))
        
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "addAbsenAlertView") as! AddAbsenAlertView
        customAlert.id = id
        customAlert.namaMataKuliah = mataKuliah
        customAlert.jumlahKosong = jumlahAbsen
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        present(customAlert, animated: true, completion: {
            customAlert.view.superview?.isUserInteractionEnabled = true
            customAlert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))})
        tableView.deselectRow(at: indexPath, animated: true)
    }
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    func absenKuliah(index: Int) {
        print("Status update absen : " + String(sqliteHelper.updateAbsen(cid: makulList[index].id, mataKuliah: makulList[index])))
        makulList = sqliteHelper.getAllMataKuliahData()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete"){
            (action, indexPath) in
            print("Status delete MataKuliah : " + String(self.sqliteHelper.deleteMataKuliahData(cid: self.makulList[indexPath.row].id)))
            self.makulList.remove(at: indexPath.row)
            tableView.reloadData()
            
        }
        delete.backgroundColor = UIColor.red
        return [delete]
    }
    @IBAction func btnAddMakulClicked(_ sender: UIBarButtonItem) {
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "addMakulAlertView") as! AddMakulAlertView
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        present(customAlert, animated: true, completion: {
            customAlert.view.superview?.isUserInteractionEnabled = true
            customAlert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))})
    }
}

extension MakulTableViewController: AddMakulAlertViewDelegate, AddAbsenAlertViewDelegate {
    func btnAbsenKuliahIniClicked(mataKuliah: MataKuliah) {
        print("Status update absen : " + String(sqliteHelper.updateAbsen(cid: mataKuliah.id, mataKuliah: mataKuliah)))
        self.makulList = sqliteHelper.getAllMataKuliahData()
        tableView.reloadData()
    }
    
    func btnSimpanClicked(namaMakul: String, jumlahAbsen: Int) {
        let makul = MataKuliah(id: UUID().uuidString, nama: namaMakul, jumlahAbsen: jumlahAbsen)
        if(self.sqliteHelper.insertData(mataKuliah: makul) != -1){
            let newIndexPath = IndexPath(row: self.makulList.count, section: 0)
            self.makulList.append(makul)
            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
}
