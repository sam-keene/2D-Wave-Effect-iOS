//
//  GameScene.m
//  Waves
//
//  Created by Sam Keene on 12/21/15.
//  Copyright (c) 2015 Sam Keene. All rights reserved.
//

#import "GameScene.h"
#import "WaveObject.h"
#import "WaveNode.h"

@interface GameScene ()

// SPRING STUFF
@property (nonatomic, assign) CGFloat tension;
@property (nonatomic, assign) CGFloat dampening;
@property (nonatomic, assign) CGFloat spread;

// waves
@property (nonatomic, assign) CGFloat wavesNum;
@property (nonatomic, strong) NSMutableArray *waves;
@property (nonatomic, strong) NSDate *lastWave;
@property (nonatomic, assign) CGFloat waveDelay;

@property (nonatomic, strong) WaveNode *waveNode;
@property (nonatomic, strong) SKShapeNode *yourline;
@property (nonatomic, assign) CGSize screenSize;
@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    self.backgroundColor = [SKColor blackColor];
    
    self.screenSize = [[UIScreen mainScreen] bounds].size;
    
    self.wavesNum = 100;
    self.waves = [NSMutableArray array];
    self.lastWave = [NSDate date];
    self.waveDelay = 500;
    
    self.tension = .025; //.2;//
    self.dampening = .02;//.025,
    self.spread = .3;//.25;
    
    
    for(NSInteger i = 0; i < self.wavesNum; i++){
        CGFloat x =  ceil(self.screenSize.width/self.wavesNum)*i;
        CGFloat y = self.screenSize.height - (self.screenSize.height/3)*2;
        CGPoint point = CGPointMake(x, y);
        WaveObject *waveObject = [[WaveObject alloc] init];
        waveObject.pos = point;
        waveObject.height = self.screenSize.height - y;
        waveObject.targetHeight = self.screenSize.height - y;
        waveObject.speed = 0;
        [self.waves addObject:waveObject];
    }
    
    self.waveNode = [WaveNode node];
    self.waveNode.position = CGPointMake(self.screenSize.width/2., self.screenSize.height/2.);
    [self addChild:self.waveNode];
    
    self.yourline = [SKShapeNode node];
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, 100.0, 100.0);
    CGPathAddLineToPoint(pathToDraw, NULL, 50.0, 50.0);
    self.yourline.path = pathToDraw;
    [self.yourline setStrokeColor:[UIColor whiteColor]];
    [self addChild:self.yourline];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        NSInteger num = floorf(location.x / (self.screenSize.width/self.wavesNum));
        WaveObject *waveObject = self.waves[num];
        waveObject.speed -= location.y;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    
    
    // randomly make waves
//    if ([self randomValueBetween:0 andValue:100] < 3) {
//        self.lastWave = [NSDate date];
//        self.waveDelay = floor([self randomValueBetween:0 andValue:1000]);
//        NSInteger num = floorf([self randomValueBetween:0 andValue:self.wavesNum]);
//        WaveObject *waveObject = self.waves[num];
//        waveObject.speed -= 20 + [self randomValueBetween:0 andValue:80];
//    }
   
    
    for (NSInteger i = 0; i < self.wavesNum; i++) {
        WaveObject *waveObject = self.waves[i];
        CGFloat heightDiff = waveObject.targetHeight - waveObject.height;
        waveObject.speed += self.tension * heightDiff - waveObject.speed * self.dampening;
        waveObject.height += waveObject.speed;
    }
    
    NSMutableArray *lDeltas = [NSMutableArray array];
    NSMutableArray *rDeltas = [NSMutableArray array];
    
    [lDeltas addObject:[NSNumber numberWithFloat:0]];
    
    for (NSInteger i = 0; i < self.wavesNum; i++) {
        if (i > 0){
            WaveObject *waveObject = [self.waves objectAtIndex:i];
            WaveObject *previousWaveObject = [self.waves objectAtIndex:i-1];
            
            CGFloat delta = self.spread * (waveObject.height - previousWaveObject.height);
            previousWaveObject.speed += delta;
            
            [lDeltas addObject:[NSNumber numberWithFloat:delta]];
        }
        
        if (i < self.wavesNum - 1){
            WaveObject *waveObject = [self.waves objectAtIndex:i];
            WaveObject *nextWaveObject = [self.waves objectAtIndex:i+1];
            
            CGFloat delta = self.spread * (waveObject.height - nextWaveObject.height);
            
            [rDeltas addObject:[NSNumber numberWithFloat:delta]];
            nextWaveObject.speed += delta;
        }
    }
    
    [rDeltas addObject:[NSNumber numberWithFloat:0]];
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    for (NSInteger i = 0; i < self.wavesNum; i++) {
        
        if (i > 0){
            WaveObject *previousWaveObject = [self.waves objectAtIndex:i-1];
            previousWaveObject.height += [[lDeltas objectAtIndex:i] floatValue];
        }
        
        if (i < self.waves.count - 1){
            WaveObject *nextWaveObject = [self.waves objectAtIndex:i+1];
            nextWaveObject.height += [[rDeltas objectAtIndex:i] floatValue];
        }
        
        WaveObject *waveObject = [self.waves objectAtIndex:i];
        waveObject.pos = CGPointMake(waveObject.pos.x, self.screenSize.height - waveObject.height);
        
        if (i == 0) {
            WaveObject *waveObjectFirst = [self.waves objectAtIndex:0];
            CGPathMoveToPoint(path, NULL, waveObjectFirst.pos.x, waveObjectFirst.pos.y);
        }
        
        if (i< self.wavesNum-1) {
            WaveObject *waveObjectNew = [self.waves objectAtIndex:i];
            CGPathAddLineToPoint(path, NULL, waveObjectNew.pos.x, waveObjectNew.pos.y);
        }
    }
    
    
    self.yourline.path = path;
}

- (float)randomValueBetween:(float)low andValue:(float)high {
    return (((float) arc4random() / 0xFFFFFFFFu) * (high - low)) + low;
}
@end
