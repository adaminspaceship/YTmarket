//
//  InfoViewController.swift
//  YT Market
//
//  Created by Adam Eliezerov on 28/08/2018.
//  Copyright © 2018 Adam Eliezerov. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    var selectedChannel = SearchChannel(channelName: "", thumbnailURL: "", subCount: 0, channelID: "", channelDesc: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        channelNameLabel.text = selectedChannel.channelName1
        let urlString = selectedChannel.thumbnailURL1
        let url = URL(string: urlString)
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
                self.channelThumbnailImage.image = UIImage(data: data!)
            }
            }.resume()
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:selectedChannel.subCount1))
        subscriberCountLabel.text = "$\(formattedNumber!) per share"
        
        if selectedChannel.channelDesc1 == "" {
            channelDescriptionText.text = "This channel doesn't have a description."
        } else {
            channelDescriptionText.text = selectedChannel.channelDesc1
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addToPortfolioButtonTapped(_ sender: Any) {
        let new = CoreDataHelper.newChannel()
        new.initialSubCount = Int32(selectedChannel.subCount1)
        new.channelID = selectedChannel.channelID1
        new.name = selectedChannel.channelName1
        CoreDataHelper.saveChannel()
    }
    @IBOutlet var channelNameLabel: UILabel!
    @IBOutlet var channelThumbnailImage: UIImageView!
    @IBOutlet var subscriberCountLabel: UILabel!
    @IBOutlet var channelDescriptionText: UITextView!
    
    @IBAction func goBackToOneButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
