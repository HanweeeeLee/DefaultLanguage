//
//  LanguageVC.h
//  DefaultLanguage
//
//  Created by hanwe on 16/02/2019.
//  Copyright © 2019 hanwe. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UserCustomDataManager.h"
#import "SwitchInputSourceModule.h"
#import "DetectProcessModule.h"
NS_ASSUME_NONNULL_BEGIN

@interface LanguageVC : NSViewController <NSTableViewDelegate, NSTableViewDataSource>
{
#pragma mark - var
    id _parentsObj;
    UserCustomDataManager *_g_userCustomDataManager;
    SwitchInputSourceModule *_switchModule;
    DetectProcessModule *_g_detectProcessModule;
    
    NSMutableDictionary *_allInputSourceDic;
    NSArray *_allSavedDataKeys;
    NSString *_currentSelectedKey;
#pragma mark - outlet
    IBOutlet NSTextField *_appNameTextField;
    IBOutlet NSPopUpButton *_resourcePopupBtn;
    IBOutlet NSButton *_addBtn;
    IBOutlet NSTableView *_tableView;
    IBOutlet NSButton *_removeBtn;
    IBOutlet NSTextField *_addPlzTextLabel;
    IBOutlet NSPopUpButton *_currentRunningProcessPopupBtn;
}

-(id)initWithNibName:(NSNibName)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withParentsObj:(id)parentsObj;
- (IBAction)AddAction:(id)sender;
- (IBAction)resourcePopupAction:(id)sender;
- (IBAction)removeItemAction:(id)sender;
- (IBAction)processSelectPopupAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
