//
//  CustomProgressBar.m
//  CustomProgressBarTest
//
//  Created by hanwe on 2018. 5. 16..
//  Copyright © 2018년 hanwe. All rights reserved.
//

#import "CustomProgressBar.h"

#define STRIPE_RECT_X_SIZE 30
#define CUSTOM_PROGRESS_BAR_CORNER_RADIUS 5.5
#define STRIPE_ANIMATION_KEY @"stripe_animation_key"

@interface CustomProgressBar ()
{
    CALayer *_stripeLayer;
    CALayer *_coverLayer;
    NSImage *_stripeImg;
    float _nowPercent;
    float _increment;
    float _nowCoverLayerPointX;
    float _nowStripeLayerPointX;
    float _nowStripeLayerWidth;
}
@end

@implementation CustomProgressBar

- (void)drawRect:(NSRect)dirtyRect {
    [[NSColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1.0f] setFill];
    NSRectFill(dirtyRect);
    [self defaultSet];
    [self setUI];
    [super drawRect:dirtyRect];
}

-(void)defaultSet
{
    [self setWantsLayer:YES];
    _nowPercent = 0;
}

-(void)setUI
{
    [self setCornerRadius:CUSTOM_PROGRESS_BAR_CORNER_RADIUS];
    [self.layer setCornerRadius:[self cornerRadius]];
    
    _stripeLayer = [CALayer layer];
    _stripeLayer.anchorPoint = NSMakePoint(0, 0.5);
    _coverLayer.anchorPoint = NSMakePoint(0, 0.5);
    
    _stripeImg = [self stripesImageWithSize:NSMakeSize(STRIPE_RECT_X_SIZE, 20) withReverse:NO];
    _stripeLayer.masksToBounds = YES;
    _stripeLayer.backgroundColor = [NSColor colorWithPatternImage:_stripeImg].CGColor;
    
    NSRect stripeFrame = NSMakeRect(self.bounds.origin.x, self.bounds.origin.y, _stripeImg.size.width,self.bounds.size.height);
    stripeFrame.origin.x -=_stripeImg.size.width;
    stripeFrame.size.width += _stripeImg.size.width;
    _nowStripeLayerWidth = stripeFrame.size.width;
    _nowStripeLayerPointX = stripeFrame.origin.x;
    
    _stripeLayer.frame = stripeFrame;
    
    _coverLayer = [CALayer layer];
    _coverLayer.backgroundColor = [NSColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1.0f].CGColor;
//    [_coverLayer setCornerRadius:CUSTOM_PROGRESS_BAR_CORNER_RADIUS];
    NSRect coverFrame = self.bounds;
    coverFrame.origin.x = self.bounds.origin.x;
    _nowCoverLayerPointX = coverFrame.origin.x;
    _coverLayer.frame = coverFrame;
    
    [self.layer addSublayer:_stripeLayer];
    [self.layer addSublayer:_coverLayer];
    
    

}

-(void)startStripeAnimation
{
    [_stripeLayer addAnimation:[self stripesAnimation] forKey:STRIPE_ANIMATION_KEY];
}

-(void)stopStripeAnimation
{
    [_stripeLayer removeAnimationForKey:STRIPE_ANIMATION_KEY];
}

-(void)incrementPercent:(float)increment
{
    _increment = increment;
    _nowPercent = _nowPercent + increment;
    NSRect stripeFrame = NSMakeRect(self.bounds.origin.x, self.bounds.origin.y, (self.bounds.size.width)*0.01*_nowPercent,self.bounds.size.height);
    stripeFrame.origin.x -=_stripeImg.size.width;
    stripeFrame.size.width =_nowStripeLayerWidth + ((self.bounds.size.width) * 0.01 * _nowPercent);
    _stripeLayer.frame = stripeFrame;

    NSRect coverFrame = self.bounds;
    coverFrame.origin.x = ((self.bounds.size.width)*0.01*_nowPercent);
    _nowCoverLayerPointX = coverFrame.origin.x;
    _coverLayer.frame = coverFrame;
}

- (CABasicAnimation *)stripesAnimation {
    CABasicAnimation *moveAnim;
    moveAnim          = [CABasicAnimation animationWithKeyPath:@"position.x"];
    moveAnim.fromValue = @( -_stripeImg.size.width );
    moveAnim.byValue  = @( _stripeImg.size.width );
    moveAnim.duration = 0.5;
    moveAnim.removedOnCompletion = NO;
    moveAnim.delegate = self;
    moveAnim.repeatCount = HUGE_VAL;
    moveAnim.autoreverses = NO;
    
    return moveAnim;
}

- (NSImage *)stripesImageWithSize:(NSSize)size withReverse:(BOOL)reverse{
    return [NSImage imageWithSize:size flipped:YES drawingHandler:^BOOL(NSRect dstRect) {
        //// Color Declarations
        NSColor *line1 = [NSColor colorWithCalibratedRed:133.0f/255.0f green:182.0f/255.0f blue:249.0f/255.0f alpha:1.0f];
        NSColor *line2 = [NSColor colorWithCalibratedRed:170.0f/255.0f green:204.0f/255.0f blue:251.0f/255.0f alpha:1.0f];

        
        //// Frames
        NSRect frame = (NSRect){ NSZeroPoint, size };
        
        //// WhiteBackground Drawing
        NSBezierPath* skyBackgroundPath = [NSBezierPath bezierPathWithRect: NSMakeRect(NSMinX(frame), NSMinY(frame), NSWidth(frame), NSHeight(frame))];
        if (reverse)    [line2 setFill];
        else            [line1 setFill];
        [skyBackgroundPath fill];
        
        
        //// Stripe2 Drawing
        NSBezierPath* stripe2Path = [NSBezierPath bezierPath];
        [stripe2Path moveToPoint: NSMakePoint(NSMaxX(frame), NSMinY(frame))];
        [stripe2Path lineToPoint: NSMakePoint(NSMaxX(frame), NSMinY(frame) + 0.50000 * NSHeight(frame))];
        [stripe2Path lineToPoint: NSMakePoint(NSMinX(frame) + 0.50000 * NSWidth(frame), NSMaxY(frame))];
        [stripe2Path lineToPoint: NSMakePoint(NSMinX(frame), NSMaxY(frame))];
        [stripe2Path lineToPoint: NSMakePoint(NSMaxX(frame), NSMinY(frame))];
        [stripe2Path closePath];
        if (reverse)    [line1 setFill];
        else            [line2 setFill];
        [stripe2Path fill];
        
        
        //// Stripe1 Drawing
        NSBezierPath* stripe1Path = [NSBezierPath bezierPath];
        [stripe1Path moveToPoint: NSMakePoint(NSMinX(frame), NSMinY(frame))];
        [stripe1Path lineToPoint: NSMakePoint(NSMinX(frame) + 0.50000 * NSWidth(frame), NSMinY(frame))];
        [stripe1Path lineToPoint: NSMakePoint(NSMinX(frame), NSMinY(frame) + 0.50000 * NSHeight(frame))];
        [stripe1Path lineToPoint: NSMakePoint(NSMinX(frame), NSMinY(frame))];
        [stripe1Path closePath];
        if (reverse)    [line1 setFill];
        else            [line2 setFill];
        [stripe1Path fill];
        
        return YES;
    }];
}

@end
