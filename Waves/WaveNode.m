//
//  WaveNode.m
//  Waves
//
//  Created by Sam Keene on 12/21/15.
//  Copyright © 2015 Sam Keene. All rights reserved.
//

#import "WaveNode.h"
#import "WaveObject.h"

@interface WaveNode ()
@property (nonatomic, strong) NSMutableArray *coords;
@end

@implementation WaveNode
- (void)setupWithCoords:(NSMutableArray *)coords
{
    self.coords = [coords copy];
    
    [self draw];
    
    /*
     out.beginPath();
     out.moveTo(coords[0], coords[1]);
     for(var i = 1; i < [coords count]; i++)
     out.lineTo(coords[2 * i], coords[2 * i + 1]);
     out.lineTo(coords[0], coords[1]);
     out.stroke();
     }
     */
}

- (void)updateWithCoords:(NSMutableArray *)coords
{
    self.path = [self linePathWithPoints:coords];
}

- (void)draw
{
    self.path = [self linePathWithPoints:self.coords];
    
    self.lineWidth = 0;    //self.width;
    self.fillColor = [UIColor colorWithRed:172./255. green:113./255. blue:146./255. alpha:1.];
    //[self setStrokeColor:[UIColor greenColor]];
}

- (CGPathRef)linePathWithPoints:(NSMutableArray *)pointsArray
{
    NSValue *val = [pointsArray objectAtIndex:0];
    CGPoint p = [val CGPointValue];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, p.x, p.y);
    
    for(int i = 1; i < 200; i++)
    {
        val = [pointsArray objectAtIndex:i];
        p = [val CGPointValue];
        CGPathAddLineToPoint(path, NULL,p.x, p.y);
    }
    
    // join it at the start
    val = [pointsArray objectAtIndex:0];
    p = [val CGPointValue];
    
    CGPathAddLineToPoint(path, NULL,p.x, p.y);
    return path;
}

@end
