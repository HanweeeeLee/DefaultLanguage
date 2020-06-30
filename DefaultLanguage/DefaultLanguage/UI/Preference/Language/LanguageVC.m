//
//  LanguageVC.m
//  DefaultLanguage
//
//  Created by hanwe on 16/02/2019.
//  Copyright © 2019 hanwe. All rights reserved.
//

#import "LanguageVC.h"
#import "UserCustomData.h"
#import "LocalizableMap.h"
#import "NSString+StringHelper.h"

@interface LanguageVC ()

@end

@implementation LanguageVC

-(id)initWithNibName:(NSNibName)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withParentsObj:(id)parentsObj
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        _parentsObj = parentsObj;
        _g_userCustomDataManager = [UserCustomDataManager getInstance];
        _g_detectProcessModule = [DetectProcessModule getInstance];
        _switchModule = [[SwitchInputSourceModule alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView reloadData];
    [self initUI];
}

-(void)viewDidAppear{
    _allInputSourceDic = [_switchModule getAllInputSourcesList];
    [self refreshInputResourceList];
    [self refreshRunningProccessList];
    _currentSelectedKey = [[_resourcePopupBtn selectedItem] title];
    [_tableView reloadData];
}

#pragma mark - func

-(void)initUI
{
    _tableView.delegate = self;
    if([[_g_userCustomDataManager userCustomDic] count] > 0){
//        [_g_detectProcessModule addDetectProcessWithProcessName:appName];
        _allSavedDataKeys = [[_g_userCustomDataManager userCustomDic] allKeys];
        [_tableView reloadData];
    }
    [_addBtn setTitle:[ADD_BTN_TEXT_CONTENTS localizable]];
    [_removeBtn setTitle:[REMOVE_BTN_CONTENTS localizable]];
    [_addPlzTextLabel setStringValue:[ADD_TEXT_LABEL_CONTENTS localizable]];

}

-(void)refreshInputResourceList
{
    [_resourcePopupBtn removeAllItems];
    NSArray *allKeys = [_allInputSourceDic allKeys];
    [_resourcePopupBtn addItemsWithTitles:allKeys];
}

-(void)refreshRunningProccessList
{
    [_currentRunningProcessPopupBtn removeAllItems];
    NSMutableArray *allProcess = [[self getCurrentRunningProcess] copy];
    [_currentRunningProcessPopupBtn addItemsWithTitles:allProcess];
}

#pragma mark - action
- (IBAction)AddAction:(id)sender {
    
    if([_appNameTextField.stringValue length] != 0 && ![_appNameTextField.stringValue isEqualToString:@" "]){
//        NSLog(@"add action");
        NSString *appName = _appNameTextField.stringValue;
        UserCustomData *data = [[UserCustomData alloc] init];
        [data setAppName:appName];
        [data setSourceID:[_allInputSourceDic objectForKey:_currentSelectedKey]];
        [data setLocalizedSourceName:[[_resourcePopupBtn selectedItem] title]];
        
        [[_g_userCustomDataManager userCustomDic] setObject:data forKey:[appName lowercaseString]];
//        NSLog(@"[_g_userCustomData userCustomDic] : %@",[_g_userCustomData userCustomDic]);
        [_g_detectProcessModule addDetectProcessWithProcessName:appName];
        _allSavedDataKeys = [[_g_userCustomDataManager userCustomDic] allKeys];
        [_tableView reloadData];
        _appNameTextField.stringValue = @"";
        [_g_userCustomDataManager dataSave];
    }
}

- (IBAction)resourcePopupAction:(id)sender {
    _currentSelectedKey = [[_resourcePopupBtn selectedItem] title];
//    NSLog(@"selected :%@",_currentSelectedKey);
}

- (IBAction)removeItemAction:(id)sender {
    if([[_g_userCustomDataManager userCustomDic] count] > 0){
        int selectedRow = (int)[_tableView selectedRow];
//        NSLog(@"selectedRow :%d",selectedRow);
        NSLog(@"key:%@",[_allSavedDataKeys objectAtIndex:selectedRow]);
        NSString *key = [_allSavedDataKeys objectAtIndex:selectedRow];
        [[_g_userCustomDataManager userCustomDic] removeObjectForKey:key];
        _allSavedDataKeys = [[_g_userCustomDataManager userCustomDic] allKeys];
        [_tableView reloadData];
        [_g_userCustomDataManager dataSave];
    }
}

- (IBAction)processSelectPopupAction:(id)sender {
//    NSLog(@"select:%@",[[_currentRunningProcessPopupBtn selectedItem] title]);
    _appNameTextField.stringValue = [[_currentRunningProcessPopupBtn selectedItem] title];
}

#pragma mark - NSTableView Delegate
-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *result = @"";
    if ([[tableColumn identifier] isEqualToString:@"processName"]) {
        return [_allSavedDataKeys objectAtIndex:row];
    }
    if ([[tableColumn identifier] isEqualToString:@"lang"]) {
        UserCustomData *data = [[_g_userCustomDataManager userCustomDic] objectForKey:[_allSavedDataKeys objectAtIndex:row]];
        return [data localizedSourceName];
    }
    
    return result;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSInteger returnValue = 0;
    
    if([[_g_userCustomDataManager userCustomDic] count] > 0){
        returnValue = [[_g_userCustomDataManager userCustomDic] count];
    }
    
    return returnValue;
}

-(NSMutableArray *)getCurrentRunningProcess
{
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    NSArray *processArr;
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
    processArr = [workspace runningApplications];
    
    for(int i = 0 ; i < [processArr count] ; i++){
        NSRunningApplication *app = [processArr objectAtIndex:i];
        NSLog(@"test:%@",[app localizedName]);
        [resultArr addObject:[app localizedName]];
    }
    return resultArr;
}



@end
