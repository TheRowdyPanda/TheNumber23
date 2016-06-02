//
//  startScene.m
//  dumpTruck
//
//  Created by Rijul Gupta on 4/24/14.
//  Copyright (c) 2014 Rijul Gupta. All rights reserved.
//

#import "startScene.h"
#import "MyScene.h"
#import "MyScene2.h"
//#import "MyScene3.h"
@implementation startScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        
        SKSpriteNode *firstScene = [SKSpriteNode spriteNodeWithColor:[UIColor yellowColor] size:CGSizeMake(50, 50)];
        firstScene.name = @"firstScene";
        firstScene.position = CGPointMake(100, 400);
        [self addChild:firstScene];
        
        
        SKSpriteNode *secondScene = [SKSpriteNode spriteNodeWithColor:[UIColor yellowColor] size:CGSizeMake(50, 50)];
        secondScene.name = @"secondScene";
        secondScene.position = CGPointMake(200, 400);
        [self addChild:secondScene];
        
        SKSpriteNode *thirdScene = [SKSpriteNode spriteNodeWithColor:[UIColor yellowColor] size:CGSizeMake(50, 50)];
        thirdScene.name = @"thirdScene";
        thirdScene.position = CGPointMake(300, 400);
        [self addChild:thirdScene];
        
    }
    return self;
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        
        if([node.name isEqualToString:@"firstScene"])
        {
            
            SKView * skView = (SKView *)self.view;
            skView.showsFPS = YES;
            skView.showsNodeCount = YES;
            
            // Create and configure the scene.
            SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
            //      SKScene * scene = [MyScene2 sceneWithSize:skView.bounds.size];
            // SKScene * scene = [MyScene3 sceneWithSize:skView.bounds.size];
            //  SKScene * scene = [startScene sceneWithSize:skView.bounds.size];
            
            scene.scaleMode = SKSceneScaleModeAspectFill;
            
            // Present the scene.
            [skView presentScene:scene];
        }
        
        if([node.name isEqualToString:@"secondScene"])
        {
            
            SKView * skView = (SKView *)self.view;
            skView.showsFPS = YES;
            skView.showsNodeCount = YES;
            
            // Create and configure the scene.
            //   SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
            SKScene * scene = [MyScene2 sceneWithSize:skView.bounds.size];
            // SKScene * scene = [MyScene3 sceneWithSize:skView.bounds.size];
            //  SKScene * scene = [startScene sceneWithSize:skView.bounds.size];
            
            scene.scaleMode = SKSceneScaleModeAspectFill;
            
            // Present the scene.
            [skView presentScene:scene];
        }
        
        if([node.name isEqualToString:@"thirdScene"])
        {
            
            /*
            SKView * skView = (SKView *)self.view;
            skView.showsFPS = YES;
            skView.showsNodeCount = YES;
            
            // Create and configure the scene.
            //    SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
            //      SKScene * scene = [MyScene2 sceneWithSize:skView.bounds.size];
            SKScene * scene = [MyScene3 sceneWithSize:skView.bounds.size];
            //  SKScene * scene = [startScene sceneWithSize:skView.bounds.size];
            
            scene.scaleMode = SKSceneScaleModeAspectFill;
            
            // Present the scene.
            [skView presentScene:scene];
             */
        }
        
    }
    
}
@end
