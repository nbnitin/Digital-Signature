//
//  SingView.swift
//  DrawFingureOnView
//
//  Created by Nitin Bhatia on 05/07/22.
//

import UIKit

extension UIBezierPath {
    func moveWithCurve(a: CGPoint, b: CGPoint, c: CGPoint, d: CGPoint) -> CGPoint {
        
        var midPoint = a
        move(to: midPoint)
        midPoint = getMidPoint(a: c, b: d)
        addCurve(to: midPoint, controlPoint1: b, controlPoint2: c)
        return midPoint
    }
    
    fileprivate func getMidPoint(a: CGPoint, b: CGPoint) -> CGPoint {
        return CGPoint(x: (a.x + b.x)/2.0, y: (a.y + b.y)/2.0)
    }
}

@IBDesignable
class SignView: UIView {
    
    /// Counter for number of control points
    var ctr: Int = 0
    
    /// Saves touche points for drawing
    var touches = [CGPoint](repeating: CGPoint(), count:5)
    
    /// Drawing path
    var path = UIBezierPath() {
        didSet {
            path.lineJoinStyle = .round
            setNeedsDisplay()
        }
    }
    
    // Inspectable elements
    
    @IBInspectable open var lineWidth: CGFloat = 10.0 {
        didSet {
            path.lineWidth = lineWidth
            setNeedsDisplay()
        }
    }
    
    @IBInspectable open var lineColor: UIColor = .orange {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open var style:CGLineCap = .round {
        didSet {
            path.lineCapStyle = style
            setNeedsDisplay()
        }
    }
    
    open var isEmpty: Bool {
        get {
            guard !self.path.isEmpty else {
                return true
            }
            return false
        }
    }
    
    open var getDesign: UIImage? {
        guard !isEmpty else {
            return nil
        }
        return UIImage(view: self)
    }
    
    
    // MARK: - Clear path
    
    internal func clear() {
        path.removeAllPoints()
        setNeedsDisplay()
    }
    
    // Override functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        lineColor.setStroke()
        path.stroke()
        setNeedsDisplay()
    }
    
    
    // Track the finger as we move across screen
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        insertTouch(touch: point, at: 0)
        super.touchesBegan(touches, with: event)
        
    }
    
    override open func touchesMoved (_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self) // It must come in any case
        
        guard ctr == 4 else {
            insertTouch(touch: point, at: ctr+1)
            return
        }
        
        self.touches[1] = path.moveWithCurve(a: self.touches[1], b: self.touches[2], c: self.touches[3], d: point)
        
        insertTouch(touch: point, at: 2)
        
        setNeedsDisplay()
        
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard ctr == 0 else {
            ctr = 0
            return
        }
        
        addDot(origin: (touches.first!.location(in: self)), size: lineWidth)
        setNeedsDisplay()
        super.touchesEnded(touches, with: event)
    }
    
    func addDot(origin: CGPoint, size: CGFloat) {
        let rect = CGRect(origin: origin, size: CGSize(width: size, height: size))
        let dotPath = UIBezierPath(ovalIn: rect)
        path.append(dotPath)
    }
    
    func insertTouch(touch: CGPoint, at index: Int) {
        ctr = index
        touches.insert(touch, at: ctr)
    }
}

// MARK: - Convert UIView to Image
extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
}
