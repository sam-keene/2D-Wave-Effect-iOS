//
//  WaveNode.h
//  Waves
//
//  Created by Sam Keene on 12/21/15.
//  Copyright © 2015 Sam Keene. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface WaveNode : SKShapeNode
- (void)setupWithCoords:(NSMutableArray *)coords;
- (void)updateWithCoords:(NSMutableArray *)coords;
@end
