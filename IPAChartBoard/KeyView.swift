//
//  KeyView.swift
//  NewTrialKeyboard
//
//  Created by Frederick Kuhl on 1/23/15.
//  Copyright (c) 2015 Frederick Kuhl. All rights reserved.
//

import UIKit

@IBDesignable
class KeyView : UIView {
    private static let dottedCircle = "\u{25CC}"
    private static let keyLightColor = UIColor(red: 254.0/255.0, green: 254.0/255.0, blue: 254.0/255.0, alpha: 1.0)
    private static let keyDarkColor = UIColor(red: 210.0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 1.0)
    private static let fontSize = CGFloat(24)
    static let keyWidth = CGFloat(40)
    static let keyHeight = CGFloat(40)
    private static var _fontAttributes: Dictionary<String,Any>? = nil
    //private static var _font: UIFont? = UIFont.boldSystemFont(ofSize: KeyView.fontSize)
    private static var _font: UIFont? = UIFont(name: "CharisSIL", size: KeyView.fontSize)
    
    //thread-safe singleton in the age of Swift 3:
    //http://krakendev.io/blog/the-right-way-to-write-a-singleton
    struct FontAttributes {
        var attributes: Dictionary<String,Any>
        static let sharedInstance = FontAttributes()
        private init() {
            let paraStyle = NSMutableParagraphStyle()
            paraStyle.alignment = NSTextAlignment.center
            attributes = [
                NSForegroundColorAttributeName: UIColor.darkGray,
                NSParagraphStyleAttributeName: paraStyle,
                NSFontAttributeName: KeyView._font!]
        }
    }
    
    private var controller: KeyboardViewController?
    private var glyphs: (displayed: String, typed: String)?
    private var highlighted = false
    //We'll make this programmatically, so don't have to make one for each key in IB
    private var tapRecognizer: UITapGestureRecognizer?
    //To make these IBInspectable, I've specified the type, though Swift can infer it from the initializer.
    private let cornerRadius: CGFloat = CGFloat(3)
    private let lineWidth: CGFloat = CGFloat(1)
    
    //One or more scalars as base 16 strings, joined with '+'
    //The name ought to be plural, but it's singular in too many storyboards!
    @IBInspectable var unicodeScalar: String = "2318" //command splodge for "not set"
    private var kind: KeyViewKind = .blank
    //http://stackoverflow.com/questions/27432736/how-to-create-an-ibinspectable-of-type-enum
    @IBInspectable var kindAdapter: String {
        get {
            return self.kind.rawValue
        }
        set (kindString) {
            self.kind = KeyViewKind(rawValue: kindString) ?? .newView
        }
    }
    @IBInspectable var nextSceneID: String = "not set"
    @IBInspectable var setOwnConstraints: Bool = false
    
    //IB calls this, or at least requires it. Setting background color herein does nothing.
    override init(frame: CGRect) {
        super.init(frame: frame) //placement of this is tricky: all subclass properties must be set, but need self defined below
        finishInit()
    }

    //Since I provide init with frame, the class doesn't inherit other initializers, so this must be provided
    //this is called only if view comes out of storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        finishInit()
    }
    
    private func finishInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.clear
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        tapRecognizer!.cancelsTouchesInView = false  //ensure we get touchesEnded
        self.addGestureRecognizer(tapRecognizer!)
    }
    
    //Called by owning ViewController (ultimately) in its viewDidLoad
    func initialize(withController: KeyboardViewController) {
        controller = withController
        //This is delayed, because the IBInspectables aren't set at init time. (?)
        glyphs = getGlyphs()
        if kind == .blank || setOwnConstraints {
            let widthConstraint = self.widthAnchor.constraint(equalToConstant: KeyView.keyWidth)
            widthConstraint.identifier = (glyphs?.displayed)! + "-w"
            widthConstraint.isActive = true
            let heightConstraint = self.heightAnchor.constraint(equalToConstant: KeyView.keyHeight)
            heightConstraint.identifier = (glyphs?.displayed)! + "-h"
            heightConstraint.isActive = true
        }
    }
    
    private func getGlyphs() -> (displayed: String, typed: String) {
        if self.kind == .blank { return (displayed: "", typed: "") }
        if self.kind == .backspace { return (displayed:"⌫", typed: "") }
        var typedGlyphs = ""
        var displayedGlyphs = (self.kind == .diacritic || self.kind == .tie) ? KeyView.dottedCircle : ""
        for singleScalar in unicodeScalar.components(separatedBy: "+") {
            var singleGlyph = "⌘"
            if let intRep = UInt32(singleScalar, radix: 16) {
                if let scalar = UnicodeScalar(intRep) {
                    singleGlyph = String(Character(scalar))
                } else {
                    preconditionFailure("no scalar for int \(intRep), text '\(singleScalar)' ")
                }
            } else {
                preconditionFailure("'\(singleScalar)' is not valid UInt32")
            }
            typedGlyphs = typedGlyphs.appending(singleGlyph)
            displayedGlyphs = displayedGlyphs.appending(singleGlyph)
        }
        if self.kind == .tie { displayedGlyphs = displayedGlyphs.appending(KeyView.dottedCircle) }
        return (displayed: displayedGlyphs, typed: typedGlyphs)
    }
    
    override func draw(_ rect: CGRect) {
        var path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius)
        path.lineWidth = lineWidth
        UIColor.darkGray.setFill()
        path.fill()
        path = UIBezierPath(roundedRect: CGRect(x: self.bounds.origin.x,
                                                y: self.bounds.origin.y,
                                            width: self.bounds.size.width - lineWidth,
                                           height: self.bounds.size.height - lineWidth),
                            cornerRadius: cornerRadius)
        let drawingColor = highlighted ? KeyView.keyDarkColor : KeyView.keyLightColor
        drawingColor.setFill()
        path.fill()
        if glyphs == nil {   //Support designability in IB
            glyphs = getGlyphs()
        }
        glyphs?.displayed.draw(in: CGRect(x: 0.0,
                                         y: (bounds.size.height - (KeyView._font!.lineHeight)) / 2.0,
                                         width: bounds.size.width,
                                         height: bounds.size.height),
                              withAttributes: FontAttributes.sharedInstance.attributes)
    }
    
    
//MARK: tap and touches (UIResponder)
    
    
    func tapAction(_ sender: UITapGestureRecognizer) {
        //print("key tapped for \(String(describing: glyphs?.displayed)) (\(unicodeScalar))")
        if sender.state == .ended {
            switch self.kind {
            case .normal, .diacritic, .tie:
                controller?.keyTapped(textToAdd: glyphs!.typed, keyKind: self.kind, scalars: self.unicodeScalar)
            case .blank:
                break
            case .backspace:
                controller?.backspaceTapped()
            case .newView:
                controller?.changeScene(to: nextSceneID)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.highlighted = true
        self.setNeedsDisplay()
        //print("touches began for \(displayedGlyphs!) (\(unicodeScalar))")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch = touches.first
        if !(self.point(inside: (touch?.location(in: self))!, with: event)) {
            self.highlighted = false
            self.setNeedsDisplay()
        }
        //print("touches moved for \(displayedGlyphs!) (\(unicodeScalar))")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.highlighted = false
        self.setNeedsDisplay()
        //print("touches ended for \(displayedGlyphs!) (\(unicodeScalar))")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.highlighted = false
    }
    
}
