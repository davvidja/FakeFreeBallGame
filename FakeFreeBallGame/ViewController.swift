//
//  ViewController.swift
//  FakeFreeBallGame
//
//  Created by Carina Macia on 29/11/14.
//  Copyright (c) 2014 Our company. All rights reserved.
//

import UIKit
import GameApplicationLayer

class ViewController: UIViewController, GAServerDelegate, GAClientDelegate {
    var gameServer : GAServer?
    var gameClient: GAClient?
    var actingAsServer: Bool?
    var actingAsClient: Bool?
    
    @IBOutlet var displayNameTextField :UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        gameServer = GAServer ()
        gameServer!.delegate = self
        
        gameClient = GAClient ()
        gameClient!.delegate = self
        
        actingAsClient = false
        actingAsServer = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func initGameServer(){
        gameServer!.initGameServer(self.displayNameTextField!.text)
        println("initGameServer")
    }

    @IBAction func startGameServer(){
        gameServer!.startGameServer()
        actingAsServer = true
        println("startGameServer")
    }

    @IBAction func initGameClient(){
        gameClient!.initGameClient(self.displayNameTextField!.text)
        actingAsClient = true
        println("initGameClient")
    }
    
    @IBAction func startGameClient(){
        gameClient!.startGameClient(self)
        println("startGameClient")
    }
    
    @IBAction func sendNode(){
        var buffer: UInt8 = 1
//        gameServer!.sendData(&buffer, maxlength: 1)
        gameServer!.sendNode()
        println("send Node")
    }
    
    //Methods of the GAServerDelegate protocol
    func player(#peerPlayer: String!, didChangeStateTo newState: GAPlayerConnectionState){
        println("ViewController> Player \(peerPlayer) change estate to \(self.stringForPeerConnectionState(newState))")
    }
    
    //Methods of the GAClientDelegate protocol
    func didReceiveScene(){
        println("ViewController> didReceiveScene")
    }
    
    func didReceiveNode(){
        println("ViewController> didReceiveNode")
    }
    
    func didReceiveNodeAction(){
        println("ViewController> didReceiveNodeAction")
    }
    
    func didReceiveGamePause(){
        println("ViewController> didReceiveGamePause")
    }
    
    
    //
    func applicationDidEnterBackground(){
        println("ViewController>: application did enter in Background")
        if (actingAsServer!){
            gameServer!.stopGameServer()
        }
        if (actingAsClient!){
            gameClient!.stopGameClient()
        }
    }
    
    func applicationWillTerminate(){
        println("ViewController>: application will terminate")
        if (actingAsServer!){
            gameServer!.stopGameServer()
        }
        if (actingAsClient!){
            gameClient!.stopGameClient()
        }
    }
    
    // Helper method for human readable printing of GAPlayerConnectionState.  This state is per peer.
    func stringForPeerConnectionState(state: GAPlayerConnectionState)->String{
        switch(state){
        case GAPlayerConnectionState.GAPlayerConnectionStateConnected:
            return "Connected";
            
        case GAPlayerConnectionState.GAPlayerConnectionStateNotConnected:
            return "Not Connected";
            
        }
    }
}

