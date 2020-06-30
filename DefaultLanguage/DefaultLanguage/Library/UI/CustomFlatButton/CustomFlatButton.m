//
//  CustomFlatButton.m
//  customBtnTest2
//
//  Created by hanwe on 2018. 5. 17..
//  Copyright © 2018년 hanwe. All rights reserved.
//

#import "CustomFlatButton.h"

@implementation CustomFlatButton

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    _customBackgroundColor = [NSColor whiteColor];
    _customBezelColor = [NSColor colorWithRed:133.0f/255.0f green:182.0f/255.0f blue:249.0f/255.0f alpha:1.0];
    _customCornerRadius = 10.5;
    _customBezelWidth = 1.0f;
    return self;
}

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [self setWantsLayer:YES];
    [super drawRect:dirtyRect];
    [self.layer setCornerRadius:_customCornerRadius];
    [self.layer setBackgroundColor:_customBackgroundColor.CGColor];
    
    [self.layer setMasksToBounds:YES];
    [self.layer setBorderWidth:_customBezelWidth];
    [self.layer setBorderColor:_customBezelColor.CGColor];
}

-(void)setCustomBackgroundColor:(NSColor *)color
{
    _customBackgroundColor = color;
}
-(void)secCustomBezelColor:(NSColor *)color
{
    _customBezelColor = color;
}
-(void)setCustomCornerRadius:(float)radius
{
    _customCornerRadius = radius;
}
-(void)setCustomBezelWidth:(float)width
{
    _customBezelWidth = width;
}

@end
