//
//  WriteDiaryViewController.swift
//  2014111516KMH-Project02
//
//  Created by SWUCOMPUTER on 2018. 5. 20..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class WriteDiaryViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet var textTitle: UITextField!
    @IBOutlet var textGenre: UITextField!
    @IBOutlet var textDate: UITextField!
    @IBOutlet var labelRate: UILabel!
    @IBOutlet var textReview: UITextView!
    @IBOutlet var cosmosViewRate: CosmosView!
    
    var pickGenre = ["영화","도서","연극/뮤지컬/발레","음악회/오페라","콘서트","전시회","기타"]
    let datePicker = UIDatePicker()
    let genrePicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genrePicker.delegate = self
        
        // genrePicker 툴바 생성
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        // 툴바에 done버튼 생성
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain,
                                         target: self, action: #selector(genreDonePressed))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textGenre.inputView = genrePicker
        textGenre.inputAccessoryView = toolBar
        
        createDatePicker()
        
        cosmosViewRate.didTouchCosmos = didTouchCosmos
        cosmosViewRate.didFinishTouchingCosmos = didFinishTouchingCosmos
        updateRating()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickGenre.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickGenre[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textGenre.text = pickGenre[row]
    }
    
    // DatePicker
    // 날짜 텍스트뷰를 누르면 datePicker가 뜨고 날짜 설정가능
    // datePicker 위 툴바에 done 아이템이 있음
    func createDatePicker(){
        //format for picker
        datePicker.datePickerMode = .date
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: nil, action: #selector(dateDonePressed))
        toolbar.setItems([doneButton], animated: false)
        
        textDate.inputAccessoryView = toolbar
        
        //assigning date picker to text field
        textDate.inputView = datePicker
    }
    @objc func dateDonePressed(){
        //format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        let dateString = formatter.string(from: datePicker.date)
        textDate.text = "\(dateString)"
        
        self.view.endEditing(true)
    }
    @objc func genreDonePressed(){
        let indexPath = genrePicker.selectedRow(inComponent: 0)
        textGenre.text = pickGenre[indexPath]
        
        self.view.endEditing(true)
    }
    
    // 별점 설정하기
    private func updateRating() {
        self.labelRate.text = "\(cosmosViewRate.rating)"
    }
    private class func formatValue(_ value: Double) -> String {
        return String(format: "%.2f", value)
    }
    private func didTouchCosmos(_ rating: Double) {
        labelRate.text = "\(cosmosViewRate.rating)"
    }
    private func didFinishTouchingCosmos(_ rating: Double) {
        self.labelRate.text = "\(cosmosViewRate.rating)"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textTitle {
            textField.resignFirstResponder()
            self.textDate.becomeFirstResponder()
        }else if textField == self.textDate {
            textField.resignFirstResponder()
            self.textGenre.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    @IBAction func buttonSave(_ sender: UIBarButtonItem) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "CultureDiaries", in: context)
        
        // Culture Diary record를 새로 생성함
        let object = NSManagedObject(entity: entity!, insertInto: context)
        object.setValue(textTitle.text, forKey: "title")
        object.setValue(textDate.text, forKey: "date")
        object.setValue(textGenre.text, forKey: "genre")
        object.setValue(cosmosViewRate.rating, forKey: "rate")
        object.setValue(textReview.text, forKey: "review")
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)") }
        // 현재의 View를 없애고 이전 화면으로 복귀
        self.navigationController?.popViewController(animated: true)
    }
}

