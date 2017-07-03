//
//  ChatVC.swift
//  testChat
//
//  Created by Shalom Owolabi on 03/07/2017.
//  Copyright © 2017 SpotPin. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

final class ChatVC: JSQMessagesViewController {

    var channelRef: DatabaseReference?
    var channel: Channel? {
        didSet {
            title = channel?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.senderId = Auth.auth().currentUser?.uid
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    

}
