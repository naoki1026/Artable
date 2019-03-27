//
//  ViewController.swift
//  Artable
//
//  Created by Naoki Arakawa on 2019/03/15.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit

//FirebaseでFirestoreもカバーしている
import Firebase


class HomeVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var loginOutBtn: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Variables
    var categories = [Category]()
    var selectedCategory : Category!
    var db : Firestore!
    var listener : ListenerRegistration!
    
    
    
    //1度しか呼び出されない
    override func viewDidLoad() {
        super.viewDidLoad()
    
    //setupNavigationBar()
    db = Firestore.firestore()
       
        
//        let category = Category.init(name: "Nature", id: "lksjdh", imgUrl: "https://images.unsplash.com/photo-1552616232-1be3e95464af?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60", isActive: true, timeStamp: Timestamp())
//        categories.append(category)
        
        setupCollectionView()
        setUpInitialAnonymousUser()
        
    }
    
    //ナビゲーションバーのフォントの設定を行う
    func setupNavigationBar() {
        guard let font = UIFont(name: "futura", size: 26) else { return }
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font: font]
        
    }
    
    func setupCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //UINib(nibName: , bundle: )で指定できる
        collectionView.register(UINib(nibName: Identifiers.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CategoryCell)
        
    }
    
    func setUpInitialAnonymousUser () {
        
        //ゲストユーザーであるか否かについて確認する
        if Auth.auth().currentUser == nil {
            
            //ゲストユーザーを使用可能にするためのメソッドを呼び出す
            Auth.auth().signInAnonymously { (result, error) in
                
                //エラーが発生した場合
                if let error = error {
                    
                    Auth.auth().handleFireAuthError(error: error, vc: self)
                    debugPrint(error)
                    
                }
            }
        }
        
    }
    
    //画面が表示された直後
    override func viewDidAppear(_ animated: Bool) {
    setCategoriesListener()
        
        // fetchDocument()
       //fetchCollection()
        
        //状況に応じてボタンの表示名を変更する
        if let _ = Auth.auth().currentUser {
            
            loginOutBtn.title = "Logout"
            
        } else {
            
            loginOutBtn.title = "Login"
            
        }
    }
    
    //別の画面に遷移する直前
    override func viewWillDisappear(_ animated: Bool) {
       listener.remove()
        
        //配列の中身をすべて削除して
       categories.removeAll()
    
       //その状態で読み込む
       collectionView.reloadData()
        
    }
    
    func setCategoriesListener() {
        
        //{(snap, error)}はクロージャーだ
        //addSnapshotListenerですべての配列を取得してくる
        //queryはwhereで指定する
        listener = db.categories.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
                
            }
            
            //取得してきたデータをchangeとするよということを定義
            //documentChangesで変更があったものだけ取得してくる
            snap?.documentChanges.forEach({ ( change ) in
                
                let data = change.document.data()
                let category = Category.init(data: data)
                
                //どの機能を使用するか
                //こんな使い方があるんだ・・・。
                switch change.type {
                    
                case .added :
                    self.onDocumentAdded(change: change, category: category)
                    
                case .modified :
                    self.onDocumentModified(change: change, category: category)
                    
                case . removed:
                    self.onDocumentRemoved(change: change)
                    
                }
                
            })
        })
    }
    
    //fileprivateは同一ファイル内であればアクセスできるということを表している
    fileprivate func presentLoginController() {
        
        //定数でLoginStoryboradのstoryboradを指定する
        //構造体StoryboardのLoginStoryboardプロパティを指している
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        
        //withIdentifierで指定したstoryboradを指定する
        //構造体StoryboardIdのLoginVCで定義したIdentifierを定義する
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardId.LoginVC)
        
        //これは関数で、一番目の引数で指定したstoryboradを表示する
        //開いている間親ウインドウを操作できなくなる子ウインドウのモーダルとして表示する
        present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func loginOutClicked(_ sender: Any) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        if user.isAnonymous {
            
            presentLoginController()
        
        } else {
            
              do {
                
                try Auth.auth().signOut()
                Auth.auth().signInAnonymously{ (resutl, error) in
                    if let error = error {
                        
                        debugPrint(error)
                    }
                    
                     self.presentLoginController()
                    
                }
                
            } catch {
                
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint(error)
            }
        }
    }
}

extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
//
    
    func onDocumentAdded(change: DocumentChange, category:  Category) {
        let newIndex = Int(change.newIndex)
        
        //配列の中に入れ込んでいる
        categories.insert(category, at: newIndex)
        collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)])
        
    }
    
    func onDocumentModified(change: DocumentChange, category: Category) {
        
        if change.newIndex == change.oldIndex {
            
            //Item changed, but remained in the same position
            //内容は変更されているものの、位置はそのままの状態である場合
            //全体を更新せずに、変更が発生したもののみ更新する
            let index = Int(change.newIndex)
            categories[index] = category
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            
        } else {
            
            //Item changed and changed position
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            categories.remove(at: oldIndex)
            categories.insert(category, at:newIndex)
            
            collectionView.moveItem(at:IndexPath(item: oldIndex, section: 0), to: IndexPath(item:newIndex, section: 0))
            
        }
    }

    
    func onDocumentRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        categories.remove(at: oldIndex)
        collectionView.deleteItems(at: [IndexPath(item: oldIndex, section: 0 )])
        
    }
    
////////////////////////////
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CategoryCell, for: indexPath) as? CategoryCell {
            
            //アイテムの数、collectionならitem
            cell.configureCell(category: categories[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    //セルのサイズについて定義する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let cellWidth = (width - 30) / 2
        let cellHight = cellWidth * 1.5
        
        return CGSize(width: cellWidth, height: cellHight)
        
    }
    
    //セルが選択されたとき
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: Segues.ToProducts, sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.ToProducts {
            if let destination = segue.destination as? ProductsVC {
                
                //destinationは遷移先のことを示している
                destination.category = selectedCategory
                
            }
        }
    }
}

////Firestoreからデータを取得する
//func fetchDocument() {
//
//    //データベースを参照して、データを取得して、持ってくる
//    //Firebaseのcategoriesというコレクションにある、idがIAeiS1kxWK9yzwwbqQNQを取得する
//    //これはアプリを終了させずに非表示にしている場合でも動いてしまう
//    let docRef = db.collection("categories").document("IAeiS1kxWK9yzwwbqQNQ")
//
//    //データベース上で更新すればリアルタイムでアプリに反映される、それがaddSnapshotListberである
//    //{(snap, error)} これはsnapの情報とエラーの情報を返すということを意味している
//    docRef.addSnapshotListener { (snap, error) in
//
//
//        self.categories.removeAll()
//
//        //snapが空っぽかもしれないので、ここでguard文をかませている
//        guard let data = snap?.data() else { return }
//        let newCategory = Category.init(data: data)
//        self.categories.append(newCategory)
//        self.collectionView.reloadData()
//
//    }
//    //docRefに格納されているデータを取得してくる
//    docRef.getDocument { (snap, error) in
//        guard let data = snap?.data() else { return }
//
//        let newCategory = Category.init(data:data)
//        self.categories.append(newCategory)
//        self.collectionView.reloadData()
//
//    }
//}
//
//func fetchCollection() {
//    let collectionReference = db.collection("categories")
//
//    listener = collectionReference.addSnapshotListener { (snap, error) in
//        guard let documents = snap?.documents else { return }
//
//        //最後のスナップショット以降に変更された文書の配列
//        print(snap?.documentChanges.count)
//
//        self.categories.removeAll()
//        for document in documents {
//
//            let data = document.data()
//            let newCategory = Category.init(data: data)
//            self.categories.append(newCategory)
//        }
//
//        self.collectionView.reloadData()
//    }
//
//
//    collectionReference.getDocuments { (snap, error) in
//        guard let documents = snap?.documents else { return }
//        for document in documents {
//
//            let data = document.data()
//            let newCategory = Category.init(data: data)
//            self.categories.append(newCategory)
//        }
//
//        self.collectionView.reloadData()
//    }
//
//
//}

/*
 
 
 

 
 do {
 throw文によるエラーが発生する可能性のある処理
 } catch {
 エラー処理
 定数errorを通じてエラー値にアクセスすることができる
 }
 

 */


//Anonymousではない場合
//        if let user = Auth.auth().currentUser, !user.isAnonymous {
//
//            //we are logged in
//            do {
//
//                //エラーが発生する可能性のある処理
////                try Auth.auth().signOut()
//
//                //ログイン画面を表示する
//                presentLoginController()
//
//            } catch {
//
//                //エラー処理
//                debugPrint(error.localizedDescription)
//
//            }
//
//        } else {
//
//            //ログイン画面を表示する
//            presentLoginController()
//
//        }


//エラーにならなかった場合に発動
//       fetchDocument()
//       fetchCollection()

