//
//  PreviewViewController.swift
//  DrawFingureOnView
//
//  Created by Nitin Bhatia on 05/07/22.
//

import UIKit

class PreviewViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var imgSignature: UIImageView!
    
    //variables
    var imageS = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        imgSignature.image = imageS
        
        let base64String = imgSignature.image?.pngData()?.base64EncodedString()
        print(base64String)
    }
    
    
    
}
