//
//  CustomFlatButton.h
//  customBtnTest2
//
//  Created by hanwe on 2018. 5. 17..
//  Copyright © 2018년 hanwe. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CustomFlatButton : NSButton
{
    NSColor *_customBackgroundColor;
    NSColor *_customBezelColor;
    float _customCornerRadius;
    float _customBezelWidth;
}

-(void)setCustomBackgroundColor:(NSColor *)color;
-(void)secCustomBezelColor:(NSColor *)color;
-(void)setCustomCornerRadius:(float)radius;
-(void)setCustomBezelWidth:(float)width;

@end
