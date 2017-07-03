//
//  ChannelVC.swift
//  testChat
//
//  Created by Shalom Owolabi on 03/07/2017.
//  Copyright © 2017 SpotPin. All rights reserved.
//

import UIKit
import Firebase

enum Section: Int {
    case createNewChannelSection = 0
    case currentChannelsSection
}

class ChannelVC: UITableViewController {

    // MARK: Properties
    var senderDisplayName: String?
    var newChannelTextField: UITextField?
    private var channels: [Channel] = []
    private var channelRef: DatabaseReference = Database.database().reference().child("channels")
    private var channelRefHandle: DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "testChat"
        observeChannels()
    }
    
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    @IBAction func createChannel(_ sender: Any) {
        
        if let name = newChannelTextField?.text {
            let newChannelRef = channelRef.childByAutoId()
            let channelItem = [
                "name": name
            ]
            newChannelRef.setValue(channelItem)
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentSection: Section = Section(rawValue: section) {
            switch currentSection {
            case .createNewChannelSection:
                return 1
            case .currentChannelsSection:
                return channels.count
            }
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = (indexPath as IndexPath).section == Section.createNewChannelSection.rawValue ? "NewChannel" : "ExistingChannel"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if (indexPath as IndexPath).section == Section.createNewChannelSection.rawValue {
            if let createNewChannelCell = cell as? CreateChannelCell {
                newChannelTextField = createNewChannelCell.newChannelNameField
            }
        } else if (indexPath as IndexPath).section == Section.currentChannelsSection.rawValue {
            cell.textLabel?.text = channels[(indexPath as IndexPath).row].name
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == Section.currentChannelsSection.rawValue {
            let channel = channels[(indexPath as NSIndexPath).row]
            self.performSegue(withIdentifier: "yellow", sender: channel)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let channel = sender as? Channel {
            let chatVc = segue.destination as! ChatVC
            
            chatVc.senderDisplayName = senderDisplayName
            chatVc.channel = channel
            chatVc.channelRef = channelRef.child(channel.id)
        }
        
    }
    
    private func observeChannels() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in // 1
            let channelData = snapshot.value as! Dictionary<String, AnyObject> // 2
            let id = snapshot.key
            if let name = channelData["name"] as! String!, name.characters.count > 0 { // 3
                self.channels.append(Channel(id: id, name: name))
                self.tableView.reloadData()
            } else {
                print("Error! Could not decode channel data")
            }
        })
    }

}
