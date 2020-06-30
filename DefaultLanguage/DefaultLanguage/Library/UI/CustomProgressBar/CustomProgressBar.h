//
//  CustomProgressBar.h
//  CustomProgressBarTest
//
//  Created by hanwe on 2018. 5. 16..
//  Copyright © 2018년 hanwe. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface CustomProgressBar : NSView <CAAnimationDelegate>

@property (nonatomic,assign) float cornerRadius;

-(void)incrementPercent:(float)increment;
-(void)stopStripeAnimation;
-(void)startStripeAnimation;

@end
