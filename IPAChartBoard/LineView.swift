//
//  LineView.swift
//  PlacingViews
//
//  Created by Frederick Kuhl on 10/8/16.
//  Copyright © 2016 TyndaleSoft LLC. All rights reserved.
//

import UIKit

enum LineKind: String {
    case horizontal = "horizontal"
    case vertical   = "vertical"
    case ascending  = "ascending"
    case descending = "descending"
}

@IBDesignable
class LineView: UIView {
    @IBInspectable var lineWidth: CGFloat = 2.0
    @IBInspectable var gray: CGFloat {
        get { return theGray }
        set {
            theGray = newValue
            lineColor = UIColor(red: theGray, green: theGray, blue: theGray, alpha: 1.0)
        }
    }
    private var theGray: CGFloat = 0.5
    private var lineColor = UIColor.gray
    private var kind: LineKind = .horizontal
    //http://stackoverflow.com/questions/27432736/how-to-create-an-ibinspectable-of-type-enum
    @IBInspectable var kindAdapter: String {
        get {
            return self.kind.rawValue
        }
        set (kindString) {
            self.kind = LineKind(rawValue: kindString) ?? .horizontal
        }
    }
    
    //IB calls this, or at least requires it. Setting background color herein does nothing.
    override init(frame: CGRect) {
        super.init(frame: frame) //placement of this is tricky: all subclass properties must be set, but need self defined below
    }
    
    //Since I provide init with frame, the class doesn't inherit other initializers, so this must be provided
    //this is called only if view comes out of storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        var begin, end: CGPoint
        switch kind {
        case .horizontal:
            begin = CGPoint(x: self.bounds.origin.x, y: self.bounds.origin.y + lineWidth / 2.0)
            end = CGPoint(x: self.bounds.origin.x + self.bounds.size.width, y: self.bounds.origin.y + lineWidth / 2.0)
        case .vertical:
            begin = CGPoint(x: self.bounds.origin.x + lineWidth / 2, y: self.bounds.origin.y)
            end = CGPoint(x: self.bounds.origin.x + lineWidth / 2, y: self.bounds.origin.y + self.bounds.size.height)
        case .ascending:
            begin = CGPoint(x: self.bounds.origin.x, y: self.bounds.origin.y + self.bounds.size.height)
            end = CGPoint(x: self.bounds.origin.x + self.bounds.size.width, y: self.bounds.origin.y)
        case .descending:
            begin = self.bounds.origin
            end = CGPoint(x: self.bounds.origin.x + self.bounds.size.width, y: self.bounds.origin.y + self.bounds.size.height)
        }
        let path = UIBezierPath()
        path.move(to: begin)
        path.addLine(to: end)
        path.lineWidth = self.lineWidth
        lineColor.setStroke()
        path.stroke()
    }
}
