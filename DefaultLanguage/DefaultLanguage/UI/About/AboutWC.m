//
//  AboutWC.m
//  DefaultLanguage
//
//  Created by hanwe on 16/02/2019.
//  Copyright © 2019 hanwe. All rights reserved.
//

#import "AboutWC.h"

@interface AboutWC ()

@end

@implementation AboutWC

-(id)initWithWindowNibName:(NSNibName)windowNibName withParentsObj:(id)parentsObj
{
    self = [super initWithWindowNibName:windowNibName];
    if(self){
        _parentsObj = parentsObj;
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [self initUI];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}


-(void)initUI
{
    [_imgView setImage:[NSImage imageNamed:@"batch_64iconmonstr-cat-5-240 (1)"]];
    [_versionLabel setStringValue:[NSString stringWithFormat:@"Version : %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    [self.window setLevel:NSTornOffMenuWindowLevel];
}
@end
