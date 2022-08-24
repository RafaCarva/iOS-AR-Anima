//
//  ViewController.swift
//  Anima-Proj
//
//  Created by Rafael Carvalho on 23/08/22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Mostrar a luz
        sceneView.autoenablesDefaultLighting = true
        
        
        /*
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        //AR Resources
        if let iamgeToTrack = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main){
            
            configuration.detectionImages = iamgeToTrack
            configuration.maximumNumberOfTrackedImages = 1
            
        } else {
            print("--> Erro ao carregar os itens de AR Resources.")
        }
        
        
        
        
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        if let imageAnchor = anchor as? ARImageAnchor{
            
            //Identificar a magem do "AR Resource"
            print("Imagem identificada: \(String(describing: imageAnchor.referenceImage.name))")
            
            // Posicionar um "Plane" em cima da imagem identificada
            // Plane
            let plane = SCNPlane(
                width: imageAnchor.referenceImage.physicalSize.width,
                height: imageAnchor.referenceImage.physicalSize.height
            )
            plane.firstMaterial?.diffuse.contents = UIColor(white: 2.0, alpha: 0.7)
            
            // Node
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -Float.pi / 2 // Rotacionar o plane para ele ficar "em cima" da img.
            node.addChildNode(planeNode)
            
            // Se for a carta do Vulpix
            if imageAnchor.referenceImage.name == "vulpix"{
                
                // Criar o node do objeto 3d que vai abrigar o seu modelo.
                if let myCubeScene = SCNScene(named: "art.scnassets/myCube.scn"){
                    
                    if let myCubeNode = myCubeScene.rootNode.childNodes.first{
                        myCubeNode.eulerAngles.x = Float.pi / 2
                        planeNode.addChildNode(myCubeNode)
                        
                    } else {
                        print("-->Não identificou o first layer de myCube.snc")
                    }
    
                } else {
                    print("-->Não conseguiu trazer o objeto 3d myCube.snc")
                }
            }
                
            
            
            
        }
        
        return node
    }

    
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
