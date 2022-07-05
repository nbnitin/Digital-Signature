//
//  ViewController.swift
//  DrawFingureOnView
//
//  Created by Nitin Bhatia on 05/07/22.
//

import UIKit

class ViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var signView: SignView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    // MARK: - User methods
    @IBAction fileprivate func previewVCMethod(_ sender : UIButton) {
        if signView.isEmpty {
            print("Please draw something")
            return
        }
        let previewVC = self.storyboard?.instantiateViewController(withIdentifier: "PreviewVC") as! PreviewViewController
        if let image = signView.getDesign {
            previewVC.imageS = image
        }
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
    
    @IBAction fileprivate func clearSignature(_ sender: UIButton) {
        signView.clear()
    }
    
}
