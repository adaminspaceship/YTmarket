//
//  ViewController.swift
//  YT Market
//
//  Created by Adam Eliezerov on 16/08/2018.
//  Copyright © 2018 Adam Eliezerov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var channels = [Channel]()
    var currentSubCount = Int()
    let apiKey = "AIzaSyA31Aj4CG_qJOuVtzqRD_eUnWHdq2q1xBk"
    @IBOutlet var table: UITableView!
    @IBOutlet var coinAmount: UILabel!
    @IBOutlet var potentialCoinAmount: UILabel!
    var currentCoinAmount = Int()
    var potCoinAmount = Int()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        let currentChannel = channels[indexPath.row]
        self.getSubCount(channelID: currentChannel.channelID ?? "UCVtFOytbRpEvzLjvqGG5gxQ", completion: {
                let num = self.currentSubCount-Int(currentChannel.initialSubCount)
                let formattedNumber = numberFormatter.string(from: NSNumber(value:num))
                    if num > 0 {
                        cell.percentChangeLabel.text = "▲ $\(formattedNumber!)"
                        self.potCoinAmount += num
                        cell.percentChangeLabel.textColor = UIColor.green
                    } else if num == 0 {
                        cell.percentChangeLabel.text = "▶ $\(formattedNumber!)"
                        cell.percentChangeLabel.textColor = UIColor.orange
                        self.potCoinAmount += num
                    } else {
                        cell.percentChangeLabel.text = "▼ $\(formattedNumber!)"
                        cell.percentChangeLabel.textColor = UIColor.red
                        self.potCoinAmount += num
                    }
            let otherformatted = numberFormatter.string(from: NSNumber(value:self.currentSubCount))
            cell.subCountLabel.text = "Sub Count: \(otherformatted!)"
            
            self.potentialCoinAmount.text = "$\(self.currentCoinAmount+self.potCoinAmount)"
        })
        
        cell.channelNameLabel.text = currentChannel.name
        //percent calculation
//        let calc = currentSubCount-Int(currentChannel.initialSubCount)
//        if calc > 0 {
//            cell.percentChangeLabel.text = "▲ \(calc/Int(currentChannel.initialSubCount)*100)%"
//            cell.percentChangeLabel.textColor = UIColor.green
//        } else {
//            let number = Double(calc)/Double(currentChannel.initialSubCount)
//            cell.percentChangeLabel.text = "▼ \(number*100)%"
//            cell.percentChangeLabel.textColor = UIColor.red
//        }
        

        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        channels = CoreDataHelper.retrieveChannel()
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:UserDefaults.standard.integer(forKey: "userMoney")))
        coinAmount.text = "$\(formattedNumber!)"
        currentCoinAmount = UserDefaults.standard.integer(forKey: "userMoney")
    }
    
    func getSubCount(channelID: String,completion : @escaping ()->()) {
        let subCountURL = "https://www.googleapis.com/youtube/v3/channels?part=statistics%2Csnippet&id=\(channelID)&key=\(self.apiKey)"
        let otherUrl = URL(string: subCountURL)
        let urlRequest = URLRequest(url: otherUrl!)
        
        Alamofire.request(urlRequest)
            .responseJSON { response in
                // do stuff with the JSON or error
                if let jsonData = response.result.value {
                    let data = JSON(jsonData)
                    let subCountNow = data["items"][0]["statistics"]["subscriberCount"].intValue
                    self.currentSubCount = subCountNow
                    completion()
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    


}

