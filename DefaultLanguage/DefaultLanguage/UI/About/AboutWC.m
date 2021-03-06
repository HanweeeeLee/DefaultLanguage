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
    [_imgView setImage:[NSImage imageNamed:@"icon_128x128"]];
    [_versionLabel setStringValue:[NSString stringWithFormat:@"Version : %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    [self.window setLevel:NSTornOffMenuWindowLevel];
    NSDateFormatter *today = [[NSDateFormatter alloc] init];
    [today setDateFormat:@"yyyy"];
    NSString *todayYear = [today stringFromDate:[NSDate date]];
    _copyrightLabel.stringValue = [NSString stringWithFormat:@"Copyright %@ hanwe lee All rights reserved",todayYear];
}
@end
