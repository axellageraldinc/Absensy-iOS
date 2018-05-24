//
//  SqliteHelper.swift
//  absensy
//
//  Created by Axellageraldinc Adryamarthanino on 23/05/18.
//  Copyright © 2018 Axellageraldinc Adryamarthanino. All rights reserved.
//

import Foundation
import SQLite

class SqliteHelper {
    
    private var db: Connection? = nil
    private let tableMataKuliah = Table("mata_kuliah")
    private let id = Expression<String>("id")
    private let namaMataKuliah = Expression<String>("nama_makul")
    private let jumlahAbsenKuliah = Expression<Int>("jumlah_absen_mata_kuliah")
    
    init(){
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            db = try Connection("\(path)/Absensy.sqlite3")
            print("Sukses connect DB")
        } catch {
            db = nil
            print ("Unable to open database")
        }
        createTable()
    }
    
    func createTable() {
        do {
            try db!.run(tableMataKuliah.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(namaMataKuliah, unique: true)
                table.column(jumlahAbsenKuliah)
            })
            print("Create table success!")
        } catch {
            print("Unable to create table")
        }
    }
    
    func insertData(mataKuliah: MataKuliah) -> Int64 {
        var isInsertSuccess:Int64
        do {
            let insert = tableMataKuliah.insert(self.id <- mataKuliah.id,
                                                self.namaMataKuliah <- mataKuliah.nama,
                                                self.jumlahAbsenKuliah <- mataKuliah.jumlahAbsen)
            let id = try db?.run(insert)
            isInsertSuccess=id!
        } catch {
            print("Insert failed!")
            isInsertSuccess = -1
        }
        return isInsertSuccess
    }
    
    func getAllMataKuliahData() -> [MataKuliah] {
        var mataKuliah = [MataKuliah]()
        do {
            for data in (try db?.prepare(self.tableMataKuliah))!{
                mataKuliah.append(MataKuliah(
                    id: data[id],
                    nama: data[namaMataKuliah],
                    jumlahAbsen: data[jumlahAbsenKuliah]))
            }
        } catch {
            print("Get All Mata Kuliah Data failed!")
        }
        return mataKuliah
    }
    
    func deleteMataKuliahData(cid: String) -> Bool {
        let isDeleteSuccess:Bool
        do {
            let deletedData = tableMataKuliah.filter(id == cid)
            try db?.run(deletedData.delete())
            isDeleteSuccess=true
        } catch {
            isDeleteSuccess=false
        }
        return isDeleteSuccess
    }
    
    func updateAbsen(cid:String, mataKuliah: MataKuliah) -> Bool {
        let mataKuliahData = tableMataKuliah.filter(id == cid)
        do {
            let update = mataKuliahData.update([
                jumlahAbsenKuliah <- mataKuliah.jumlahAbsen+1
                ])
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        return false
    }
    
}
