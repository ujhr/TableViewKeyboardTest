//
//  TestCell.swift
//  TableViewKeyboardTest
//
//  Created by ユーザー１ on 2018/10/27.
//  Copyright © 2018 Masaya Ujihara. All rights reserved.
//

import UIKit

protocol TestCellDelegate {
  func textFieldDidBeginEditing(cell: TestCell, value: NSString) -> ()
}

class TestCell: UITableViewCell, UITextFieldDelegate {
  
  var delegate: TestCellDelegate? = nil
  
  //　オリジナルで追加　必要ない？
  //func textFieldDidBegin() {
  //  return delegate.textFieldDidBeginEditing(cell: self, value: TestTextField.text! as NSString)
  //}
  
  @IBOutlet weak var TestTextField: UITextField!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    TestTextField.delegate = self
    
    self.delegate = TestView() as! TestCellDelegate
  }
  
  //(TextField: UITextField) から (_ TextField: UITextField)にしたら反応した。なぜ？同名の関数と区別できたから？
  internal func textFieldDidBeginEditing(_ textField: UITextField) {
    self.delegate?.textFieldDidBeginEditing(cell: self, value: TestTextField.text! as NSString)
    //self.delegate?.textFieldDidBeginEditing(cell: self)
    //textFieldDidBegin()
    print("success")
  }
  
  func textFieldShouldReturn(_ TextField: UITextField) -> Bool {
    
    TestTextField.resignFirstResponder()
    
    return true
  }
  
  
}
