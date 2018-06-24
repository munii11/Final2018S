//
//  DiaryTableViewCell.swift
//  CultureDiary
//
//  Created by SWUCOMPUTER on 2018. 5. 29..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {
    @IBOutlet var labelDate: UILabel!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var viewRate: CosmosView!
    @IBOutlet var labelReview: UILabel!
    @IBOutlet var genreImageView: UIImageView!
//    @IBOutlet var buttonLike: UIButton!
//    @IBOutlet var labelLike: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    func isExistInServer() -> Void {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        guard let userid = appDelegate.userid else{ return }
//        
//        let urlString: String = "http://condi.swu.ac.kr/student/T02iphone/isExist.php"
//        guard let requestURL = URL(string: urlString) else { return }
//        var request = URLRequest(url: requestURL)
//        request.httpMethod = "POST"
//        
//        let restString: String = "userid=" + userid + "&title=" + labelTitle.text!
//        print(restString)
//        
//        request.httpBody = restString.data(using: .utf8)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { (responseData, response, responseError) in
//            guard responseError == nil else { print("Error: calling POST"); return; }
//            guard let receivedData = responseData else { print("Error: not receiving Data"); return; }
//            do{
//                let response = response as! HTTPURLResponse
//                if !(200...299 ~= response.statusCode) {
//                    print ("HTTP Error!")
//                    return
//                }
//                guard let jsonData = try JSONSerialization.jsonObject(with: receivedData, options: .allowFragments) as? [String: Any] else{
//                    print("JSON Serialization Error!")
//                    return
//                }
//                guard let success = jsonData["success"] as! String! else { print("Error: PHP failure(success)")
//                    return
//                }
//                if success == "YES" {
//                    self.buttonLike.isHidden = false
//                    self.labelLike.isHidden = false
//                    //~~~좋아요 댓글 버튼, 라벨 출력!!
//                    
//                }else{
////                    if let errMessage = jsonData["error"] as! String! {
////                        DispatchQueue.main.async{
////
////                        }
////                    }
//                    // 좋아요, 댓글 버튼/라벨 숨기기
//                    self.buttonLike.isHidden = true
//                    self.labelLike.isHidden = true
//                }
//            }catch{
//                print("Error: (error)")
//            }
//        }
//        task.resume()
//    }
    
//    let task = session.dataTask(with: request) { (responseData, response, responseError) in
//        guard responseError == nil else { print("Error: calling POST")
//            return
//        }
//        guard let receivedData = responseData else { print("Error: not receiving Data")
//            return
//        }
//        do {
//            let response = response as! HTTPURLResponse
//            if !(200...299 ~= response.statusCode) {
//                print ("HTTP Error!")
//                return
//            }
//            guard let jsonData = try JSONSerialization.jsonObject(with: receivedData, options:.allowFragments) as? [String: Any] else {
//                print("JSON Serialization Error!")
//                return
//            }
//            guard let success = jsonData["success"] as! String! else { print("Error: PHP failure(success)")
//                return }
//            if success == "YES" {
//                if let name = jsonData["name"] as! String! {
//                    appDelegate.userid = userId
//
//                    DispatchQueue.main.async {
//                        self.labelStatus.text = name + "님 안녕하세요?"
//                        self.performSegue(withIdentifier: "toLoginSuccess", sender: self)
//                    }
//                }
//            } else {
//                if let errMessage = jsonData["error"] as! String! {
//                    DispatchQueue.main.async {
//                        self.labelStatus.text = errMessage }
//                }
//            }
//        } catch {
//            print("Error:  (error)") }
//    }
//    task.resume()


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
