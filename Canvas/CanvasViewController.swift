//
//  CanvasViewController.swift
//  Canvas
//
//  Created by Dhriti Chawla on 2/24/18.
//  Copyright © 2018 codepath. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trayDownOffset = 170
        trayUp = trayView.center // The initial position of the tray
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset) // The position of the tray transposed down

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        
        var trayOriginalCenter: CGPoint!
        trayOriginalCenter = trayView.center
        let location = sender.location(in: view)
        let velocity = sender.velocity(in: view)
        
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            print("Gesture began")
            trayOriginalCenter = trayView.center
            
        } else if sender.state == .changed {
            print("Gesture is changing")
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            
        } else if sender.state == .ended {
            print("Gesture ended")
            if (velocity.y > 0){
//                UIView.animate(withDuration: 0.4) {
//                    self.trayView.center = self.trayDown
                    UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                                   animations: { () -> Void in
                                    self.trayView.center = self.trayDown
                    }, completion: nil)
//                }
            } else {
                UIView.animate(withDuration: 0.4) {
                    self.trayView.center = self.trayUp
                }
            }
        }
        
    }
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            var imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            // Here we use the method didPan(sender:), which we defined in the previous step, as the action.
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(faces(sender:)))
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(sender:)))
            let rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(sender:)))
           
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(rotateGestureRecognizer)
            
            
        } else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            
        } else if sender.state == .ended {
            
        }
    }
    
    @objc func faces(sender: UIPanGestureRecognizer){
        
         let translation = sender.translation(in: view)
        if sender.state == .began {
            print("Gesture began")
            newlyCreatedFace = sender.view as! UIImageView // to get the face that we panned on.
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center // so we can offset by translation later.
            
        } else if sender.state == .changed {
            print("Gesture is changing")
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            
        } else if sender.state == .ended {
            print("Gesture ended")
            
        }
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func didPinch(sender: UIPinchGestureRecognizer) {
        
        if sender.state == .began {
            print("pinching")
            
            let scale = sender.scale
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFace.transform = (newlyCreatedFace.transform.scaledBy(x:scale, y: scale))
            sender.scale = 1
            
        } else if sender.state == .changed {
            print("pinching")
            let scale = sender.scale
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFace.transform = (newlyCreatedFace.transform.scaledBy(x:scale, y: scale))
            sender.scale = 1
            
        } else if sender.state == .ended {
            print("Gesture ended")
        }
        
    }
    
    @objc func didRotate(sender: UIRotationGestureRecognizer) {
        
        if sender.state == .began {
            print("rotating")
            
            let rotation = sender.rotation
        
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFace.transform = (newlyCreatedFace.transform.rotated(by: rotation))
            sender.rotation = 0
            
        } else if sender.state == .changed {
            print("rotating")
            
            let rotation = sender.rotation
            
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFace.transform = (newlyCreatedFace.transform.rotated(by: rotation))
            sender.rotation = 0
            
        } else if sender.state == .ended {
            print("Gesture ended")
        }
        
    }
    

    
    
    
}
