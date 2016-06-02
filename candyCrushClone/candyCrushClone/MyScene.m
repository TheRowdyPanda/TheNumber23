//
//  MyScene.m
//  candyCrushClone
//
//  Created by Rijul Gupta on 4/19/14.
//  Copyright (c) 2014 Rijul Gupta. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:(88.0/255) green:(143.0/255) blue:(39.0/255) alpha:1.0];
        
        _numberOfMovesLeft = 100;
        _numOfColumn = 5;
        _numOfRow = 7;
        _switchThreshold = 30;
        _boxSizer = 40;
        _boxSpacer = 50;
        _isAddingSprite = false;
        _screenChanger = self.size.width/320;
     //   [self addChild:myLabel];
        _mainSpriteArrayColumns = [[NSMutableArray alloc] init];
        _mainSpriteArrayRows = [[NSMutableArray alloc] init];
        _mainArray = [[NSMutableArray alloc] init];
        _arrayOfValues = [[NSMutableArray alloc] init];

       // [_mainSpriteArrayRows addObject:_mainSpriteArrayColumns];
        [self setUpMainSprites];
        
        self.physicsWorld.contactDelegate = self;

        
        for(int i = 0; i < _numOfColumn; i++){
            
            SKSpriteNode *addNumber;
            
                addNumber = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:(4.0/255) green:(191.0/255) blue:(191.0/255) alpha:0.9] size:CGSizeMake(_boxSizer, _boxSizer)];
            
            [addNumber setPosition:CGPointMake(_boxSpacer+i*_boxSpacer,50)];
            
            [self addChild:addNumber];
            NSString *string = [NSString stringWithFormat:@"add%d", i+1];
            [addNumber setName:string];


        }
        

    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        
        if([node.name isEqualToString:@"filledSpriteNode"])
        {

            _moverNode = (SKSpriteNode *)node;
            _originalPoint = _moverNode.position;
            _isMoving = true;


        }
     //   NSLog(@"%f", _originalPoint.x);
   
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
         SKNode *node = [self nodeAtPoint:location];

        BOOL isMovingInX;
        

        int holder = [_mainArray indexOfObject:_moverNode];
        if(_didReachThreshold == false && _originalPoint.x != 0 && holder < [_mainArray count]){
            
            if(abs(location.x - _originalPoint.x) > abs(location.y - _originalPoint.y))
            {
                isMovingInX = true;
            }
            else{
                isMovingInX = false;
            }
            
            if(location.x < _originalPoint.x)
            {
                if([_mainArray indexOfObject:_moverNode]%_numOfColumn != 0)
                {
                    if(abs(location.x - _originalPoint.x) >=_switchThreshold)
                    {
                        SKSpriteNode *testNode = (SKSpriteNode *)[_mainArray objectAtIndex:([_mainArray indexOfObject:_moverNode] - 1)];
                        [self switchSpritesTest:_moverNode contactSprite:testNode];
                        _didReachThreshold = true;
                    }
                    [_moverNode setPosition:CGPointMake(location.x, _originalPoint.y)];
                }
            }
            else if (location.x > _originalPoint.x)
            {
                if([_mainArray indexOfObject:_moverNode]%_numOfColumn != (_numOfColumn - 1))
                {
                    if(abs(_originalPoint.x - location.x) >=_switchThreshold)
                    {
                        SKSpriteNode *testNode = (SKSpriteNode *)[_mainArray objectAtIndex:([_mainArray indexOfObject:_moverNode] + 1)];
                        [self switchSpritesTest:_moverNode contactSprite:testNode];
                        _didReachThreshold = true;
                    }
                    [_moverNode setPosition:CGPointMake(location.x, _originalPoint.y)];
                }
            }
            

        }
        
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];

        
        NSLog(@"%d", [_mainArray indexOfObject:node]);
        
        if ([node.name isEqualToString:@"add1"]) {
            
            [self addInSpriteAtValue:1];
        }
        if ([node.name isEqualToString:@"add2"]) {
            
            [self addInSpriteAtValue:2];
        }
        if ([node.name isEqualToString:@"add3"]) {
            
            [self addInSpriteAtValue:3];
        }
        if ([node.name isEqualToString:@"add4"]) {
            
            [self addInSpriteAtValue:4];
        }
        if ([node.name isEqualToString:@"add5"]) {
            
            [self addInSpriteAtValue:5];
        }
    }
    
    if(_didReachThreshold == false){
    [_moverNode setPosition:_originalPoint];
    }
    else{
        _didReachThreshold = false;
    }
    _moverNode = nil;
}

-(void)switchSpritesTest:(SKSpriteNode *)originalSprite contactSprite:(SKSpriteNode *)testSprite{
    
    [self minusMoves];
    int originalSpriteIndex = [_mainArray indexOfObject:originalSprite];
    NSNumber *originalSpriteValue = [_arrayOfValues objectAtIndex:originalSpriteIndex];
    int testSpriteIndex = [_mainArray indexOfObject:testSprite];
    NSNumber *testSpriteValue = [_arrayOfValues objectAtIndex:testSpriteIndex];
    bool counter = false;

    CGPoint testSpriteFirstPoint = testSprite.position;

    
    
    [_mainArray replaceObjectAtIndex:originalSpriteIndex withObject:testSprite];
    [_mainArray replaceObjectAtIndex:testSpriteIndex withObject:originalSprite];
    
    [_arrayOfValues replaceObjectAtIndex:originalSpriteIndex withObject:testSpriteValue];
    [_arrayOfValues replaceObjectAtIndex:testSpriteIndex withObject:originalSpriteValue];

    
    //check original location
    
    if(counter == false)
    {
        counter = [self runAddingCheck:originalSpriteIndex];

    }
    [self runAddingCheck:originalSpriteIndex];

    //check horizontal switch location -- adds vertically
    
    
    if(counter == false)
    {
        counter = [self runAddingCheck:testSpriteIndex];
        
    }
    [self runAddingCheck:testSpriteIndex];
    
    
    SKAction * moveTestSprite = [SKAction moveTo:_originalPoint duration:.1];
    
    //  [originalSprite runAction:finishMoveOriginalSprite]
    _moverNode = nil;
    [originalSprite setPosition:testSprite.position];
    [testSprite runAction:moveTestSprite completion:^{
        
        if(counter == true)
        {
            /*
            if((testSpriteIndex + _numOfColumn ) <= _mainArray.count)
            {
                SKSpriteNode *spriteBelow = [_mainArray objectAtIndex:(testSpriteIndex + _numOfColumn)];
                
                if([spriteBelow.name isEqualToString:@"placeHolderSpriteNode"] == false){
                    
                    [self forceSpriteUp:[_mainArray indexOfObject:spriteBelow]];
                }
                
            }
            if((originalSpriteIndex + _numOfColumn ) <= _mainArray.count)
            {
                SKSpriteNode *spriteBelow = [_mainArray objectAtIndex:(originalSpriteIndex + _numOfColumn)];
                
                if([spriteBelow.name isEqualToString:@"placeHolderSpriteNode"] == false){
                    
                    [self forceSpriteUp:[_mainArray indexOfObject:spriteBelow]];
                }
                
            }
             */
        }
        if(counter == false) {
            
            if([testSprite.name isEqualToString:@"placeHolderSpriteNode"] == true)
            {
                if((testSpriteIndex - _numOfColumn ) >= 0)
                {
                    SKSpriteNode *spriteAboveTest = [_mainArray objectAtIndex:(testSpriteIndex - _numOfColumn)];
                    
                    if([spriteAboveTest.name isEqualToString:@"placeHolderSpriteNode"] == true){
                        
                        [self forceSpriteUp:testSpriteIndex];
                    }
                    
                }
                if((originalSpriteIndex + _numOfColumn) <= [_mainArray count] - 1)
                {
                    SKSpriteNode *spriteBelowTest = [_mainArray objectAtIndex:(originalSpriteIndex + _numOfColumn)];
                    if([spriteBelowTest.name isEqualToString:@"placeHolderSpriteNode"] == false){
                        
                        [self forceSpriteUp:originalSpriteIndex + _numOfColumn];
                    }
                }
                
            }
            else{
                SKAction * moveTestSpriteBack = [SKAction moveTo:testSpriteFirstPoint duration:.1];
                SKAction * moveOriginalSpriteBack = [SKAction moveTo:_originalPoint duration:.1];
                
                [originalSprite runAction:moveOriginalSpriteBack];
                [testSprite runAction:moveTestSpriteBack];
                
                [_mainArray replaceObjectAtIndex:originalSpriteIndex withObject:originalSprite];
                [_mainArray replaceObjectAtIndex:testSpriteIndex withObject:testSprite];
                
                [_arrayOfValues replaceObjectAtIndex:originalSpriteIndex withObject:originalSpriteValue];
                [_arrayOfValues replaceObjectAtIndex:testSpriteIndex withObject:testSpriteValue];
                
                if([testSprite.name isEqualToString:@"placeHolderSpriteNode"] == true)
                {
                    if((testSpriteIndex - _numOfColumn ) >= 0)
                    {
                        SKSpriteNode *spriteAboveTest = [_mainArray objectAtIndex:(testSpriteIndex - _numOfColumn)];
                        
                        if([spriteAboveTest.name isEqualToString:@"placeHolderSpriteNode"] == true){
                            
                            [self forceSpriteUp:testSpriteIndex];
                        }
                        
                    }
                    if((originalSpriteIndex + _numOfColumn) <= [_mainArray count] - 1)
                    {
                        SKSpriteNode *spriteBelowTest = [_mainArray objectAtIndex:(originalSpriteIndex + _numOfColumn)];
                        if([spriteBelowTest.name isEqualToString:@"placeHolderSpriteNode"] == false){
                            
                            [self forceSpriteUp:originalSpriteIndex + _numOfColumn];
                        }
                    }
                    
                }
                
            }
            
            
            
        }
    }];
    
    
    
}

-(void)forceSpriteUp:(int) index{
    
    int originalSpriteIndex = index;
    NSNumber *originalSpriteValue = [_arrayOfValues objectAtIndex:originalSpriteIndex];
    int aboveSpriteIndex = originalSpriteIndex - _numOfColumn;
    NSNumber *testSpriteValue = [_arrayOfValues objectAtIndex:aboveSpriteIndex];
  //  int row = floor(originalSpriteIndex/_numOfColumn);
   // bool counter = false;
    
  //  CGPoint testSpriteFirstPoint = testSprite.position;
    SKSpriteNode *realSpriteMovingUp = [_mainArray objectAtIndex:originalSpriteIndex];
    SKSpriteNode *placeSpriteMovingDown = [_mainArray objectAtIndex:aboveSpriteIndex];
    SKSpriteNode *testNode; // tests if there is another empty space above
    SKSpriteNode *testNode2;// tests if there is a heavy sprite above empty space

  //  realSpriteMovingUp.physicsBody = nil;
  //  placeSpriteMovingDown.physicsBody = nil;
    
    if((aboveSpriteIndex - _numOfColumn) >= 0)
    {
        testNode = [_mainArray objectAtIndex:(aboveSpriteIndex - _numOfColumn)];
    }
    if((aboveSpriteIndex + _numOfColumn) <= [_mainArray count] - 1)
    {
        testNode2 = [_mainArray objectAtIndex:(aboveSpriteIndex + _numOfColumn)];

    }
    
    [_mainArray replaceObjectAtIndex:originalSpriteIndex withObject:placeSpriteMovingDown];
    [_mainArray replaceObjectAtIndex:aboveSpriteIndex withObject:realSpriteMovingUp];
    
    [_arrayOfValues replaceObjectAtIndex:originalSpriteIndex withObject:testSpriteValue];
    [_arrayOfValues replaceObjectAtIndex:aboveSpriteIndex withObject:originalSpriteValue];
    
    SKAction * moveRealSpriteUp = [SKAction moveTo:placeSpriteMovingDown.position duration:.1];
    SKAction * movePlaceSpriteDown = [SKAction moveTo:realSpriteMovingUp.position duration:.1];

    [realSpriteMovingUp runAction:moveRealSpriteUp];
    [placeSpriteMovingDown runAction:movePlaceSpriteDown completion:^{
        [self alignSprites];

        if([testNode.name isEqualToString:@"placeHolderSpriteNode"] == true){
            [self forceSpriteUp:aboveSpriteIndex];

        }
        if([testNode2.name isEqualToString:@"placeHolderSpriteNode"] == false){
            if((originalSpriteIndex + _numOfColumn) <= [_mainArray count] - 1)
            {
            [self forceSpriteUp:originalSpriteIndex + _numOfColumn];
            }
            
            
            int row = floor(aboveSpriteIndex/_numOfColumn);
            
            if(row >= 2)
            {
                
                [self runAddingCheck:aboveSpriteIndex];
            }
            
            
        }
        
    }];
    
}
-(void)switchSpritesConfrimedfor:(int )index1 sprite2:(int )index2 sprite3:(int )index3{
    
    SKSpriteNode *node1 = [_mainArray objectAtIndex:index1];
    SKSpriteNode *node2 = [_mainArray objectAtIndex:index2];
    SKSpriteNode *node3 = [_mainArray objectAtIndex:index3];

    SKAction *spinAction = [SKAction rotateByAngle:720 duration:.5];
    
   // [node1  runAction:spinAction];
   // [node2  runAction:spinAction];
   // [node3  runAction:spinAction];
    
    BOOL isVerticle;
    
    //check if sprites are next to eachother e.g. horizontal
    if(abs(index1 - index2) == 1){
        
        isVerticle = false;
    }
    else{
        isVerticle = true;
    }
    
    //Case when values are added vertically
    if(isVerticle == true){
        SKAction *disappearAction = [SKAction fadeAlphaTo:0 duration:0.6];
        
        int row = floor(index1/_numOfColumn);
        int column = index1%_numOfColumn;
    
        for(int i = row; i < _numOfRow; i ++){
            int location = i*_numOfColumn + column;

            if((location + _numOfColumn*3) <= [_mainArray count] - 1)
            {
                if(i - row >=3){
                    SKSpriteNode *deleteNode = [_mainArray objectAtIndex:location];
                    [deleteNode removeFromParent];

                }
            SKSpriteNode *testNode = [_mainArray objectAtIndex:location + _numOfColumn*3];
            SKSpriteNode *placeNode = [SKSpriteNode spriteNodeWithColor:[UIColor magentaColor] size:CGSizeMake(_boxSizer, _boxSizer)];
                [placeNode setAlpha:0.0];
            [self addChild:placeNode];
            [placeNode setName:@"placeHolderSpriteNode"];
            [placeNode setPosition:testNode.position];
            
            NSNumber * testNumer = [_arrayOfValues objectAtIndex:location + _numOfColumn*3];
            NSNumber * placeNumber = [NSNumber numberWithInt:0];
            
            [_mainArray replaceObjectAtIndex:location withObject:testNode];
            [_mainArray replaceObjectAtIndex:location + _numOfColumn*3 withObject:placeNode];
            [_arrayOfValues replaceObjectAtIndex:location withObject:testNumer];
            [_arrayOfValues replaceObjectAtIndex:location + _numOfColumn*3  withObject:placeNumber];
            
            [testNode runAction:[SKAction moveByX:0 y:+_boxSpacer*3 duration:0.3] completion:^{
                
            }];
            }
            else{
                
                
                SKSpriteNode *testNode = [_mainArray objectAtIndex:location];
                SKSpriteNode *placeNode = [SKSpriteNode spriteNodeWithColor:[UIColor magentaColor] size:CGSizeMake(_boxSizer, _boxSizer)];
                [self addChild:placeNode];
                [placeNode setAlpha:0.0];

                [placeNode setName:@"placeHolderSpriteNode"];
                [placeNode setPosition:CGPointMake(testNode.position.x, testNode.position.y - _boxSpacer*3)];
                
              //  NSNumber * testNumer = [_arrayOfValues objectAtIndex:location + _numOfColumn*3];
                NSNumber * placeNumber = [NSNumber numberWithInt:0];
                
                [_mainArray replaceObjectAtIndex:location withObject:placeNode];
           //     [_mainArray replaceObjectAtIndex:location + _numOfColumn*3 withObject:placeNode];
                [_arrayOfValues replaceObjectAtIndex:location withObject:placeNumber];
          //      [_arrayOfValues replaceObjectAtIndex:location + _numOfColumn*3  withObject:placeNumber];
                [testNode removeFromParent];

                [placeNode runAction:[SKAction moveByX:0 y:+_boxSpacer*3 duration:0.3] completion:^{
                    
                    [self alignSprites];
                }];
            
            }
        }
        


        [node1  runAction:disappearAction completion:^{
            [node1 removeFromParent];
        }];
        [node2  runAction:disappearAction completion:^{
            [node2 removeFromParent];

        }];
        [node3  runAction:disappearAction completion:^{
            [node3 removeFromParent];

        }];
        [self checkIfWon];


    }
    //Case when values are added horizontally
    if(isVerticle == false){
        
    }
    

}

-(void)setUpMainSprites{
    
    int numOfColumns = _numOfColumn;
    int numOfRows = _numOfRow;
    
    for(int i = 0; i < numOfRows; i++)
    {
        
        for(int j = 0; j < numOfColumns; j++)
        {
            
            int rand = arc4random()%18 + 1;
            int num = 6;
            
            SKSpriteNode *squareSprite;
            
            if(rand == 1||rand == 2)
            {
                num = 10;
            }
            if(rand == 3||rand == 4||rand == 5)
            {
                num = 9;
            }
            if(rand == 6||rand == 7||rand == 8||rand == 9)
            {
                num = 8;
            }
            if(rand == 10||rand == 11||rand == 12||rand == 13||rand == 14)
            {
                num = 7;
            }
            if(rand == 15||rand == 16||rand == 17||rand == 18)
            {
                num = 6;
            }
            
            

            NSString *string = [NSString stringWithFormat:@"Number_%d.png", num];
            squareSprite = [SKSpriteNode spriteNodeWithImageNamed:string];
     //       squareSprite.physicsBody = nil; // 1

            squareSprite.size = CGSizeMake(_boxSizer, _boxSizer);
            [_arrayOfValues addObject:[NSNumber numberWithInt:num]];
            
            [squareSprite setPosition:CGPointMake(_boxSpacer+j*_boxSpacer, 400 - i*_boxSpacer)];
            
            [self addChild:squareSprite];
            [_mainArray addObject:squareSprite];
            squareSprite.name = @"filledSpriteNode";
            

        //   [_mainSpriteArrayRows addObject:array];
        }
    }
    
    int test = _numOfColumn*_numOfRow;
        for(int k = 0; k < test; k++)
        {
            NSLog(@"RUN ADDING CHECK - %d", [self runAddingCheckFirstTime:k]);
        }
   // [[_mainArray objectAtIndex:(3*(_numOfRow) + 3)] setAlpha:0];
    //    [[[_mainSpriteArrayRows objectAtIndex:3] objectAtIndex:3] setAlpha:0];
    
}

-(void)addInSpriteAtValue:(int)column{
    
    if(_isAddingSprite == false){
        
        _isAddingSprite = true;
    [self minusMoves];
    int numOfObject = _numOfColumn*(_numOfRow - 1)+(column - 1);
    SKSpriteNode *testNode = [_mainArray objectAtIndex:numOfObject];
    
    if([testNode.name isEqualToString:@"placeHolderSpriteNode"] == true)
    {
        [self alignSprites];
        /*
        int counter1 = 0;
        int counter2 = 0;
        int counter3 = 0;
        int counter4 = 0;
        int counter5 = 0;
         */
        int totalCounter[5];
        int finalTotal = 0;
   //     NSArray *totalCounter = [[NSArray alloc] init];

        for(int k = 0; k < [_arrayOfValues count]; k++)
        {

            int holder = [_arrayOfValues[k] intValue];
         //   NSLog(@"HOLDER = %d", holder);
            
            if(holder != 0)
            {
                 totalCounter[holder - 6] = totalCounter[holder - 6] + 1;
            }
            }
        
        for(int j = 0; j < 5; j++)
        {
            finalTotal = finalTotal + totalCounter[j];
        }
//        NSLog(@"finalTotal = %d", finalTotal);
//        NSLog(@"counter 6 = %d", totalCounter[0]);
//        NSLog(@"counter 7 = %d", totalCounter[1]);
//        NSLog(@"counter 8 = %d", totalCounter[2]);
//        NSLog(@"counter 9 = %d", totalCounter[3]);
//        NSLog(@"counter 10 = %d", totalCounter[4]);

     //   NSNumber* sum = [totalCount valueForKeyPath: @"@sum.self"];

        int rand = arc4random()%18 + 1;
        int num = 6;
        
    SKSpriteNode *squareSprite;

        if(rand == 1||rand == 2)
        {
            num = 10;
        }
        if(rand == 3||rand == 4||rand == 5)
        {
            num = 9;
        }
        if(rand == 6||rand == 7||rand == 8||rand == 9)
        {
            num = 8;
        }
        if(rand == 10||rand == 11||rand == 12||rand == 13||rand == 14)
        {
            num = 7;
        }
        if(rand == 15||rand == 16||rand == 17||rand == 18)
        {
            num = 6;
        }
        NSString *string = [NSString stringWithFormat:@"Number_%d.png", num];
        squareSprite = [SKSpriteNode spriteNodeWithImageNamed:string];
       // squareSprite.physicsBody = nil;
        squareSprite.size = CGSizeMake(_boxSizer, _boxSizer);
        
        
   // [_arrayOfValues addObject:[NSNumber numberWithInt:rand]];
    
  //  [squareSprite setPosition:CGPointMake(_boxSpacer+j*_boxSpacer, 400 - i*_boxSpacer)];
    
        [squareSprite setPosition:testNode.position];
        [testNode removeFromParent];
    [self addChild:squareSprite];
        
    [_mainArray replaceObjectAtIndex:numOfObject withObject:squareSprite];
        squareSprite.name = @"filledSpriteNode";

    [_arrayOfValues replaceObjectAtIndex:numOfObject withObject:[NSNumber numberWithInt:num]];
        
        SKSpriteNode *testAboveNode = [_mainArray objectAtIndex:(numOfObject - _numOfColumn)];
        
        if([testAboveNode.name isEqualToString:@"placeHolderSpriteNode"])
        {
            [self forceSpriteUp:numOfObject];
        }
        else{
          
            [self runAddingCheck:(numOfObject - 2*_numOfColumn)];
          //  [self runAddingCheck:num];
        }

    }
      
        double delay = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (delay) * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //code to be executed on the main queue after delay
            _isAddingSprite = false;
 
        });
        
    }
    
}

-(void)alignSprites{
    
    int numOfColumns = _numOfColumn;
    int numOfRows = _numOfRow;
    
    for(int i = 0; i < numOfRows; i++)
    {
        
        for(int j = 0; j < numOfColumns; j++)
        {
            int index = i*_numOfColumn + j;
            
        SKSpriteNode * testNode = [_mainArray objectAtIndex:index];
        [testNode setPosition:CGPointMake(_boxSpacer+j*_boxSpacer, 400 - i*_boxSpacer)];
            
            if(index - numOfColumns >= 0){
            SKSpriteNode * testNodeAboveNode = [_mainArray objectAtIndex:index - numOfColumns];

                if([testNode.name isEqualToString:@"filledSpriteNode"]){
                if([testNodeAboveNode.name isEqualToString:@"placeHolderSpriteNode"]){
                    [self forceSpriteUp:index];
                    
                }
                }
            }
            
        }
    }
    
    
}

-(BOOL)runAddingCheck:(int)num{
    int row = floor(num/_numOfColumn);
    int scoreAdder = 0;

    BOOL didHappen = false;
        for(int i = 0; i < _numOfRow; i++){
            
            if(abs(row - i) <= 2 && i <= row && i < (_numOfRow - 2))
            {
                int num1 =  num%_numOfColumn + (i)*_numOfColumn;
                int num2 = num%_numOfColumn + (i + 1)*_numOfColumn;
                int num3 = num%_numOfColumn + (i + 2)*_numOfColumn;
                
                int test1 = [[_arrayOfValues objectAtIndex:num1] intValue];
                int test2 = [[_arrayOfValues objectAtIndex:num2] intValue];
                int test3 = [[_arrayOfValues objectAtIndex:num3] intValue];
                if(test1 + test2 + test3 == 23 && test1 != 0 && test2 != 0 && test3 != 0)
                {
                    scoreAdder = test1*test2*test3;
                    NSLog(@"Score Increase By - %d", scoreAdder);
                    
                    [self switchSpritesConfrimedfor:num1 sprite2:num2 sprite3:num3];
                    didHappen = true;
                    
                }
                
            }
        }

    return didHappen;
}


-(BOOL)runAddingCheckFirstTime:(int)num{
    int row = floor(num/_numOfColumn);
    
    BOOL didHappen = false;
    for(int i = 0; i < _numOfRow; i++){
        
        if(abs(row - i) <= 2 && i <= row && i < (_numOfRow - 2))
        {
            int num1 =  num%_numOfColumn + (i)*_numOfColumn;
            int num2 = num%_numOfColumn + (i + 1)*_numOfColumn;
            int num3 = num%_numOfColumn + (i + 2)*_numOfColumn;
            
            int test1 = [[_arrayOfValues objectAtIndex:num1] intValue];
            int test2 = [[_arrayOfValues objectAtIndex:num2] intValue];
            int test3 = [[_arrayOfValues objectAtIndex:num3] intValue];
            if(test1 + test2 + test3 == 23 && test1 != 0 && test2 != 0 && test3 != 0)
            {

                
                
                int rand = arc4random()%18 + 1;
                int num = 6;
                
                SKSpriteNode *squareSprite;
                
                if(rand == 1||rand == 2)
                {
                    num = 10;
                }
                if(rand == 3||rand == 4||rand == 5)
                {
                    num = 9;
                }
                if(rand == 6||rand == 7||rand == 8||rand == 9)
                {
                    num = 8;
                }
                if(rand == 10||rand == 11||rand == 12||rand == 13||rand == 14)
                {
                    num = 7;
                }
                if(rand == 15||rand == 16||rand == 17||rand == 18)
                {
                    num = 6;
                }
                
                
                
                NSString *string = [NSString stringWithFormat:@"Number_%d.png", num];


                SKSpriteNode *testNode = [_mainArray objectAtIndex:num1];
              //  testNode.alpha = 0.0;
             //   testNode.alpha = 0.3;
                [testNode setTexture:[SKTexture textureWithImageNamed:string]];

             //   testNode = [SKSpriteNode spriteNodeWithImageNamed:string];

                
             //   [_mainArray replaceObjectAtIndex:num1 withObject:testNode];
                [_arrayOfValues replaceObjectAtIndex:num1 withObject:[NSNumber numberWithInt:num]];
                
               [self runAddingCheckFirstTime:num1];
                didHappen = true;
                
            }
            
        }
    }
    
    return didHappen;
}

-(void)minusMoves{
    _numberOfMovesLeft = _numberOfMovesLeft - 1;
    
    if(_numberOfMovesLeft <= 0){
        [self restartGame];
    }
    NSLog(@"Number of Moves Left = %d", _numberOfMovesLeft);
    
}

-(void)restartGame{
    SKView * skView = (SKView *)self.view;
    //  skView.showsFPS = YES;
    //  skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * restartScene = [MyScene sceneWithSize:skView.bounds.size];
    
    
    // SKScene *restartScene = [[Scene alloc] initWithSize:self.size];
    restartScene.scaleMode = SKSceneScaleModeAspectFill;
    
    SKTransition *transition = [SKTransition doorsOpenHorizontalWithDuration:0.2];
    [skView presentScene:restartScene transition:transition];
    [skView setClearsContextBeforeDrawing:YES];
    [skView presentScene:restartScene];
}
-(void)checkIfWon{

    int sum = [[_arrayOfValues valueForKeyPath: @"@sum.self"] intValue];
    
    
    NSLog(@"SUM - %d", sum)
    ;    if(sum == 0)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
}





-(void)updateMoveLabel:(int)num{
    
    
   if(0 >= 1000000000){
        
        SKNode *testHolder = [self childNodeWithName:@"winGameHolder"];
        
        //  int previousNum = 0;
        if(testHolder == nil){
            
        }
        else{
            //        SKShapeNode *testShape = (SKShapeNode *)[testHolder childNodeWithName:@"pointBoxNode"];
            //        SKLabelNode *testLabel = (SKLabelNode *)[testShape childNodeWithName:@"pointLabelNode"];
            //        previousNum = [testLabel.text intValue];
            [testHolder removeFromParent];
        }
        
        
        SKNode *holder = [SKNode node];
        holder.name = @"winGameHolder";
        [self addChild:holder];
        holder.zPosition = 100;
        
        
        SKSpriteNode* backgroundImage;
        
        if(self.size.width > 320){
            backgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"winGame_75.png"];
            
        }
        if(self.size.width == 320 && self.size.height == 568){
            backgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"winGame_56.png"];
            
        }
        if(self.size.width == 320 && self.size.height == 480){
            backgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"winGame_66.png"];
        }
        backgroundImage.size = self.size;
        [backgroundImage setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
        
        backgroundImage.name = @"backgroundImageNode";
        
        backgroundImage.alpha = 0.6;
        
        [holder addChild:backgroundImage];
        
        
    }
   // [self changeHue];
    int addScreenHeight = 0;
    if(self.size.height == 568) addScreenHeight = 75;
    else if(self.size.width == 320) addScreenHeight = 30;
    int cornerSize = 15*_screenChanger;
    
  //  _score = _score + num;
    
  //  [[NSUserDefaults standardUserDefaults] setInteger:_score forKey:@"savedScore"];

    
    // NSLog(@"Formatted float: %@ ", [formatter stringFromNumber:number]);
    
    SKNode *testHolder = [self childNodeWithName:@"pointLabelHolder"];
    
    //  int previousNum = 0;
    if(testHolder == nil){
        
    }
    else{
        //        SKShapeNode *testShape = (SKShapeNode *)[testHolder childNodeWithName:@"pointBoxNode"];
        //        SKLabelNode *testLabel = (SKLabelNode *)[testShape childNodeWithName:@"pointLabelNode"];
        //        previousNum = [testLabel.text intValue];
        [testHolder removeFromParent];
    }
    
    //previousNum = previousNum + num;
    // previousNum = arc4random()%10;
    
    NSNumber *number = [NSNumber numberWithInt:0];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    
    SKNode *holder = [SKNode node];
    holder.name = @"pointLabelHolder";
    [self addChild:holder];
    holder.zPosition = 100;
    
    
    SKShapeNode* pointBox = [SKShapeNode node];
    [pointBox setPath:CGPathCreateWithRoundedRect(CGRectMake(-cornerSize, -cornerSize, 200*_screenChanger, 80*_screenChanger), 4*_screenChanger, 4*_screenChanger, nil)];
    pointBox.name = @"pointBoxNode";
    pointBox.strokeColor = pointBox.fillColor = [UIColor grayColor];
    pointBox.position = CGPointMake(self.size.width/2 - pointBox.frame.size.width/2 + cornerSize, (250*_screenChanger + addScreenHeight));
    pointBox.alpha = 0.6;
    
    [holder addChild:pointBox];
    
    SKLabelNode *pointText = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
    pointText.text = @"POINTS!";
    pointText.fontColor = [UIColor whiteColor];
    pointText.fontSize = 20*_screenChanger;
    pointText.position = CGPointMake(pointBox.frame.size.width/2 - cornerSize, 20*_screenChanger);
    [pointBox addChild:pointText];
    
    
    SKLabelNode *pointLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
    pointLabel.text = [formatter stringFromNumber:number];
    pointLabel.name = @"pointLabelNode";
    pointLabel.fontColor = [UIColor whiteColor];
    pointLabel.fontSize = 20*_screenChanger;
    pointLabel.position = CGPointMake(pointBox.frame.size.width/2 - cornerSize, pointText.position.y - 20*_screenChanger);
    [pointBox addChild:pointLabel];
}







-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}



@end
