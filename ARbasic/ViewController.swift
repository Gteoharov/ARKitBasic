//
//  ViewController.swift
//  ARbasic
//
//  Created by Georgi Teoharov on 25.06.18.
//  Copyright © 2018 Georgi Teoharov. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var player: AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
    
        singleTapGestureRecognizer()
        swipeGestureRecognizer()
        
        
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        addBox()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @objc private func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            loadMonster()
        }
        if gesture.direction == UISwipeGestureRecognizerDirection.left {
            loadSoldier()
        }
        if gesture.direction == UISwipeGestureRecognizerDirection.down {
            loadGirlDance()
        }
    }
    
    func addBox() {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(0, 0, -0.2)
        
        let scene = SCNScene()
        scene.rootNode.addChildNode(boxNode)
        sceneView.scene = scene
        playMonsterSound()
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "ARMusic", withExtension: ".mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playMonsterSound() {
        guard let url = Bundle.main.url(forResource: "ARMonster", withExtension: ".mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playSouljerSound() {
        guard let url = Bundle.main.url(forResource: "ARSouljer", withExtension: ".mov") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func swipeGestureRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.sceneView.addGestureRecognizer(swipeLeft)
        self.sceneView.addGestureRecognizer(swipeRight)
        self.sceneView.addGestureRecognizer(swipeDown)
    }
    
    private func singleTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
//    @objc func doubleTapped(reconizer: UITapGestureRecognizer) {
//        let tapped = reconizer.view as! SCNView
//        let touchLocation = reconizer.location(in: tapped)
//        let hitTest = tapped.hitTest(touchLocation, options: nil)
//        if !hitTest.isEmpty {
//            guard let touch = hitTest.first else { return }
//            let result = sceneView.hitTest(touch.accessibilityActivationPoint, types: [ARHitTestResult.ResultType.featurePoint])
//            guard let hitResult = result.last else { return }
//            let hitTransform =  SCNMatrix4(hitResult.worldTransform)
//            let hitVector = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
//            createSouljer(position: hitVector)
//        }
//    }
//
    @objc func tapped(recognizer :UITapGestureRecognizer) {
        let tappedView = recognizer.view as! SCNView
        let touchLocation = recognizer.location(in: tappedView)
        let hitTest = tappedView.hitTest(touchLocation, options: nil)
        if !hitTest.isEmpty {
            let result = hitTest.first!
            result.node.removeFromParentNode()
        }
        if player!.isPlaying {
            player?.pause()
        }
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        guard let tocuh = touches.first else { return }
//        let result = sceneView.hitTest(tocuh.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
//        guard let hitResult = result.last else { return }
//        let hitTransform =  SCNMatrix4(hitResult.worldTransform)
//        let hitVector = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
//        createSouljer(position: hitVector)
//
//    }
    
    func loadSoldier() {
        let idleScene = SCNScene(named: "art.scnassets/Inverted Double Kick To Kip Up.dae")!
        let node = SCNNode()
        for child in idleScene.rootNode.childNodes {
            node.addChildNode(child)
        }
        
        node.position = SCNVector3(0, -30, -70)
        node.scale = SCNVector3(0.2, 0.2, 0.2)
        sceneView.scene.rootNode.addChildNode(node)
        playSouljerSound()
    }
    
    func loadMonster() {
        let idleScene = SCNScene(named: "art.scnassets/Opening A Lid.dae")!
        let node = SCNNode()
        for child in idleScene.rootNode.childNodes {
            node.addChildNode(child)
        }
        
        node.position = SCNVector3(0, -30, -70)
        node.scale = SCNVector3(0.30, 0.30, 0.30)
        sceneView.scene.rootNode.addChildNode(node)
        playMonsterSound()
    }
    
    func loadMMAFighter() {
        let idleScene = SCNScene(named: "art.scnassets/Chapa Giratoria 2.dae")!
        let node = SCNNode()
        for child in idleScene.rootNode.childNodes {
            node.addChildNode(child)
        }
        
        node.position = SCNVector3(0, -30, -70)
        node.scale = SCNVector3(0.25, 0.25, 0.25)
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func loadGirlDance() {
        let idleScene = SCNScene(named: "art.scnassets/Bellydancing.dae")!
        let node = SCNNode()
        for child in idleScene.rootNode.childNodes {
            node.addChildNode(child)
        }
        
        node.position = SCNVector3(0, -30, -70)
        node.scale = SCNVector3(0.30, 0.30, 0.30)
        sceneView.scene.rootNode.addChildNode(node)
        playSound()
    }
    
    func createSouljer(position: SCNVector3) {
        let idleScene = SCNScene(named: "art.scnassets/Inverted Double Kick To Kip Up.dae")!
        let node = SCNNode()
        for child in idleScene.rootNode.childNodes {
            node.addChildNode(child)
        }
        
        node.position = SCNVector3(0, -30, -70)
        node.scale = SCNVector3(0.20, 0.20, 0.20)
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func createMonster(position: SCNVector3) {
        let idleScene = SCNScene(named: "art.scnassets/Opening A Lid.dae")!
        let node = SCNNode()
        
        for child in idleScene.rootNode.childNodes {
            node.addChildNode(child)
        }
        node.scale = SCNVector3(0.01, 0.01, 0.01)
        node.position = position
        sceneView.scene.rootNode.addChildNode(node)
        playMonsterSound()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

extension SCNNode {
    
    convenience init(named name: String) {
        self.init()
        
        guard let scene = SCNScene(named: name) else {
            return
        }
        
        for childNode in scene.rootNode.childNodes {
            addChildNode(childNode)
        }
    }
    
}

public extension Float {
    
    // Returns a random floating point number between 0.0 and 1.0, inclusive.
    
    public static var random:Float {
        get {
            return Float(arc4random()) / 0xFFFFFFFF
        }
    }
    /*
     Create a random num Float
     
     - parameter min: Float
     - parameter max: Float
     
     - returns: Float
     */
    public static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
}
