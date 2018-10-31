//
//  TestView.swift
//  TableViewKeyboardTest
//
//  Created by ユーザー１ on 2018/10/27.
//  Copyright © 2018 Masaya Ujihara. All rights reserved.
//

import UIKit

class TestView: UIViewController, UITableViewDelegate, UITableViewDataSource, TestCellDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return 15
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath) as! TestCell
    //cell.textLabel?.text = "カテゴリーを追加する"
    
    //cell.imageView!.image = UIImage(named: "PlusButton4")
    
    return cell
  }
  
  @IBOutlet weak var TestTableView: UITableView!
  
  var lastKeyboardFrame: CGRect = CGRect.zero
  var editingPath: NSIndexPath!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    registerNotification()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unregisterNotification()
  }
  
  // MARK: - Keyboard
  // 通知登録処理
  func registerNotification() -> () {
    let center: NotificationCenter = NotificationCenter.default
    center.addObserver(TestCell(), selector: Selector(("keyboardWillShow:")), name: UIResponder.keyboardWillShowNotification, object: nil)
    center.addObserver(TestCell(), selector: Selector(("keyboardWillHide:")), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  // 通知登録解除処理
  func unregisterNotification() -> () {
    let center: NotificationCenter = NotificationCenter.default
    center.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  // Keyboard表示前処理
  func keyboardWillShow(notification: NSNotification) -> () {
    scrollTableCell(notification: notification, showKeyboard: true)
  }
  
  // Keyboard非表示前処理
  func keyboardWillHide(notification: NSNotification) -> () {
    scrollTableCell(notification: notification, showKeyboard: false)
  }
  
  // TableViewCellをKeyboardの上までスクロールする処理
  func scrollTableCell(notification: NSNotification, showKeyboard: Bool) -> () {
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
      
      // keyboardのtopを取得
      let keyboardTop: CGFloat = UIScreen.main.bounds.size.height - keyboardFrame.size.height;
      
      // 編集中セルのbottomを取得
      let cell: TestCell = TestTableView.cellForRow(at: NSIndexPath(row: editingPath.row, section: editingPath.section) as IndexPath) as! TestCell
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
      lastKeyboardFrame = CGRect.zero;
    }
  }
  
  func textFieldDidBeginEditing(cell: TestCell, value: NSString) -> () {
    let path = TestTableView.indexPathForRow(at: cell.convert(cell.bounds.origin, to: TestTableView))
    editingPath = path as! NSIndexPath
  
  
}
}
