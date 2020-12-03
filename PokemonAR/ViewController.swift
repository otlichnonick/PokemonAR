//
//  ViewController.swift
//  PokemonAR
//
//  Created by Антон on 03.12.2020.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARImageTrackingConfiguration()
        
        guard let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Photos", bundle: .main) else {
            print("There no image to track")
            return
        }
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 1

        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        DispatchQueue.main.async {
            guard let imageAnchor = anchor as? ARImageAnchor else {
                print("False image anchor")
                return
            }
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                                 height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi/2
            
            node.addChildNode(planeNode)
                
            guard let objectScene = SCNScene(named: "art.scnassets/kens-rage-mamiya.scn") else {
                print("False object scene")
                return
            }
            
            guard let objectNode = objectScene.rootNode.childNodes.first else {
                print("False object node")
                return
            }
            
            objectNode.eulerAngles.x = .pi/2
            planeNode.addChildNode(objectNode)
        }

        return node
    }
}
