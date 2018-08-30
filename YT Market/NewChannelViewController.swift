//
//  NewChannelViewController.swift
//  YT Market
//
//  Created by Adam Eliezerov on 27/08/2018.
//  Copyright © 2018 Adam Eliezerov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class NewChannelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var channelArray = [SearchChannel]()
    var selectedChannel = SearchChannel(channelName: "", thumbnailURL: "", subCount: 0, channelID: "", channelDesc: "")

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return channelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "Cell") as! TableCell
        cell.channelNameLabel.text = channelArray[indexPath.row].channelName1
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:channelArray[indexPath.row].subCount1))
        cell.subCountLabel.text = formattedNumber
        let urlString = channelArray[indexPath.row].thumbnailURL1
        let url = URL(string: urlString)
        if url == nil {
            print("nil")
        } else {
            cell.activityIndicator.startAnimating()
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error != nil {
                    print("Failed fetching image:", error)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Not a proper HTTPURLResponse or statusCode")
                    return
                }
                
                DispatchQueue.main.async {
                    //activity indicator manage
                    cell.channelImageView.image = UIImage(data: data!)
                    cell.activityIndicator.stopAnimating()
                    cell.activityIndicator.isHidden = true
                }
                }.resume()
            }
        if indexPath.row == channelArray.count {
            channelArray = []
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedChannel.channelName1 = channelArray[indexPath.row].channelName1
        selectedChannel.subCount1 = channelArray[indexPath.row].subCount1
        selectedChannel.thumbnailURL1 = channelArray[indexPath.row].thumbnailURL1
        selectedChannel.channelID1 = channelArray[indexPath.row].channelID1
        selectedChannel.channelDesc1 = channelArray[indexPath.row].channelDesc1
        self.performSegue(withIdentifier: "goToInfo", sender: self)
        table.deselectRow(at: indexPath, animated: false)
    }

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getData(query: searchBar.text!)
        self.view.endEditing(true)
    }
    
    let apiKey = "AIzaSyA31Aj4CG_qJOuVtzqRD_eUnWHdq2q1xBk"
    
    func getData(query: String) {
        channelArray = []
        table.reloadData()
        let original = "https://www.googleapis.com/youtube/v3/search?type=channel&q=\(query)&maxResults=25&part=snippet&key=\(apiKey)"
        let yt = original.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: yt!)
        let urlRequest = URLRequest(url: url!)
        Alamofire.request(urlRequest)
            .responseJSON { response in
                // do stuff with the JSON or error
                
                if let jsonData = response.result.value {
                    let data = JSON(jsonData)
                    for i in 0...24 {
                        let title = data["items"][i]["snippet"]["title"]
                        let channelID = data["items"][i]["id"]["channelId"]
                        let thumbnailURL = data["items"][i]["snippet"]["thumbnails"]["high"]["url"]
                        print(title)
                        print(channelID)
                        print(thumbnailURL)
                        let subCountURL = "https://www.googleapis.com/youtube/v3/channels?part=statistics%2Csnippet&id=\(channelID)&key=\(self.apiKey)"
                        let otherUrl = URL(string: subCountURL)
                        let urlRequest = URLRequest(url: otherUrl!)
                        Alamofire.request(urlRequest)
                            .responseJSON { response in
                                // do stuff with the JSON or error
                                if let jsonData = response.result.value {
                                    let data = JSON(jsonData)
                                    let subCount = data["items"][0]["statistics"]["subscriberCount"].intValue
                                    let description = data["items"][0]["snippet"]["description"].stringValue
                                    print(subCount)
                                    self.channelArray.append(SearchChannel(channelName: title.stringValue, thumbnailURL: thumbnailURL.stringValue, subCount: subCount, channelID: channelID.stringValue, channelDesc: description))
                                    self.table.reloadData()
                                    }
                                }
                    }
                    
                    }
                    
                }
    }
    

    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToInfo" {
            if let destVC = segue.destination as? InfoViewController {
                destVC.selectedChannel = selectedChannel
                
            }
        }
    }

}
