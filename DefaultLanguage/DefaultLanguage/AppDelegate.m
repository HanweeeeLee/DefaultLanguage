//
//  AppDelegate.m
//  DefaultLanguage
//
//  Created by hanwe on 15/02/2019.
//  Copyright © 2019 hanwe. All rights reserved.
//

#import "AppDelegate.h"
#import "UserCustomData.h"
#import "LocalizableMap.h"
#import "NSString+StringHelper.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

#pragma mark - lifecycle
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self makeTray];
    [self initUI];
    [self initModule];
    if([[[_g_commonData optionDataDic] objectForKey:IS_SHOW_WELCOME_MSG_KEY] boolValue])
        [self showWelcomeUserNoti];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark - func

-(void)showWelcomeUserNoti
{
    NSUserNotification *userNotification = [[NSUserNotification alloc] init];
    userNotification.title = [NSString stringWithFormat:@"%@😺",[WELCOME_USER_NOTI_TITLE localizable]];
    userNotification.informativeText = [WELCOME_USER_NOTI_CONTENTS localizable];
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:userNotification];
}
-(void)makeTray
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    _trayImg = [NSImage imageNamed:@"tray_icon_final"];
    [_statusItem setImage:_trayImg];
    [_statusItem setHighlightMode:YES];
    [_statusItem setMenu:_trayMenu];
}

-(void)initUI
{
    _preferenceWC = [[PreferenceWC alloc] initWithWindowNibName:@"PreferenceWC" withParentsObj:self];
    _aboutWC = [[AboutWC alloc] initWithWindowNibName:@"AboutWC" withParentsObj:self];
    [_preferenceItem setTitle:[PREFERENCE_ITEM_CONTENTS localizable]];
    [_exitItem setTitle:[EXIT_ITEM_CONTENTS localizable]];
}

-(void)initModule
{
    _g_detectProcessModule = [DetectProcessModule getInstance];
    [_g_detectProcessModule detectStart];
    _g_detectProcessModule.detectProcessModuleDelegate = self;
    _switchModule = [[SwitchInputSourceModule alloc] init];
    _g_userCustomDataManager = [UserCustomDataManager getInstance];
    [_g_userCustomDataManager dataLoad];
    if([[_g_userCustomDataManager userCustomDic] count] > 0){
        NSArray *allKeys = [[_g_userCustomDataManager userCustomDic] allKeys];
        for(int i = 0 ; i < [[_g_userCustomDataManager userCustomDic] count] ; i++){
            UserCustomData *data = [[_g_userCustomDataManager userCustomDic] objectForKey:[allKeys objectAtIndex:i]];
            [_g_detectProcessModule addDetectProcessWithProcessName:[data appName]];
        }
    }
    _g_commonData = [CommonData getInstance];
    [_g_commonData dataLoad];
}

#pragma mark - action

- (IBAction)clickAboutItem:(id)sender {
    NSLog(@"clickAboutItem");
    [_aboutWC.window makeKeyAndOrderFront:NSApp];
}

//- (IBAction)clickSourceAction:(id)sender {
//    NSLog(@"clickSourceAction");
//}

- (IBAction)clickPreferenceAction:(id)sender {
    NSLog(@"clickPreferenceAction");
    [_preferenceWC.window makeKeyAndOrderFront:NSApp];
}

- (IBAction)clickExitAction:(id)sender {
    NSLog(@"clickExitAction");
    [NSApp terminate:nil];
}

#pragma mark - delegate
- (void)launchProcessWithProcessName:(nonnull NSString *)processName {
    
}

- (void)terminatedProcessWithProcessname:(nonnull NSString *)processName {
    
}

- (void)appFrontSwitchWithProcessNmae:(nonnull NSString *)processName {
    NSLog(@"%@ front",processName);
    NSString *pName = [NSString stringWithFormat:@"%@",processName];
    UserCustomData * data = [[_g_userCustomDataManager userCustomDic] objectForKey:[pName lowercaseString]];
    if([_switchModule switchInputSource:[data sourceID]]){
//        NSLog(@"변경성공");
    }
    else{
        NSLog(@"fail language replace");
    }
}


@end
