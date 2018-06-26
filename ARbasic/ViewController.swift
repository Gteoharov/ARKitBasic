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

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        singleTapGestureRecognizer()
        doubleTapGestureRecognizer()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        loadMonster()
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
    
    private func singleTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func doubleTapGestureRecognizer() {
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.sceneView.addGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    @objc func doubleTapped(reconizer: UITapGestureRecognizer) {
        let tapped = reconizer.view as! SCNView
        let touchLocation = reconizer.location(in: tapped)
        let hitTest = tapped.hitTest(touchLocation, options: nil)
        if !hitTest.isEmpty {
            guard let touch = hitTest.first else { return }
            let result = sceneView.hitTest(touch.accessibilityActivationPoint, types: [ARHitTestResult.ResultType.featurePoint])
            guard let hitResult = result.last else { return }
            let hitTransform =  SCNMatrix4(hitResult.worldTransform)
            let hitVector = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
            createSouljer(position: hitVector)
        }
    }
    
    @objc func tapped(recognizer :UITapGestureRecognizer) {
        let tappedView = recognizer.view as! SCNView
        let touchLocation = recognizer.location(in: tappedView)
        let hitTest = tappedView.hitTest(touchLocation, options: nil)
        if !hitTest.isEmpty {
            let result = hitTest.first!
            result.node.removeFromParentNode()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let tocuh = touches.first else { return }
        let result = sceneView.hitTest(tocuh.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
        guard let hitResult = result.last else { return }
        let hitTransform =  SCNMatrix4(hitResult.worldTransform)
        let hitVector = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        createSouljer(position: hitVector)

    }
    
    func loadMonster() {
        let idleScene = SCNScene(named: "art.scnassets/Mma Kick.dae")!
        let node = SCNNode()
        for child in idleScene.rootNode.childNodes {
            node.addChildNode(child)
        }
        
        node.position = SCNVector3(0, -30, -70)
        node.scale = SCNVector3(0.18, 0.18, 0.18)
        sceneView.scene.rootNode.addChildNode(node)
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
