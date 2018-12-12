//
//  TestCell.swift
//  TableViewKeyboardTest
//
//  Created by ユーザー１ on 2018/10/27.
//  Copyright © 2018 Masaya Ujihara. All rights reserved.
//

import UIKit

var selectedIndexPath = 0

class TestCell: UITableViewCell, UITextFieldDelegate {
  
  @IBOutlet weak var TestTextField: UITextField!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    TestTextField.delegate = self
  }
  
  //(TextField: UITextField) から (_ TextField: UITextField)にしたら反応した。なぜ？同名の関数と区別できたから？
  internal func textFieldDidBeginEditing(_ textField: UITextField) {
    selectedIndexPath = self.TestTextField.tag
  }
  
  func textFieldShouldReturn(_ TextField: UITextField) -> Bool {
    TestTextField.resignFirstResponder()
    
    return true
  }
  
}
