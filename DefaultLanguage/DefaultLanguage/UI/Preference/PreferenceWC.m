//
//  PreferenceWC.m
//  DefaultLanguage
//
//  Created by hanwe on 15/02/2019.
//  Copyright © 2019 hanwe. All rights reserved.
//

#import "PreferenceWC.h"


@interface PreferenceWC ()

@end

@implementation PreferenceWC

-(id)initWithWindowNibName:(NSNibName)windowNibName withParentsObj:(id)parentsObj
{
    self = [super initWithWindowNibName:windowNibName];
    if(self){
        _parentsObj = parentsObj;
        _currentView = nil;
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [self initUI];
    
}

#pragma mark - func

-(void)initUI
{
    _languageVC = [[LanguageVC alloc] initWithNibName:NSStringFromClass([LanguageVC class]) bundle:nil withParentsObj:self];
    _settingVC = [[SettingVC alloc] initWithNibName:NSStringFromClass([SettingVC class]) bundle:nil withParentsObj:self];
//
    _languageView = _languageVC.view;
    _settingView = _settingVC.view;
//
//
    [_subView addSubview:_languageView];
    _currentView = _languageView;
    [_languageToolbarItem setImage:[NSImage imageNamed:@"iconmonstr-language-10-240"]];
    [_optionToolbarItem setImage:[NSImage imageNamed:@"iconmonstr-gear-1-240"]];
    [self.window setLevel:NSTornOffMenuWindowLevel];
}


#pragma mark - action


/**************** not use *******************/

- (IBAction)languageAction:(id)sender {
    if(_currentView != _languageView){
        [_currentView removeFromSuperview];
        [self.window setFrame:NSMakeRect(self.window.frame.origin.x,
                                         self.window.frame.origin.y - (_languageView.frame.size.height - _subView.frame.size.height),
                                         self.window.frame.size.width,
                                         (self.window.frame.size.height -_subView.frame.size.height)+_languageView.frame.size.height)
                      display:YES animate:YES];
        [_subView addSubview:_languageView];
        _currentView = _languageView;
    }
    
}

- (IBAction)settingAction:(id)sender {
    if(_currentView != _settingView){
        [_currentView removeFromSuperview];
        [self.window setFrame:NSMakeRect(self.window.frame.origin.x,
                                         self.window.frame.origin.y - (_settingView.frame.size.height - _subView.frame.size.height),
                                         self.window.frame.size.width,
                                         (self.window.frame.size.height -_subView.frame.size.height)+_settingView.frame.size.height)
                      display:YES animate:YES];
        [_subView addSubview:_settingView];
        _currentView = _settingView;
    }
}

- (IBAction)helpAction:(id)sender {
}
/**************** not use *******************/

@end
