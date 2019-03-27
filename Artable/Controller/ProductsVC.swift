//
//  ProductVC.swift
//  Artable
//
//  Created by Naoki Arakawa on 2019/03/18.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ProductsVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var products = [Product]()
    var category : Category!
    var db : Firestore!
    var listener : ListenerRegistration!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.ProductCell, bundle: nil), forCellReuseIdentifier: Identifiers.ProductCell)
        
        setUpQuery()
        
    }

    
    func setUpQuery() {
        
       // listener = db.products.addSnapshotListener({ (snap, error) in
        listener = db.products(category: category.id).addSnapshotListener( { (snap, error) in
        
            if let error = error{
            debugPrint(error.localizedDescription)
            return
            }

            
            snap?.documentChanges.forEach({ ( change ) in
                
                let data = change.document.data()
                let product = Product.init( data: data)
                
                switch change.type {
                    
                case .added :
                    self.onDocumentAdded(change: change, product: product)
                    
                case .modified :
                    self.onDocumentModified(change: change, product: product)
                    
                case . removed:
                    self.onDocumentRemoved(change: change)
                    
                }
                
            })
        })
    }
    
    

}

extension ProductsVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func onDocumentAdded(change: DocumentChange, product: Product) {
        let newIndex = Int(change.newIndex)
        
        //配列の中に入れ込んでいる
        products.insert(product, at: newIndex)
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .automatic)
        
    }
    
    func onDocumentModified(change: DocumentChange, product: Product) {
        
        if change.newIndex == change.oldIndex {
            

            let index = Int(change.newIndex)
            products[index] = product
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            
        } else {
            
            //Item changed and changed position
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            products.remove(at: oldIndex)
            products.insert(product, at:newIndex)
            tableView.moveRow(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
    
        }
    }
    
    
    func onDocumentRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        products.remove(at: oldIndex)
        tableView.deleteRows(at: [IndexPath(row: oldIndex, section: 0)], with: .left)
        //(at: [IndexPath(item: oldIndex, section: 0 )])
        
    }
    
    
    //////////////////////////////////
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ProductCell, for: indexPath ) as? ProductCell {
            
            //行の数
            cell.configureCell(product: products[indexPath.row])
            return cell
        }
        
         return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
        
    }
    
    
}
