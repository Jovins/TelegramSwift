//
//  TitledBarView.swift
//  TGUIKit
//
//  Created by keepcoder on 16/09/16.
//  Copyright © 2016 Telegram. All rights reserved.
//

import Cocoa

private class TitledContainerView : View {
    
    private var statusNode:TextNode = TextNode()
    private var titleNode:TextNode = TextNode()
    var titleImage:(CGImage, TitleBarImageSide)? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var inset:CGFloat = 50
    
    var text:NSAttributedString? {
        didSet {
            if text != oldValue {
                self.setNeedsDisplay()
            }
        }
    }
    
    var status:NSAttributedString? {
        didSet {
            if status != oldValue {
                self.setNeedsDisplay()
            }
        }
    }
    
    var hiddenStatus:Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var textInset:CGFloat? = nil {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func updateLocalizationAndTheme(theme: PresentationTheme) {
        super.updateLocalizationAndTheme(theme: theme)
        backgroundColor = presentation.colors.background
    }
    
    fileprivate override func draw(_ layer: CALayer, in ctx: CGContext) {
        
        
        
        if let text = text, let superview = superview?.superview {
            
            var additionalInset: CGFloat = 0
            if let (image,_) = titleImage {
                additionalInset += image.backingSize.width + 5
            }
            
            let (textLayout, textApply) = TextNode.layoutText(maybeNode: titleNode,  text, nil, 1, .end, NSMakeSize(frame.width - inset - additionalInset, frame.height), nil,false, .left)
            var tY = focus(textLayout.size).minY
            
            if let status = status {
                
                let (statusLayout, statusApply) = TextNode.layoutText(maybeNode: statusNode,  status, nil, 1, .end, NSMakeSize(frame.width - inset - additionalInset, frame.height), nil,false, .left)
                
                let t = textLayout.size.height + statusLayout.size.height + 2.0
                tY = (frame.height - t) / 2.0
                
                let sY = tY + textLayout.size.height + 2.0
                if !hiddenStatus {
                    let point = convert( NSMakePoint(floorToScreenPixels(backingScaleFactor, (superview.frame.width - statusLayout.size.width)/2.0), tY), from: superview)
                    
                    statusApply.draw(NSMakeRect(textInset == nil ? point.x : textInset!, sY, statusLayout.size.width, statusLayout.size.height), in: ctx, backingScaleFactor: backingScaleFactor, backgroundColor: backgroundColor)
                }
            }
            
            let point = convert( NSMakePoint(floorToScreenPixels(backingScaleFactor, (superview.frame.width - textLayout.size.width)/2.0), tY), from: superview)
            var textRect = NSMakeRect(min(max(textInset == nil ? point.x : textInset!, 0), frame.width - textLayout.size.width), point.y, textLayout.size.width, textLayout.size.height)
            
            if let (titleImage, side) = titleImage {
                switch side {
                case .left:
                    ctx.draw(titleImage, in: NSMakeRect(textInset == nil ? textRect.minX - titleImage.backingSize.width : textInset!, tY + 4, titleImage.backingSize.width, titleImage.backingSize.height))
                    textRect.origin.x += floorToScreenPixels(backingScaleFactor, titleImage.backingSize.width) + 4
                case .right:
                    ctx.draw(titleImage, in: NSMakeRect(textRect.maxX + 3, tY + 1, titleImage.backingSize.width, titleImage.backingSize.height))
                }
            }
            
            textApply.draw(textRect, in: ctx, backingScaleFactor: backingScaleFactor, backgroundColor: backgroundColor)
        }
    }
}

public enum TitleBarImageSide {
    case left
    case right
}

open class TitledBarView: BarView {
    
    public var titleImage:(CGImage, TitleBarImageSide)? {
        didSet {
            _containerView.titleImage = titleImage
        }
    }
    
    open override var backgroundColor: NSColor {
        didSet {
            containerView.backgroundColor = backgroundColor
        }
    }
    
    public var text:NSAttributedString? {
        didSet {
            if text != oldValue {
                _containerView.inset = inset
                _containerView.text = text
            }
        }
    }
    
    public var status:NSAttributedString? {
        didSet {
            if status != oldValue {
                _containerView.inset = inset
                _containerView.status = status
            }
        }
    }
    
    private let _containerView:TitledContainerView = TitledContainerView()
    public var containerView:View {
        return _containerView
    }
    
    public var hiddenStatus:Bool = false {
        didSet {
            _containerView.hiddenStatus = hiddenStatus
        }
    }
    
    open var inset:CGFloat {
        return 50
    }

    public var textInset:CGFloat? {
        didSet {
            _containerView.textInset = textInset
        }
    }
    
    open override func setFrameSize(_ newSize: NSSize) {
        super.setFrameSize(newSize)
        containerView.setFrameSize(newSize)
        containerView.setNeedsDisplay()
    }
    public init(controller: ViewController, _ text:NSAttributedString? = nil, _ status:NSAttributedString? = nil, textInset:CGFloat? = nil) {
        self.text = text
        self.status = status
        self.textInset = textInset
        super.init(controller: controller)
        addSubview(containerView)
        _containerView.text = text
        _containerView.status = status
        _containerView.textInset = textInset
    }
    
    open override func draw(_ dirtyRect: NSRect) {
        
    }
    
    deinit {
        var bp:Int = 0
        bp += 1
    }
    

    required public init(frame frameRect: NSRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
