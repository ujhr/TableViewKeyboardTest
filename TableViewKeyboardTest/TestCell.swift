//
//  TestCell.swift
//  TableViewKeyboardTest
//
//  Created by ユーザー１ on 2018/10/27.
//  Copyright © 2018 Masaya Ujihara. All rights reserved.
//

import UIKit

protocol TestCellDelegate {
  // 追加
  func textFieldDidBeginEditing(cell: TestCell, value: NSString) -> ()
}

class TestCell: UITableViewCell, UITextFieldDelegate {
  
  var delegate: TestCellDelegate! = nil
  
  @IBOutlet weak var TestTextField: UITextField!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    TestTextField.delegate = self
  }
  
  func textFieldShouldReturn(_ TextField: UITextField) -> Bool {
    
    TestTextField.resignFirstResponder()
    
    return true
  }
  
  internal func textFieldDidBeginEditing(textField: UITextField) {
    self.delegate.textFieldDidBeginEditing(cell: self, value: textField.text! as NSString)
  }
  
}
