//
//  GameViewController.swift
//  SceneTest
//
//  Created by Tom Shiflet on 3/6/19.
//  Copyright © 2019 Tom Shiflet. All rights reserved.
//

import SceneKit
import QuartzCore
import SpriteKit


class GameViewController: NSViewController {
    
    var angle:CGFloat=0
    var angle2:CGFloat=0
    
    var moonNode=SCNNode()
    var moonNode2=SCNNode()
    var MOONSPEED:CGFloat=0.1
    var MOONDIST:CGFloat=7
    var MOON2SPEED:CGFloat=0.1
    var MOON2DIST:CGFloat=7
    
    var scnView=SCNView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        let scene=SCNScene()
        //self.view.setFrameSize(NSSize(width: 1024, height
        self.view.frame=NSRect(x: 0, y: 0, width: 1024, height: 768)
        scene.fogStartDistance=10
        scene.fogEndDistance=100.0
        scene.background.contents=NSColor.cyan
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 25)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = NSColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        
        
        // retrieve the ship node
        //let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        
        // animate the 3d object
        //ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        // create sphere
        let blobSize=random(min: 2, max: 4)
        let blob=SCNSphere(radius: blobSize)
        //let blob=SCNBox(width: blobSize*2, height: blobSize*2, length: blobSize*2, chamferRadius: blobSize/2)
        let blobNode=SCNNode(geometry: blob)

        

        

    blobNode.runAction(SCNAction.repeatForever(SCNAction.sequence([SCNAction.scale(to: 1.1, duration: 1.5), SCNAction.scale(to: 0.9, duration: 1.5)])))
        blobNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1.0)))
        scene.rootNode.addChildNode(blobNode)
        blobNode.position=SCNVector3(x: 0, y: 0, z: 0)
        let blobMat=SCNMaterial()

        let blobnum=Int(random(min: 1, max: 6.99999))
        let blobTex=SKTexture(imageNamed: "blob0\(blobnum)")
        blobMat.diffuse.contents=blobTex
        blob.firstMaterial?=blobMat
        
        //blob.firstMaterial?.diffuse.contents=NSImage(named: "blob03")
        //blob.firstMaterial?.diffuse.contents=NSColor(calibratedRed: random(min: 0, max: 1), green: random(min: 0, max: 1), blue: random(min: 0, max: 1), alpha: 1.0)
        
        
        let shell=SCNSphere(radius: random(min: blobSize*1.01, max: blobSize*1.5))
        let shellNode=SCNNode(geometry: shell)
        //blobNode.addChildNode(shellNode)
        shell.firstMaterial?.diffuse.contents=NSColor(calibratedRed: random(min: 0, max: 1), green: random(min: 0, max: 1), blue: random(min: 0, max: 1), alpha: 0.8)
        let shellspeed=random(min: -2, max: 2)
        shellNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: shellspeed, z: 0, duration: 1.0)))
        
        let moon=SCNSphere(radius: random(min: 0.1, max: 1.0))
        moonNode=SCNNode(geometry: moon)
        blobNode.addChildNode(moonNode)
        moonNode.position.x=7
        moon.firstMaterial?.diffuse.contents=NSColor(calibratedRed: random(min: 0, max: 1), green: random(min: 0, max: 1), blue: random(min: 0, max: 1), alpha: 1.0)
        
        MOONDIST=random(min: blobSize*1.0, max: blobSize*4.0)
        MOONSPEED=random(min: -0.15, max: 0.15)
        
        let moon2=SCNSphere(radius: random(min: 0.1, max: 1.0))
        moonNode2=SCNNode(geometry: moon2)
        //blobNode.addChildNode(moonNode2)
        moonNode2.position.x=7
        moon2.firstMaterial?.diffuse.contents=NSColor(calibratedRed: random(min: 0, max: 1), green: random(min: 0, max: 1), blue: random(min: 0, max: 1), alpha: 1.0)
        
        MOON2DIST=random(min: blobSize*1.0, max: blobSize*4.0)
        MOON2SPEED=random(min: -0.15, max: 0.15)
        
        
        
        // retrieve the SCNView
        scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = NSColor.black
        scnView.delegate = self
        // Add a click gesture recognizer
        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(handleClick(_:)))
        var gestureRecognizers = scnView.gestureRecognizers
        gestureRecognizers.insert(clickGesture, at: 0)
        scnView.gestureRecognizers = gestureRecognizers
    }
    
    @objc
    func handleClick(_ gestureRecognizer: NSGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are clicked
        let p = gestureRecognizer.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = NSColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = NSColor.red
            
            SCNTransaction.commit()
        }
    }
    func updateMoon()
    {
        angle+=MOONSPEED
        // normalize angle
        if angle > CGFloat.pi*2
        {
            angle -= CGFloat.pi*2
        }
        if angle < CGFloat.pi*2
        {
            angle += CGFloat.pi*2
        }
        
        let dx=cos(angle)*MOONDIST
        let dz=sin(angle)*MOONDIST
        moonNode.position.x=dx
        moonNode.position.z=dz
        
        angle2+=MOON2SPEED
        // normalize angle
        if angle2 > CGFloat.pi*2
        {
            angle2 -= CGFloat.pi*2
        }
        if angle2 < CGFloat.pi*2
        {
            angle2 += CGFloat.pi*2
        }
        
        let dx2=cos(angle2)*MOON2DIST
        let dz2=sin(angle2)*MOON2DIST
        moonNode2.position.x=dx2
        moonNode2.position.z=dz2
        
        
    }
    
    
    
}
extension GameViewController: SCNSceneRendererDelegate {
    // 2
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // 3
        updateMoon()
        
    }
}


