//
//  SKMenuNode.swift
//  skmenunode
//
//  Created by Stanciu Valentin on 25/07/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

import SpriteKit

protocol MenuNodeDelegate {
    func menuTargetTouched(index: Int)
}

class MenuNode: SKNode {
    
    var delegate: MenuNodeDelegate?
    
    var padding:Int = 30;
    var xPos:Int = 60;
    var yPos:Int = 0;
    
    var defaultText: SKLabelNode?;
    
    var items:Array<AnyObject>
    var actions:Array<AnyObject>
    
    override init () {
        items = Array();
        actions = Array();
        
        super.init()
        self.userInteractionEnabled = true;
        
    }
    
    convenience init(delegate: MenuNodeDelegate) {
        self.init();
        self.delegate = delegate
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            //let touch:UITouch = touches.anyObject() as! UITouch
            let touchLocation = touch.locationInNode(self)
            
            for index in 0...items.count-1 {
                if (CGRectContainsPoint(items[index].frame, touchLocation)) {
                    delegate?.menuTargetTouched(index)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addChainTarget(item: String) -> AnyObject {
        
        let node:SKLabelNode = SKLabelNode(fontNamed: "HelveticaNeue-UltraLight");
        node.fontColor = UIColor.blackColor();
        node.fontSize = 28;
        node.text = item;
        node.color = UIColor.whiteColor()
        
        self.addChild(node);
        items.append(node);
        //actions.append(action);
        node.position = CGPoint(x:0, y:xPos);
        
        xPos = xPos - (Int(node.frame.height) + self.padding);
        return self;
    }
    
    
    
    func addTarget(item: String) {
        let node:SKLabelNode = SKLabelNode(fontNamed: "HelveticaNeue-UltraLight");
        node.text = item
        node.fontSize = 28;
        self.addChild(node);
        items.append(node);
        //actions.append(action);
        node.position = CGPoint(x:0, y:xPos);
        xPos = xPos - (Int(node.frame.height) + self.padding);
    }
    
    func addText(item: String) {
        defaultText  = SKLabelNode(fontNamed: "HelveticaNeue-UltraLight");
        defaultText?.text = item
        
        self.addChild(defaultText!);
        items.append(defaultText!);
        defaultText?.position = CGPoint(x:0, y:xPos);
        xPos = xPos - (Int(defaultText!.frame.height) + self.padding);
    }
    
    func changeText(item: String) {
        defaultText?.text = item;
    }
    
    
    func setPosition() {
        
    }
    
    func menuTargetTouched() {
        
        
    }
    
    func render() {
        
    }
}
