//
//  ShowDiaryViewController.swift
//  2014111516KMH-Project02
//
//  Created by SWUCOMPUTER on 2018. 5. 20..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class ShowDiaryViewController: UIViewController {
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var viewRate: CosmosView!
    @IBOutlet var labelDate: UILabel!
    @IBOutlet var labelGenre: UILabel!
    @IBOutlet var textReview: UILabel!
    var showCultureDiary: NSManagedObject?
//    var isShare: Bool = false
//    @IBOutlet var buttonLike: UIButton!
//    @IBOutlet var labelLike: UILabel!
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = showCultureDiary?.value(forKey: "title") as? String
        
            labelTitle.text = showCultureDiary?.value(forKey: "title") as? String
            labelDate.text = showCultureDiary?.value(forKey: "date") as? String
            labelGenre.text = showCultureDiary?.value(forKey: "genre") as? String
            viewRate.rating = (showCultureDiary?.value(forKey: "rate") as? Double)!
            textReview.text = showCultureDiary?.value(forKey: "review") as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        let alert = UIAlertController(title:"삭제하시겠습니까?",message: "",preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { action in
            // Core Data 내의 해당 자료 삭제
            let context = self.getContext()
            context.delete(self.showCultureDiary!)
            do {
                try context.save()
                print("deleted!")
            } catch let error as NSError {
                print("Could not delete \(error), \(error.userInfo)") }
            
            // 서버에서 삭제
            let urlString: String = "http://condi.swu.ac.kr/student/T02iphone/deleteDiary.php"
            guard let requestURL = URL(string: urlString) else {return}
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            guard let userid = appDelegate.userid else{return}
            
            let restString: String = "userid=" + userid + "&title=" + self.labelTitle.text!
            
            request.httpBody = restString.data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else {return}
                guard let receivedData = responseData else { return }
                if let utf8Data = String(data: receivedData, encoding: .utf8) { print(utf8Data) }
                
            }
            task.resume()
            // 현재의 View를 없애고 이전 화면으로 복귀
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func buttonShare(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message:"공유하시겠습니까?", preferredStyle: .actionSheet)

        // actionSheet 에 공유하기 버튼 누르면
        // server DB에 저장
        alertController.addAction(UIAlertAction(title: "공유하기", style: .default, handler: { action in
            let urlString: String = "http://condi.swu.ac.kr/student/T02iphone/shareDiary.php"
            guard let requestURL = URL(string: urlString) else{ return }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            guard let userid = appDelegate.userid else{ return }

            var restString: String = "userid=" + userid + "&title=" + self.labelTitle.text!
            restString += "&date=" + self.labelDate.text! + "&genre=" + self.labelGenre.text!
            restString += "&rate=" + String(self.viewRate.rating) + "&review=" + self.textReview.text!

            request.httpBody = restString.data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else { return }
                guard let receivedData = responseData else { return }
                if let utf8Data = String(data: receivedData, encoding: .utf8) { print(utf8Data) }
            }
            task.resume()
            
        }))

        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
