//
//  SKMenuNode.swift
//  skmenunode
//
//  Created by Stanciu Valentin on 25/07/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//
import Foundation
import SpriteKit
#if os(watchOS)
    import WatchKit
    // <rdar://problem/26756207> SKColor typealias does not seem to be exposed on watchOS SpriteKit
    typealias SKColor = UIColor
#endif

@objc public protocol MenuNodeDelegate  {
    //func menuTargetTouched(index: Int)
    @objc optional func menuTargetTouched(_ index: Int, section: String);
}

open class SKMenuImage {
    
}

open class SKMenuPOP {
    
}

public typealias callbackCompletion =  (() -> Void);

struct MenuItem {
    var item: AnyObject
    let callback: callbackCompletion?
}


open class SKMenuNode: SKNode {
    
    var delegate: MenuNodeDelegate?
    
    var padding: Int = 50;
    var xPos: Int = 0;
    var yPos: Int = 0;
    
    var defaultText: SKLabelNode?;
    
    var items: Array<MenuItem>
    
    var actions: Array<AnyObject>
    
    var layoutType: SKMenuLayout;

    var section: String = "default";
    
    var _fontSize: Int = 28;
    
    fileprivate var _backgroundButton: UIColor = UIColor.blue;
    
    override public init () {
        items = Array();
        actions = Array();
        layoutType = .horizontal;
        super.init();
        self.isUserInteractionEnabled = true;
    }
    
    convenience public init(delegate: MenuNodeDelegate) {
        self.init();
        self.delegate = delegate
    }
    
    convenience public init(delegate: MenuNodeDelegate, section: String) {
        self.init();
        self.section = section;
        self.delegate = delegate
    }
    
    open func setBackgroundButton(color: UIColor) {
        self._backgroundButton = color;
    }
    
    open func setLayout(_ layoutType: SKMenuLayout) {
        self.layoutType = layoutType;
    }

    open func setPadding(_ padding: Int = 20) {
        self.padding = padding;
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    open func addChainTarget(_ item: String, callback: callbackCompletion? = nil) -> AnyObject {
        let node:SKLabelNode = SKLabelNode(fontNamed: "HelveticaNeue");
        //let layer = SKSpriteNode.init(color: UIColor.blueColor(), size: CGSize(width: 175, height: 45));
        let layer = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 200, height: 45), cornerRadius: 12);
        
        //ACTIVE /HOVER /DISABLED
        
        layer.strokeColor = _backgroundButton;
        layer.fillColor = _backgroundButton;
        
        node.fontColor = UIColor.white;
        node.fontSize = CGFloat(_fontSize);
        node.text = item;
        node.color = UIColor.white
        //node.anchorPoint = CGPointMake(0.5, 0.5);
        node.position = CGPoint(x: layer.frame.midX , y: layer.frame.midY);
        node.name = "text";
        
        node.horizontalAlignmentMode = .center;
        node.verticalAlignmentMode = .center;
        layer.position = self.getPosition(layer);
        
        layer.addChild(node);
        layer.isUserInteractionEnabled = false;
        self.addChild(layer);
        items.append(MenuItem(item: layer, callback: callback));
        return self;
    }
    
    open func getContainer() -> SKSpriteNode
    {
        
        let size = self.calculateAccumulatedFrame();
        
        let tempNode = SKSpriteNode(color: UIColor.clear,
                                    size: CGSize(width: size.width, height: size.height));
        
        self.position = CGPoint(x: -1 * size.midX, y: -1 * size.midY);
        
        tempNode.addChild(self);
        
        tempNode.position  = CGPoint.zero; //CGPoint(x: -1 * size.midX, y: -1 * size.midY);
        
        tempNode.anchorPoint = CGPoint(x: 0, y: 1);
        
        return tempNode;
        
    }
    
    open func setFontSize(size: Int) {
        self._fontSize = size;
    }
    
    open func addTarget(_ item: String) {
        let node: SKLabelNode = SKLabelNode(fontNamed: "HelveticaNeue");
        node.text = item
        node.fontSize = 28;
        node.position = self.getPosition(node);
        node.verticalAlignmentMode = .center;
        node.horizontalAlignmentMode = .left;
        
        self.addChild(node);
        items.append(MenuItem(item: node, callback: nil));
    }
    
    open func addTargetImage(_ item: SKSpriteNode, callback: callbackCompletion?) {
        item.position = self.getPosition(item);
        self.addChild(item);
        items.append(MenuItem(item: item, callback: callback));
    }
    
    open func changeTargetLabelContent(_ index: Int, content: String) {
        let node = items[index].item as! SKShapeNode;
        
        node.children.forEach { (snode) in
            let textNode = snode as! SKLabelNode;
            textNode.text = content;
        }
    }

    open func changeTargetContent(_ index: Int, content: String) {
        let node = items[index].item as! SKLabelNode;
        node.text = content;
        /*
         let node = items[index] as! SKSpriteNode;
         node.enumerateChildNodesWithName("name") { (node, unsafePointer) in
         let nodeText = node as! SKLabelNode;
         nodeText.text = content;
         }
         */
    }

    /**
     * @TODO: Still al lot of pozitioning issues
     */
    func getPosition(_ node: SKNode) -> CGPoint {
        
        let padd = self.items.count != 0 ? self.padding: 5;
        
        if (self.layoutType == .horizontal) {
            
            if (self.items.count == 0) {
                xPos =  (Int(node.calculateAccumulatedFrame().width) + padd);
                return CGPoint(x: padd, y: 0);
            }
            
            let xPosPrev = xPos + padd;
            xPos +=  (Int(node.calculateAccumulatedFrame().width)) + padd;
            
            return CGPoint(x: xPosPrev, y: yPos);
            
        } else {
            xPos = 0;
            yPos -=  (Int(node.frame.height) + padd);
        }
        
        return CGPoint(x: xPos, y: yPos);
    }
    
    open func addText(_ item: String) {
        defaultText  = SKLabelNode(fontNamed: "HelveticaNeue");
        defaultText?.text = item
        
        self.addChild(defaultText!);
        
        items.append(MenuItem(item: defaultText!, callback: nil));
        defaultText?.position = CGPoint(x: 0, y: xPos);
        xPos -= (Int(defaultText!.frame.height) + self.padding);
    }
    
    func changeText(_ item: String) {
        defaultText?.text = item;
    }
    
    func setPosition() {
    }
    func menuTargetTouched() {
        //
    }
    func render() {
        //
    }
}

#if os(watchOS)
    extension SKMenuNode {
        @available(watchOSApplicationExtension 3.0, *)
        @IBAction func handleSingleTap(tapGesture: WKTapGestureRecognizer) {
            let location = tapGesture.locationInObject()
            for index in 0...items.count-1 {
                if (items[index].item.calculateAccumulatedFrame().contains(location)) {
                    if (items[index].callback != nil) {
                        items[index].callback!();
                    } else{
                        delegate?.menuTargetTouched(index, section: section);
                    }
                }
            }
        }
    }
#endif

#if os(iOS) || os(tvOS)
    extension SKMenuNode {
        override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                //let touch:UITouch = touches.anyObject() as! UITouch
                let touchLocation = touch.location(in: self)
                for index in 0...items.count-1 {
                    if (items[index].item.calculateAccumulatedFrame().contains(touchLocation)) {
                        if (items[index].callback != nil) {
                            items[index].callback!();
                        } else{
                            delegate?.menuTargetTouched!(index, section: section);
                        }
                    }
                }
            }
        }
    }
#endif


public enum SKMenuLayout {
    case horizontal, vertical;
}

