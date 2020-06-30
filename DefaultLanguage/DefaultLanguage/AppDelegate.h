//
//  AppDelegate.h
//  DefaultLanguage
//
//  Created by hanwe on 15/02/2019.
//  Copyright © 2019 hanwe. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PreferenceWC.h"
#import "DetectProcessModule.h"
#import "SwitchInputSourceModule.h"
#import "UserCustomDataManager.h"
#import "AboutWC.h"
#import "CommonData.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,DetectProcessModuleDelegate>
{
#pragma mark - var
    NSImage *_trayImg;
    PreferenceWC *_preferenceWC;
    AboutWC *_aboutWC;
    DetectProcessModule *_g_detectProcessModule;
    UserCustomDataManager *_g_userCustomDataManager;
    SwitchInputSourceModule *_switchModule;
    CommonData *_g_commonData;
#pragma mark - outlet
    IBOutlet NSMenu *_trayMenu;
    IBOutlet NSMenuItem *_aboutItem;
    IBOutlet NSMenuItem *_sourceItem;
    IBOutlet NSMenuItem *_preferenceItem;
    IBOutlet NSMenuItem *_exitItem;
}

#pragma mark - property
@property (strong) NSStatusItem *statusItem;

#pragma mark - action
- (IBAction)clickAboutItem:(id)sender;
- (IBAction)clickSourceAction:(id)sender;
- (IBAction)clickPreferenceAction:(id)sender;
- (IBAction)clickExitAction:(id)sender;

@end

