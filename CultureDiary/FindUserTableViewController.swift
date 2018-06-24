//
//  FindUserTableViewController.swift
//  CultureDiary
//
//  Created by SWUCOMPUTER on 2018. 6. 15..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class FindUserTableViewController: UITableViewController {
    
    var user_array: [UserData] = Array()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        user_array = []                 // 배열을 초기화하고 서버에서 자료를 다시 가져옴
        self.loadUseridFromServer()
    }
    
    func loadUseridFromServer() -> Void {
        let urlString: String = "http://condi.swu.ac.kr/student/T02iphone/loadUser.php"
        guard let requestURL = URL(string: urlString) else { return }
        let request = URLRequest(url: requestURL)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                print("Error: calling POST");
                return;
            }
            guard let receivedData = responseData else {
                print("Error: not receiving Data");
                return;
            }
            let response = response as! HTTPURLResponse
            if !(200...299 ~= response.statusCode) {
                print("HTTP response Error!");
                return;
            }
            do {
                if let jsonData = try JSONSerialization.jsonObject (with: receivedData,options:.allowFragments) as? [[String: Any]] {
                    for i in 0...jsonData.count-1 {
                        let userData: UserData = UserData()
                        var jsonElement = jsonData[i]
                        userData.userid = jsonElement["userid"] as! String
                        userData.name = jsonElement["username"] as! String
                        self.user_array.append(userData)
                    }
                    DispatchQueue.main.async { self.tableView.reloadData() } }
            } catch { print("Error:") } }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return user_array.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FindUserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchUser Cell", for: indexPath) as! FindUserTableViewCell
        let item = user_array[indexPath.row]
        cell.textLabel?.text = item.userid
        cell.requestBtn.tag = indexPath.row
        cell.requestBtn.addTarget(self, action:#selector(FindUserTableViewController.requestBtn(_:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    @objc func requestBtn(_ sender: UIButton) {
        let alert = UIAlertController(title:"친구신청을 보낼까요?",message: "",preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { action in
            let urlString: String = "http://condi.swu.ac.kr/student/T02iphone/add_friend_request.php"
            guard let requestURL = URL(string: urlString) else{ return }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            guard let userid = appDelegate.userid else{ return }

            let myrow = sender
            let indexPath = IndexPath(row: myrow.tag, section: 0)
            var cell = self.tableView.dequeueReusableCell(withIdentifier: "SearchUser Cell", for: indexPath)
            cell = self.tableView.cellForRow(at: indexPath)!
            

            let targetId = cell.textLabel?.text
            let restString: String = "userid=" + userid + "&target_id=" + targetId!
            print(restString)

            request.httpBody = restString.data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else { return }
                guard let receivedData = responseData else { return }
                if let utf8Data = String(data: receivedData, encoding: .utf8) { print(utf8Data) }
            }
            task.resume()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}
