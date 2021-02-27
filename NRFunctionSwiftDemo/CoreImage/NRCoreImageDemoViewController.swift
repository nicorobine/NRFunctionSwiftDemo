//
//  NRCoreImageDemoViewController.swift
//  NRFunctionSwiftDemo
//
//  Created by 王文涛 on 2021/1/7.
//

import UIKit

class NRCoreImageDemoViewController: UIViewController {

    @IBOutlet weak var image1View: UIImageView!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var image2View: UIImageView!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var image3View: UIImageView!
    
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var image4View: UIImageView!
    
    @IBOutlet weak var label4: UILabel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            let url = Bundle.main.url(forResource: "test", withExtension: "jpg")!
//            let url = URL(string: "http://via.placeholder.com/500x500")!
            
            let image = CIImage(contentsOf: url)!
            DispatchQueue.main.async {
                
                self.image1View.image = UIImage(ciImage: image)
                self.label1.text = "Origin Image"
                
                self.image2View.image = UIImage(ciImage: blur(radius: 5.0)(image))
                self.label2.text = "Blur Image"
                
                self.image3View.image = UIImage(ciImage: overlay(color: UIColor.blue.withAlphaComponent(0.3))(image))
                self.label3.text = "Overlay Blue Image"
                
                self.image4View.image = UIImage(ciImage: overlay(color: UIColor.systemPink.withAlphaComponent(0.3))(image))
                self.label4.text = "Overlay Pink Image"
            }
        }
    }
    
}
