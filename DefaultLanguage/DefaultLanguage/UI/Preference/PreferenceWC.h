//
//  PreferenceWC.h
//  DefaultLanguage
//
//  Created by hanwe on 15/02/2019.
//  Copyright © 2019 hanwe. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "SwitchInputSourceModule.h"
#import "LanguageVC.h"
#import "SettingVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface PreferenceWC : NSWindowController
{
#pragma mark - var
    id _parentsObj;
    LanguageVC *_languageVC;
    SettingVC *_settingVC;
    NSView *_languageView;
    NSView *_settingView;
    
    NSView *_currentView;
#pragma mark - outlet
    IBOutlet NSToolbarItem *_languageToolbarItem;
    IBOutlet NSToolbarItem *_optionToolbarItem;
    IBOutlet NSView *_subView;
}

-(id)initWithWindowNibName:(NSNibName)windowNibName withParentsObj:(id)parentsObj;
- (IBAction)languageAction:(id)sender;
- (IBAction)settingAction:(id)sender;
- (IBAction)helpAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
