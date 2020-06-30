//
//  SettingVC.h
//  DefaultLanguage
//
//  Created by hanwe on 16/02/2019.
//  Copyright © 2019 hanwe. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CommonData.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingVC : NSViewController
{
    id _parentsObj;
    CommonData *_g_commonData;
    
    IBOutlet NSTextField *_autoRunningTextLabel;
    IBOutlet NSTextField *_welcomeMSGTextLabel;
    IBOutlet NSButton *_autoRunningCheckBox;
    IBOutlet NSButton *_welcomeMSGCheckBox;
}
-(id)initWithNibName:(NSNibName)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withParentsObj:(id)parentsObj;

- (IBAction)autoRunningCheckBoxAction:(id)sender;
- (IBAction)welcomeMSGCheckBoxAction:(id)sender;
- (void)enableLoginItemWithLoginItemsReference:(LSSharedFileListRef )theLoginItemsRefs ForPath:(CFURLRef)thePath;
- (void)disableLoginItemWithLoginItemsReference:(LSSharedFileListRef )theLoginItemsRefs ForPath:(CFURLRef)thePath;
@end

NS_ASSUME_NONNULL_END
