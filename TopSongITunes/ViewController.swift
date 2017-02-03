//
//  ViewController.swift
//  TopSongITunes
//
//  Created by LuanNX on 1/29/17.
//  Copyright © 2017 LuanNX. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
   
    var songArray = [String]()
    var priceArray = [String]()
    var artistArray = [String]()
    var imageLinkArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //1.Create URL
        let stringUrl:String = "https://itunes.apple.com/us/rss/topsongs/limit=50/genre=1/explicit=true/json"
        let url = URL(string: stringUrl)
        
        //2.Crate Data Task
        let dataTask = URLSession.shared.dataTask(with: url!)
        { (data,response,error) in
            //Handle error
           
            if (error != nil){
                print(error)
                return
            }
            //Handle Result if success
            do {
                
                
                let jsonObject = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as!
                Dictionary<String,Any>
                let feed = jsonObject["feed"] as! Dictionary<String,Any>
                let entry = feed["entry"] as! Array<Dictionary<String,Any>>
                for item in entry{
                    
                let name = item["im:name"] as! Dictionary<String,Any>
                let nameLabel = name["label"] as! String
                    
                self.songArray.append(nameLabel)
                let price = item["im:price"] as! Dictionary<String,Any>
                let priceLabel =  price["label"] as! String
                self.priceArray.append(priceLabel)
                let artist = item["im:artist"] as! Dictionary<String,Any>
                let artistLabel =  artist["label"] as! String
                self.artistArray.append(artistLabel)
                let imageLink = item["im:image"] as! Array<Dictionary<String,Any>>
                let fisrtImageLink = imageLink[0]
                let imageLinkLabel = fisrtImageLink["label"] as! String
                self.imageLinkArray.append(imageLinkLabel)
            
                }
                
                
            } catch let myJSONError {
                
                
                print(myJSONError)
                
                
            }
            
            self.tableView.reloadData()
            

        }
        print(self.songArray.count)
        dataTask.resume()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if songArray.count == 0 {
            return 1
        }else {
        return 50
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let nameLabel = cell.contentView.viewWithTag(101) as! UILabel
        let priceButton = cell.contentView.viewWithTag(102) as! UIButton
        let artistLabel = cell.contentView.viewWithTag(103) as! UILabel
        let imageView = cell.contentView.viewWithTag(104) as! UIImageView
        
        if songArray.count > 0 {
            nameLabel.text = songArray[indexPath.row]
        }
        if priceArray.count > 0 {
            priceButton.setTitle("\(priceArray[indexPath.row])", for: .normal)
            priceButton.layer.borderWidth = 2
            priceButton.layer.cornerRadius = 5
            priceButton.layer.masksToBounds = true
        }
        
        if artistArray.count > 0 {
            artistLabel.text = artistArray[indexPath.row]
        }
        if imageLinkArray.count > 0 {
            let url = URL(string: "\(imageLinkArray[indexPath.row])")
            imageView.downloadedFrom(url: url!, contentMode: UIViewContentMode.scaleAspectFill)
        }
        
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

