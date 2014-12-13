//
//  ViewController.swift
//  FakeFreeBallGame
//
//  Created by Carina Macia on 29/11/14.
//  Copyright (c) 2014 Our company. All rights reserved.
//

import UIKit
import GameApplicationLayer

class ViewController: UIViewController {
    var gameServer : GAServer?
    var gameClient: GAClient?
    var actingAsServer: Bool?
    var actingAsClient: Bool?
    
    @IBOutlet var displayNameTextField :UITextField?
    @IBOutlet var sceneIDTextField :UITextField?
    @IBOutlet var nodeIDNameTextField :UITextField?
    
    @IBOutlet var positionCoordinates: Array<UITextField>?
    @IBOutlet var directionCoordinates: Array<UITextField>?
    
    @IBOutlet var speed: UITextField?

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
    
    @IBAction func sendScene(){
        var scene = GAPScene()
        
        if (self.sceneIDTextField!.text == ""){
            println("ViewController> Scene ID blank. Fill the field")
        } else {
            if (self.sceneIDTextField!.text.toInt()!>255){
                println("ViewController> Scene ID should be <= 255")
            } else {
                scene.sceneIdentifier = UInt8(self.sceneIDTextField!.text.toInt()!)
                
                gameServer!.sendScene(scene)
                println("ViewController> send scene finished")
            }
        }
    }
    
    @IBAction func sendNode(){
        var node = GAPNode()
        
        if (self.nodeIDNameTextField!.text == ""){
            println("ViewController> Node ID blank. Fill the field")
        } else {
            if (self.nodeIDNameTextField!.text.toInt()!>255){
                println("ViewController> Node ID should be <= 255")
            } else {
                node.nodeIdentifier = UInt8(self.nodeIDNameTextField!.text.toInt()!)
            
                gameServer!.sendNode(node)
                
                println("ViewController> send Node finished")
            }
        }
    }
    
    @IBAction func sendNodeaction(){
        var nodeaction :GAPNodeAction
        
        if (self.nodeIDNameTextField!.text == ""){
            println("ViewController> Node ID blank. Fill the field")
        } else {
            if (self.nodeIDNameTextField!.text.toInt()!>255){
                println("ViewController> Node ID should be <= 255")
            } else {
                nodeaction = GAPNodeAction()
                
                nodeaction.nodeIdentifier = UInt16(self.nodeIDNameTextField!.text.toInt()!)
                
                nodeaction.startPoint = ScenePoint(coordinates: map(positionCoordinates!, positionCoordinatesToInt16))
                                
                nodeaction.direction = Vector3D(vectorComponents: map(directionCoordinates!, positionCoordinatesToInt16))
                
                nodeaction.speed = NSString(string: speed!.text).floatValue
                
                
                gameServer!.sendNodeAction(nodeaction)
                
                println("ViewController> send Nodeaction finished")
            }
        }
    }
    
    func positionCoordinatesToInt16(textFieldCoordinate: UITextField) ->Int16{
        return Int16(textFieldCoordinate.text.toInt()!)
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

extension ViewController: GAClientDelegate{
    func didReceiveScene(scene: GAPScene){
        println("ViewController> didReceiveScene with identifier \(scene.sceneIdentifier)")
        self.sceneIDTextField!.text = String(scene.sceneIdentifier)
    }
    
    func didReceiveNode(node: GAPNode){
        println("ViewController> didReceiveNode with identifier \(node.nodeIdentifier)")
        self.nodeIDNameTextField!.text = String(node.nodeIdentifier)
    }
    
    func didReceiveNodeAction(nodeaction: GAPNodeAction){
        println("ViewController> didReceiveNodeAction")
        self.nodeIDNameTextField!.text = String(nodeaction.nodeIdentifier)
        
//        self.positionCoordinates![0].text = map(nodeaction.startPoint.getCoordinates()[0] , positionCoordinatesToString)
//        self.positionCoordinates![1].text = map(nodeaction.startPoint.getCoordinates()[1] , positionCoordinatesToString)
//        self.positionCoordinates![2].text = map(nodeaction.startPoint.getCoordinates()[2] , positionCoordinatesToString)
        self.positionCoordinates![0].text = String(nodeaction.startPoint.getCoordinates()[0])
        self.positionCoordinates![1].text = String(nodeaction.startPoint.getCoordinates()[1])
        self.positionCoordinates![2].text = String(nodeaction.startPoint.getCoordinates()[2])
        
        self.directionCoordinates![0].text = String(nodeaction.direction.getVectorComponents()[0])
        self.directionCoordinates![1].text = String(nodeaction.direction.getVectorComponents()[1])
        self.directionCoordinates![2].text = String(nodeaction.direction.getVectorComponents()[2])
        
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        // Configure the number formatter to your liking
        self.speed!.text = nf.stringFromNumber(nodeaction.speed)
        
        
    }
    
    func positionCoordinatesToString(int16Coordinate: Int16) ->String{
        return String(int16Coordinate)
    }
    
    
    
    func didReceiveGamePause(){
        println("ViewController> didReceiveGamePause")
    }
}

extension ViewController: GAServerDelegate{
    func player(#peerPlayer: String!, didChangeStateTo newState: GAPlayerConnectionState){
        println("ViewController> Player \(peerPlayer) change state to \(self.stringForPeerConnectionState(newState))")
    }
}

