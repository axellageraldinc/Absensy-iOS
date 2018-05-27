//
//  MakulTableViewController.swift
//  absensy
//
//  Created by Axellageraldinc Adryamarthanino on 21/05/18.
//  Copyright © 2018 Axellageraldinc Adryamarthanino. All rights reserved.
//

import UIKit
import UserNotifications

class MakulTableViewController: UITableViewController {
    let sqliteHelper = SqliteHelper()
    var makulList = [MataKuliah]()
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound];

    @IBOutlet weak var xview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        askForNotificationPermission()
        makulList = sqliteHelper.getAllMataKuliahData()
        tableView.dataSource=self
        tableView.delegate=self
    }
    
    func askForNotificationPermission() {
        center.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                print("No notifications allowed!")
            }
        }
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
        cell.lblJadwalKuliah.text = mataKuliah.hariKuliah + ", " + mataKuliah.jamKuliah
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addAbsenDialog = initAddAbsenDialog(indexPath: indexPath)
        present(addAbsenDialog, animated: true, completion: {
            addAbsenDialog.view.superview?.isUserInteractionEnabled = true
            addAbsenDialog.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))})
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let delete = UITableViewRowAction(style: .destructive, title: "Delete"){
//            (action, indexPath) in
//            print("Status delete MataKuliah : " + String(self.sqliteHelper.deleteMataKuliahData(cid: self.makulList[indexPath.row].id)))
//            self.makulList.remove(at: indexPath.row)
//            tableView.reloadData()
//
//        }
//        delete.backgroundColor = UIColor.red
//        return [delete]
//    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .destructive, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
        })
        editAction.backgroundColor = UIColor.blue
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Status delete MataKuliah : " + String(self.sqliteHelper.deleteMataKuliahData(cid: self.makulList[indexPath.row].id)))
            self.makulList.remove(at: indexPath.row)
            tableView.reloadData()
            self.deletePraKuliahNotification(idKuliah: self.makulList[indexPath.row].id)
            self.deleteSaatKuliahNotification(idKuliah: self.makulList[indexPath.row].id)
            success(true)
        })
        deleteAction.backgroundColor = UIColor.red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func initAddAbsenDialog(indexPath: IndexPath) -> AddAbsenAlertView {
        let id = self.makulList[indexPath.row].id
        let mataKuliah = self.makulList[indexPath.row].nama
        let jumlahAbsen = self.makulList[indexPath.row].jumlahAbsen
        let hariKuliah = self.makulList[indexPath.row].hariKuliah
        let jamKuliah = self.makulList[indexPath.row].jamKuliah
        let addAbsenDialog = self.storyboard?.instantiateViewController(withIdentifier: "addAbsenAlertView") as! AddAbsenAlertView
        addAbsenDialog.id = id
        addAbsenDialog.namaMataKuliah = mataKuliah
        addAbsenDialog.jumlahKosong = jumlahAbsen
        addAbsenDialog.hariKuliah = hariKuliah
        addAbsenDialog.jamKuliah = jamKuliah
        addAbsenDialog.providesPresentationContextTransitionStyle = true
        addAbsenDialog.definesPresentationContext = true
        addAbsenDialog.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        addAbsenDialog.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        addAbsenDialog.delegate = self
        return addAbsenDialog
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

    @IBAction func btnAddMakulClicked(_ sender: UIBarButtonItem) {
        let addMakulDialog = initAddMakulDialog()
        present(addMakulDialog, animated: true, completion: {
            addMakulDialog.view.superview?.isUserInteractionEnabled = true
            addMakulDialog.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))})
    }
    
    func initAddMakulDialog() -> AddMakulAlertView {
        let addMakulDialog = self.storyboard?.instantiateViewController(withIdentifier: "addMakulAlertView") as! AddMakulAlertView
        addMakulDialog.providesPresentationContextTransitionStyle = true
        addMakulDialog.definesPresentationContext = true
        addMakulDialog.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        addMakulDialog.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        addMakulDialog.delegate = self
        return addMakulDialog
    }
    
    func createNotification(idKuliah: String, namaMakul: String, jumlahAbsen: Int, jadwalKuliah: Date){
        createPraKuliahNotification(idKuliah: idKuliah, namaMakul: namaMakul, jumlahAbsen: jumlahAbsen, jadwalKuliah: jadwalKuliah)
        createSaatKuliahNotification(idKuliah: idKuliah, namaMakul: namaMakul, jumlahAbsen: jumlahAbsen, jadwalKuliah: jadwalKuliah)
    }
    
    func deletePraKuliahNotification(idKuliah: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [idKuliah+"notif pra kuliah"])
    }
    func deleteSaatKuliahNotification(idKuliah: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [idKuliah+"notif saat kuliah"])
    }
    
    func createPraKuliahNotification(idKuliah: String, namaMakul: String, jumlahAbsen: Int, jadwalKuliah: Date) {
        var saran = ""
        if(jumlahAbsen==0 || jumlahAbsen==1){
            saran="Kamu bisa bolos karena jumlah absen " + String(jumlahAbsen)
        } else if(jumlahAbsen==2){
            saran="Kamu sebaiknya masuk karena jumlah absen " + String(jumlahAbsen)
        } else{
            saran="Kamu udah gak bisa bolos karena jumlah absen " + String(jumlahAbsen)
        }
        let contentNotificationPraKuliah = UNMutableNotificationContent()
        contentNotificationPraKuliah.title = "Jangan lupa kuliah " + namaMakul + "!"
        contentNotificationPraKuliah.subtitle = saran
        contentNotificationPraKuliah.sound = UNNotificationSound.default()
        let weeklyRepeatNotificationPraKuliah = Calendar.current.dateComponents([.weekday, .hour, .minute, .second], from: jadwalKuliah.addingTimeInterval(-15*60)) //-15*60 = -15 menit
        let triggerNotificationPraKuliah = UNCalendarNotificationTrigger(dateMatching: weeklyRepeatNotificationPraKuliah, repeats: true)
        let requestNotificationPraKuliah = UNNotificationRequest(
            identifier: idKuliah+"notif pra kuliah",
            content: contentNotificationPraKuliah,
            trigger: triggerNotificationPraKuliah
        )
        center.add(requestNotificationPraKuliah, withCompletionHandler: { error in
            if error != nil {
                print("error")
            } else {
                print("Notification pra kuliah set up successfully!")
            }
        })
    }
    
    func createSaatKuliahNotification(idKuliah: String, namaMakul: String, jumlahAbsen: Int, jadwalKuliah: Date) {
        let contentNotificationSaatKuliah = UNMutableNotificationContent()
        contentNotificationSaatKuliah.title = "Apakah kamu tadi absen kuliah " + namaMakul + "?"
        contentNotificationSaatKuliah.subtitle = "Jika ya, update absenmu!"
        contentNotificationSaatKuliah.sound = UNNotificationSound.default()
        let weeklyRepeatNotificationSaatKuliah = Calendar.current.dateComponents([.weekday, .hour, .minute, .second], from: jadwalKuliah.addingTimeInterval(15*60)) //15*60 = 15 menit
        let triggerNotificationSaatKuliah = UNCalendarNotificationTrigger(dateMatching: weeklyRepeatNotificationSaatKuliah, repeats: true)
        let requestNotificationSaatKuliah = UNNotificationRequest(
            identifier: idKuliah+"notif saat kuliah",
            content: contentNotificationSaatKuliah,
            trigger: triggerNotificationSaatKuliah
        )
        center.add(requestNotificationSaatKuliah, withCompletionHandler: { error in
            if error != nil {
                print("error")
            } else {
                print("Notification saat kuliah set up successfully!")
            }
        })
    }
}

extension MakulTableViewController: AddMakulAlertViewDelegate, AddAbsenAlertViewDelegate {
    func btnSimpanClicked(namaMakul: String, jumlahAbsen: Int, dateKuliah: Date) {
        let dateFormatterHari = DateFormatter()
        dateFormatterHari.dateFormat = "EEEE"
        dateFormatterHari.locale = Locale(identifier: "id_ID")
        let dateFormatterJam = DateFormatter()
        dateFormatterJam.timeStyle = DateFormatter.Style.short
        dateFormatterJam.locale = Locale(identifier: "id_ID")
        let idKuliah = UUID().uuidString
        let makul = MataKuliah(
            id: idKuliah,
            nama: namaMakul,
            jumlahAbsen: jumlahAbsen,
            hariKuliah: dateFormatterHari.string(from: dateKuliah),
            jamKuliah: dateFormatterJam.string(from: dateKuliah))
        if(self.sqliteHelper.insertData(mataKuliah: makul) != -1){
            let newIndexPath = IndexPath(row: self.makulList.count, section: 0)
            self.makulList.append(makul)
            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
            createNotification(idKuliah: idKuliah, namaMakul: namaMakul, jumlahAbsen: jumlahAbsen, jadwalKuliah: dateKuliah)
        }
    }
    
    func btnAbsenKuliahIniClicked(mataKuliah: MataKuliah) {
        print("Status update absen : " + String(sqliteHelper.updateAbsen(cid: mataKuliah.id, mataKuliah: mataKuliah)))
        self.makulList = sqliteHelper.getAllMataKuliahData()
        tableView.reloadData()
    }
}
