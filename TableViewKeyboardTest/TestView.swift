//
//  TestView.swift
//  TableViewKeyboardTest
//
//  Created by ユーザー１ on 2018/10/27.
//  Copyright © 2018 Masaya Ujihara. All rights reserved.
//

import UIKit

class TestView: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var TestTableView: UITableView!
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return 15
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath) as! TestCell
    
    cell.TestTextField.tag = indexPath.row
    
    return cell
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    registerNotification()
    
    self.TestTableView.reloadData()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unregisterNotification()
  }
  
  func registerNotification() -> () {
    let center: NotificationCenter = NotificationCenter.default
    center.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    center.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  func unregisterNotification() -> () {
    let center: NotificationCenter = NotificationCenter.default
    center.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc func keyboardWillShow(notification: NSNotification) -> () {
    scrollTableCell(notification: notification, showKeyboard: true)
  }
  
  @objc func keyboardWillHide(notification: NSNotification) -> () {
    scrollTableCell(notification: notification, showKeyboard: false)
  }
  
  var lastKeyboardFrame: CGRect = CGRect.zero
  var editingPath: NSIndexPath!
  
  // TableViewCellをKeyboardの上までスクロールする処理
  func scrollTableCell(notification: NSNotification, showKeyboard: Bool) -> () {
    
    // 選択中のセルのindexPath取得
    var row = selectedIndexPath
    var indexPath = NSIndexPath(row: row, section: 0)
    editingPath = indexPath
    
    if showKeyboard {
      // keyboardのサイズを取得
      var keyboardFrame: CGRect = CGRect.zero
      if let userInfo = notification.userInfo {
        if let keyboard = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
          keyboardFrame = keyboard.cgRectValue
        }
      }
      
      // keyboardのサイズが変化した分ContentSizeを大きくする
      let diff: CGFloat = keyboardFrame.size.height - keyboardFrame.size.height
      let newSize: CGSize = try CGSize(width: TestTableView.contentSize.width, height: TestTableView.contentSize.height + diff)
      TestTableView.contentSize = newSize
      lastKeyboardFrame = keyboardFrame
      
      let keyboardTop: CGFloat = UIScreen.main.bounds.size.height - keyboardFrame.size.height;
      
      // 編集中セルのbottomを取得
      let cell: TestCell = TestTableView.cellForRow(at: NSIndexPath(row: editingPath.row, section: editingPath.section) as IndexPath) as! TestCell
      //let cell: TestCell = TestTableView.cellForRow(at: NSIndexPath(row: 12, section: 0) as IndexPath) as! TestCell
      let cellBottom: CGFloat
      cellBottom = cell.frame.origin.y - TestTableView.contentOffset.y + cell.frame.size.height;
      
      // 編集中セルのbottomがkeyboardのtopより下にある場合
      if keyboardTop < cellBottom {
        // 編集中セルをKeyboardの上へ移動させる
        let newOffset: CGPoint = CGPoint(x: TestTableView.contentOffset.x, y: TestTableView.contentOffset.y + cellBottom - keyboardTop)
        TestTableView.setContentOffset(newOffset, animated: true)
      }
    } else {
      // 画面を下に戻す
      let newSize: CGSize = CGSize(width: TestTableView.contentSize.width, height: TestTableView.contentSize.height - lastKeyboardFrame.size.height)
      TestTableView.contentSize = newSize
      TestTableView.scrollToRow(at: editingPath as IndexPath, at: UITableView.ScrollPosition.none, animated: true)
      //TestTableView.scrollToRow(at: NSIndexPath(row: 12, section: 0) as IndexPath, at: UITableView.ScrollPosition.none, animated: true)
      lastKeyboardFrame = CGRect.zero;
    }
  }
  
}
