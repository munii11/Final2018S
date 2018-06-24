//
//  NewsfeedTableViewController.swift
//  CultureDiary
//
//  Created by SWUCOMPUTER on 2018. 6. 18..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class NewsfeedTableViewController: UITableViewController {
    var newsFeedArray: [NewsfeedData] = Array()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 120

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        newsFeedArray = []
        self.downloadNewsfeed()
    }

    func downloadNewsfeed() -> Void {
        let urlString: String = "http://condi.swu.ac.kr/student/T02iphone/NewsFeedTable.php"
        guard let requestURL = URL(string: urlString) else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let userid = appDelegate.userid else{ return }
        
        let restString: String = "userid=" + userid
        request.httpBody = restString.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { print("Error: calling POST"); return; }
            guard let receivedData = responseData else {
                print("Error: not receiving Data"); return; }
            let response = response as! HTTPURLResponse
            if !(200...299 ~= response.statusCode) {print("HTTP response Error!"); return }
            do {
                if let jsonData = try JSONSerialization.jsonObject (with: receivedData,
                                                                    options:.allowFragments) as? [[String: Any]] {
                    for i in 0...jsonData.count-1 {
                        let newData: NewsfeedData = NewsfeedData()
                        var jsonElement = jsonData[i]
                        //newData.index = jsonElement["id"] as! Int
                        newData.userid = jsonElement["userid"] as! String
                        newData.title = jsonElement["title"] as! String
                        newData.date = jsonElement["date"] as! String
                        newData.genre = jsonElement["genre"] as! String
                        newData.rate = jsonElement["rate"] as! String
                        newData.review = jsonElement["review"] as! String
                        self.newsFeedArray.append(newData)
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
        // #warning Incomplete implementation, return the number of rows
        return newsFeedArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeed Cell", for: indexPath) as! NewsfeedTableViewCell

        // Configure the cell...
        let item = newsFeedArray[indexPath.row]
        //cell.textLabel?.text = item.title
        //cell.detailTextLabel?.text = item.date // ----> Right Detail 설정
        cell.friendId.text = item.userid
        cell.friendTitle.text = item.title
        cell.friendRate.rating = Double(item.rate)!
        cell.friendReview.text = item.review
        
        if(item.genre == "영화"){
            cell.friendImage.image = #imageLiteral(resourceName: "movie.png")
        }else if(item.genre == "도서"){
            cell.friendImage.image = #imageLiteral(resourceName: "book.png")
        }else if(item.genre == "연극/뮤지컬/발레"){
            cell.friendImage.image = #imageLiteral(resourceName: "theatre.png")
        }else if(item.genre == "음악회/오페라"){
            cell.friendImage.image = #imageLiteral(resourceName: "music.png")
        }else if(item.genre == "콘서트"){
            cell.friendImage.image = #imageLiteral(resourceName: "concert.png")
        }else if(item.genre == "전시회"){
            cell.friendImage.image = #imageLiteral(resourceName: "exhibition.png")
        }else if(item.genre == "기타"){
            cell.friendImage.image = #imageLiteral(resourceName: "more.png")
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFriendDiaryVC" {
            if let destination = segue.destination as? FriendDiaryViewController {
                if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row {
                    destination.friendDiary = newsFeedArray[selectedIndex]
                }
            }
        }
    }
    

}
