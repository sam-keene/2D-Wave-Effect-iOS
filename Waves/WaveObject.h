//
//  WaveObject.h
//  Waves
//
//  Created by Sam Keene on 12/21/15.
//  Copyright © 2015 Sam Keene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WaveObject : NSObject
@property (nonatomic, assign) CGPoint pos;
@property (nonatomic, assign) CGFloat targetHeight;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat speed;
@end
