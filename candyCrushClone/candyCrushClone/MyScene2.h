//
//  MyScene.h
//  candyCrushClone
//

//  Copyright (c) 2014 Rijul Gupta. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene2 : SKScene <SKPhysicsContactDelegate>

@property(nonatomic)NSMutableArray *mainSpriteArrayRows;
@property(nonatomic)NSMutableArray *mainSpriteArrayColumns;
@property(nonatomic)NSMutableArray *mainArray;
@property(nonatomic)NSMutableArray *arrayOfValues;


@property(nonatomic)SKSpriteNode *moverNode;

@property(nonatomic)CGPoint originalPoint;

@property(nonatomic)int switchThreshold;
@property(nonatomic)int boxSizer;
@property(nonatomic)int boxSpacer;

@property(nonatomic)int numOfRow;

@property(nonatomic)int numberOfMovesLeft;


@property(nonatomic)int numOfColumn;
@property(nonatomic)BOOL didReachThreshold;
@property(nonatomic)BOOL isMoving;

@property(nonatomic)BOOL isAddingSprite;

@property(nonatomic)int globalLinearDamping;


@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;


@property(nonatomic)BOOL isMovingSprites;



@end
