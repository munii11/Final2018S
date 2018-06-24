//
//  DiaryTableViewController.swift
//  2014111516KMH-Project02
//
//  Created by SWUCOMPUTER on 2018. 5. 20..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class DiaryTableViewController: UITableViewController {
    var cultureDiaries: [NSManagedObject] = []
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    // View가 보여질 때 자료를 DB에서 가져오도록 한다
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CultureDiaries")
        do {
        cultureDiaries = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)") }
        self.tableView.reloadData()
        
        //isExistInServer()
        
//        self.isExistInServer()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 120
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toReadView" {
            if let destination = segue.destination as? ShowDiaryViewController {
                if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row {
                    destination.showCultureDiary = cultureDiaries[selectedIndex]
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //        return cultureDiaries.count
        return cultureDiaries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryCell", for: indexPath) as! DiaryTableViewCell
        
        // Configure the cell...
        let cultureDiary = cultureDiaries[indexPath.row]
        if let titleLabel = cultureDiary.value(forKey: "title") as? String {
            cell.labelTitle?.text = titleLabel
        }
        if let dateLabel = cultureDiary.value(forKey: "date") as? String {
            cell.labelDate?.text = dateLabel
        }
        if let reviewLable = cultureDiary.value(forKey: "review") as? String {
            cell.labelReview?.text = reviewLable
        }
        if let ratingView = cultureDiary.value(forKey: "rate") as? Double {
            cell.viewRate?.rating = ratingView
        }
        if let genreView = cultureDiary.value(forKey: "genre") as? String{
            if genreView == "영화"{
                cell.genreImageView?.image = #imageLiteral(resourceName: "movie.png")
            }else if genreView == "도서"{
                cell.genreImageView?.image = #imageLiteral(resourceName: "book.png")
            }else if genreView == "연극/뮤지컬/발레"{
                cell.genreImageView?.image = #imageLiteral(resourceName: "theatre.png")
            }else if genreView == "음악회/오페라" {
                cell.genreImageView?.image = #imageLiteral(resourceName: "music.png")
            }else if genreView == "콘서트" {
                cell.genreImageView?.image = #imageLiteral(resourceName: "concert.png")
            }else if genreView == "전시회" {
                cell.genreImageView?.image = #imageLiteral(resourceName: "exhibition.png")
            }else if genreView == "기타" {
                cell.genreImageView?.image = #imageLiteral(resourceName: "more.png")
            }
        }
        //cell.isExistInServer()
        
        return cell
    }
    
    
    // 공유된 글의 '좋아요'수를 카운트하는 함수
    func countLike() {
        // culture_diary 에서 userid && title 검색해서 카운트
    }
    
    // 공유된 글의 '댓글' 수를 카운트하는 함수
    func countComment() {
        // comment DB 에서 일기장id 검색해서 카운트
    }
    
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
    
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
        // Core Data 내의 해당 자료 삭제
        let context = getContext()
        context.delete(cultureDiaries[indexPath.row])
        do {
            try context.save()
            print("deleted!")
        } catch let error as NSError {
            print("Could not delete \(error), \(error.userInfo)") }
        // 배열에서 해당 자료 삭제
        cultureDiaries.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
    
    @IBAction func buttonLogout(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title:"로그아웃 하시겠습니까?",message: "",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            let urlString: String = "http://condi.swu.ac.kr/student/T02iphone/logout.php"
            guard let requestURL = URL(string: urlString) else { return }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else { return } }
            task.resume()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginView = storyboard.instantiateViewController(withIdentifier: "LoginView")
            self.present(loginView, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}
