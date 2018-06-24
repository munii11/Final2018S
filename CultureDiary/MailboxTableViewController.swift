//
//  MailboxTableViewController.swift
//  CultureDiary
//
//  Created by SWUCOMPUTER on 2018. 6. 15..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class MailboxTableViewController: UITableViewController {
    var targetedUserId:[FriendRequest] = Array()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        targetedUserId = [] // 배열을 초기화하고 서버에서 자료를 다시 가져옴
        self.downloadDataFromServer()
    }
    
    func downloadDataFromServer() -> Void {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let userid = appDelegate.userid else{ return }
        
        let urlString: String = "http://condi.swu.ac.kr/student/T02iphone/selectRequest.php"
        guard let requestURL = URL(string: urlString) else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let restString: String = "userid=" + userid
        request.httpBody = restString.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { print("Error: calling POST"); return; }
            guard let receivedData = responseData else {
                print("Error: not receiving Data"); return; }
            let response = response as! HTTPURLResponse
            if !(200...299 ~= response.statusCode) { print("HTTP response Error!"); return; }
            do {
                if let jsonData = try JSONSerialization.jsonObject (with: receivedData,options:.allowFragments) as? [[String: Any]] {
                    for i in 0...jsonData.count-1 {
                        let newData: FriendRequest = FriendRequest()
                        var jsonElement = jsonData[i]
                        newData.userid = jsonElement["userid"] as! String
                        self.targetedUserId.append(newData)
                    }
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
            } catch { print("Error:") } }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        // #warning Incomplete implementation, return the number of rows
        return targetedUserId.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Mailbox Cell", for: indexPath)

        // Configure the cell...
        let item = targetedUserId[indexPath.row]
        cell.textLabel?.text = item.userid + "에게 친구요청이 왔습니다!"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.dequeueReusableCell(withIdentifier: "Mailbox Cell", for: indexPath)
        
        let alert = UIAlertController(title:"수락하기",message: "",preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "수락", style: .cancel, handler: { action in
            let urlString: String = "http://condi.swu.ac.kr/student/T02iphone/addFriends.php"
            guard let requestURL = URL(string: urlString) else{ return }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            guard let userid = appDelegate.userid else{ return }
            let item = self.targetedUserId[indexPath.row]
            let req_id = item.userid
            
            let restString: String = "userid=" + req_id + "&target_id=" + userid
            request.httpBody = restString.data(using: .utf8)
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else { return }
                guard let receivedData = responseData else { return }
                if let utf8Data = String(data: receivedData, encoding: .utf8) { print(utf8Data) }
            }
            task.resume()
            
            self.targetedUserId.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }))
        alert.addAction(UIAlertAction(title: "거절", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
