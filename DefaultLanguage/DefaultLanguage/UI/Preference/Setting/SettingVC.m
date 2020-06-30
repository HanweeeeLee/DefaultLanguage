//
//  SettingVC.m
//  DefaultLanguage
//
//  Created by hanwe on 16/02/2019.
//  Copyright © 2019 hanwe. All rights reserved.
//

#import "SettingVC.h"
#import "LocalizableMap.h"
#import "NSString+StringHelper.h"

@interface SettingVC ()

@end

@implementation SettingVC


-(id)initWithNibName:(NSNibName)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withParentsObj:(id)parentsObj
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        _parentsObj = parentsObj;
        _g_commonData = [CommonData getInstance];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

-(void)initUI
{
    if([[[_g_commonData optionDataDic] objectForKey:IS_SHOW_WELCOME_MSG_KEY] boolValue]){
        [_welcomeMSGCheckBox setState:NSControlStateValueOn];
    }
    else{
        [_welcomeMSGCheckBox setState:NSControlStateValueOff];
    }
    if([[[_g_commonData optionDataDic] objectForKey:IN_AUTO_RUNNING_WHEN_BOOTING_KEY] boolValue]){
        [_autoRunningCheckBox setState:NSControlStateValueOn];
    }
    else{
        [_autoRunningCheckBox setState:NSControlStateValueOff];
    }
    _autoRunningTextLabel.stringValue = [AUTO_RUNNING_OPTION_TITLE localizable];
    _welcomeMSGTextLabel.stringValue = [WELCOM_MSG_OPTION_TITLE localizable];
    _autoRunningCheckBox.title = [OPTION_CHECK_BOX_TITLE localizable];
    _welcomeMSGCheckBox.title = [OPTION_CHECK_BOX_TITLE localizable];
    
}


- (IBAction)autoRunningCheckBoxAction:(id)sender {
    NSURL *preurl = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"file://%@",[[NSBundle mainBundle] bundlePath]]];
    CFURLRef url = CFBridgingRetain(preurl);
    // Create a reference to the shared file list.
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    
    if([_autoRunningCheckBox state] == NSControlStateValueOn){
        [[_g_commonData optionDataDic] setObject:[NSNumber numberWithBool:YES] forKey:IN_AUTO_RUNNING_WHEN_BOOTING_KEY];
        [self enableLoginItemWithLoginItemsReference:loginItems ForPath:url];
        [_g_commonData dataSave];
    }
    else{
        [[_g_commonData optionDataDic] setObject:[NSNumber numberWithBool:NO] forKey:IN_AUTO_RUNNING_WHEN_BOOTING_KEY];
        NSLog(@"test :%@",[[_g_commonData optionDataDic] objectForKey:IN_AUTO_RUNNING_WHEN_BOOTING_KEY]);
        [self disableLoginItemWithLoginItemsReference:loginItems ForPath:url];
        [_g_commonData dataSave];
    }
    CFRelease(loginItems);
}

- (IBAction)welcomeMSGCheckBoxAction:(id)sender {
    if([_welcomeMSGCheckBox state] == NSControlStateValueOn){
        [[_g_commonData optionDataDic] setObject:[NSNumber numberWithBool:YES] forKey:IS_SHOW_WELCOME_MSG_KEY];
        NSLog(@"test :%@",[[_g_commonData optionDataDic] objectForKey:IS_SHOW_WELCOME_MSG_KEY]);
        [_g_commonData dataSave];
    }
    else{
        [[_g_commonData optionDataDic] setObject:[NSNumber numberWithBool:NO] forKey:IS_SHOW_WELCOME_MSG_KEY];
        NSLog(@"test :%@",[[_g_commonData optionDataDic] objectForKey:IS_SHOW_WELCOME_MSG_KEY]);
        [_g_commonData dataSave];
    }
}





- (void)enableLoginItemWithLoginItemsReference:(LSSharedFileListRef )theLoginItemsRefs ForPath:(CFURLRef)thePath {
    // We call LSSharedFileListInsertItemURL to insert the item at the bottom of Login Items list.
    LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(theLoginItemsRefs, kLSSharedFileListItemLast, NULL, NULL, thePath, NULL, NULL);
    if (item)
        CFRelease(item);
}

- (void)disableLoginItemWithLoginItemsReference:(LSSharedFileListRef )theLoginItemsRefs ForPath:(CFURLRef)thePath {
    UInt32 seedValue;
    
    // We're going to grab the contents of the shared file list (LSSharedFileListItemRef objects)
    // and pop it in an array so we can iterate through it to find our item.
    NSArray  *loginItemsArray = (__bridge NSArray *)LSSharedFileListCopySnapshot(theLoginItemsRefs, &seedValue);
    for (id item in loginItemsArray) {
        LSSharedFileListItemRef itemRef = (__bridge LSSharedFileListItemRef)item;
        if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &thePath, NULL) == noErr) {
            if ([[(__bridge NSURL *)thePath path] hasPrefix:[[NSBundle mainBundle] bundlePath]])
                LSSharedFileListItemRemove(theLoginItemsRefs, itemRef); // Deleting the item
        }
    }
    
    //    [loginItemsArray release];
}

@end
