//
//  SwitchInputSourceModule.m
//  testtest
//
//  Created by HanWe Lee on 15/02/2019.
//  Copyright © 2019 HanWe Lee. All rights reserved.
//

#import "SwitchInputSourceModule.h"
#include <Carbon/Carbon.h>

@implementation SwitchInputSourceModule

-(id)init
{
    self = [super init];
    if(self){
//        _exceptionInputSourceList = [[NSMutableArray alloc] init];
//        [_exceptionInputSourceList addObject:@"com.apple.PressAndHold"];
//        [_exceptionInputSourceList addObject:@"com.apple.KeyboardViewer"];
//        [_exceptionInputSourceList addObject:@"com.apple.CharacterPaletteIM"];
//        [_exceptionInputSourceList addObject:@"com.apple.inputmethod.Korean"];
        _currentSelectedIndex = 0;
        _totalInputSourceCnt = 0;
        [self findTotalInputSourceAndCurrentIndex];
    }
    return self;
}

-(void)findTotalInputSourceAndCurrentIndex
{
    TISInputSourceRef source = TISCopyCurrentKeyboardInputSource();
    NSLog(@"이게이름인가 :%@",TISGetInputSourceProperty(source, kTISPropertyInputSourceID));
    NSString *currentInputSourceName = [NSString stringWithFormat:@"%@",TISGetInputSourceProperty(source, kTISPropertyInputSourceID)];
    CFArrayRef sourceListCFref = TISCreateInputSourceList (NULL, false);
    NSArray *sourceList = (__bridge NSArray *)sourceListCFref;
//    NSLog(@"인풋소스리스트??? :%@",sourceList);
//    _totalInputSourceCnt = (int)[sourceList count];
    for(int i = 0 ; i <[sourceList count] ; i++) {
        if(kTISCategoryKeyboardInputSource != TISGetInputSourceProperty(sourceListCFref, kTISPropertyInputSourceCategory)){
            _totalInputSourceCnt++;
        }
    }
    for(int i = 0 ; i < [sourceList count] ; i ++){
//        NSLog(@"%d",i);
        TISInputSourceRef sourceForIn = CFArrayGetValueAtIndex(sourceListCFref,i);
        NSString *sourceIdName = [NSString stringWithFormat:@"%@",TISGetInputSourceProperty(sourceForIn, kTISPropertyInputSourceID)];
//        for(int j = 0 ; j <[_exceptionInputSourceList count] ; j++){
//            if([sourceIdName isEqualToString:[_exceptionInputSourceList objectAtIndex:j]])
//                continue;
//        }
        if([currentInputSourceName isEqualToString:sourceIdName]){
            _currentSelectedIndex = i;
            break;
        }
    }
}

-(BOOL)switchNextInputSource{
    BOOL result = YES;
//    TISInputSourceRef source = TISCopyCurrentKeyboardInputSource();

    CFArrayRef sourceListCFref = TISCreateInputSourceList (NULL, false);
//    NSArray *sourceList = (__bridge NSArray *)sourceListCFref;

    int nextNumber = _currentSelectedIndex;
    while (1) {
        nextNumber++;
        if(nextNumber >= _totalInputSourceCnt)
            nextNumber = 0;
        TISInputSourceRef currentInputSource = CFArrayGetValueAtIndex(sourceListCFref,nextNumber);
//        NSString *currentIndexStr = [NSString stringWithFormat:@"%@",TISGetInputSourceProperty(currentInputSource, kTISPropertyInputSourceID)];
        if(kTISCategoryKeyboardInputSource != TISGetInputSourceProperty(currentInputSource, kTISPropertyInputSourceCategory)){
            nextNumber++;
            continue;
        }
        if(_currentSelectedIndex == nextNumber){
//            NSLog(@"not found");
            result = NO;
        }
        break;
    }
    
    if(result){
        TISInputSourceRef newInputSource = CFArrayGetValueAtIndex(sourceListCFref,nextNumber);
//        NSLog(@"now lang:%@",newInputSource);
        _currentSelectedIndex = nextNumber;
        TISSelectInputSource(newInputSource);
    }
    
    return result;
}

-(BOOL)switchInputSource:(NSString *)sourceID
{
    BOOL result = YES;
//    usleep(0.2* 1000 * 1000);
    TISInputSourceRef source = TISCopyCurrentKeyboardInputSource();
//    NSLog(@"이게이름인가 :%@",TISGetInputSourceProperty(source, kTISPropertyInputSourceID));
    
    if(![sourceID isEqualToString:[NSString stringWithFormat:@"%@",TISGetInputSourceProperty(source, kTISPropertyInputSourceID)]]){
//        NSLog(@"변경");
        TISInputSourceRef beforeSource = source;
        TISDeselectInputSource(source);
        TISDisableInputSource(source);
       

        CFArrayRef sourceListCFref = TISCreateInputSourceList (NULL, false);
        NSArray *sourceList = (__bridge NSArray *)sourceListCFref;
        for(int i = 0 ; i < [sourceList count] ; i++){
            TISInputSourceRef sourceForIn = CFArrayGetValueAtIndex(sourceListCFref,i);
//                    NSLog(@"이게이름인가 :%@",TISGetInputSourceProperty(sourceForIn, kTISPropertyInputSourceID));
            NSString *currentInputSourceName = [NSString stringWithFormat:@"%@",TISGetInputSourceProperty(sourceForIn, kTISPropertyInputSourceID)];
            if(![currentInputSourceName isEqualToString:sourceID]){
                NSLog(@" **********currentInputSourceName: %@",currentInputSourceName);
                NSLog(@" ************sourceID :%@",sourceID);
                result = NO;
            }
            else{
                result = YES;
//                NSLog(@"왜딴거찍어 :%@",[NSString stringWithFormat:@"%@",TISGetInputSourceProperty(sourceForIn, kTISPropertyInputSourceID)]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    OSStatus status;

                    TISEnableInputSource(sourceForIn);
                    status = TISSelectInputSource(sourceForIn);
                    TISEnableInputSource(beforeSource);
                    
//                     NSLog(@"이전 :%@",TISGetInputSourceProperty(source, kTISPropertyInputSourceID));
                    if (status != noErr){
                        NSLog(@"err");
                    }
//                    NSLog(@"변경시도");
                    NSLog(@"왜딴거찍어 :%@",[NSString stringWithFormat:@"%@",TISGetInputSourceProperty(sourceForIn, kTISPropertyInputSourceID)]);
                    TISInputSourceRef resultSource = TISCopyCurrentKeyboardInputSource();
                    NSLog(@"결과 :%@",TISGetInputSourceProperty(resultSource, kTISPropertyInputSourceID));
                    if(TISGetInputSourceProperty(resultSource, kTISPropertyInputSourceID) != TISGetInputSourceProperty(sourceForIn, kTISPropertyInputSourceID)){
                        NSLog(@"여기에 들어오다니..");
//                        usleep(0.1 * 1000 * 1000);
                        TISEnableInputSource(sourceForIn);
                        TISSelectInputSource(sourceForIn);
                        TISEnableInputSource(beforeSource);
                    }
//                    kTISNotifyEnabledKeyboardInputSourcesChanged;
                });
                
                break;
            }
        }
    }
    
    return result;
}

-(NSMutableDictionary *)getAllInputSourcesList
{
    NSMutableDictionary * resultDic = [[NSMutableDictionary alloc] init];
    
    CFArrayRef sourceListCFref = TISCreateInputSourceList (NULL, false);
    NSArray *sourceList = (__bridge NSArray *)sourceListCFref;
    
    for(int i = 0 ; i <[sourceList count] ; i++) {
        TISInputSourceRef sourceForIn = CFArrayGetValueAtIndex(sourceListCFref,i);
        if(kTISCategoryKeyboardInputSource == TISGetInputSourceProperty(sourceForIn, kTISPropertyInputSourceCategory)){
            NSString *sourceIdName = [NSString stringWithFormat:@"%@",TISGetInputSourceProperty(sourceForIn, kTISPropertyInputSourceID)];
            NSString *localizedName = [NSString stringWithFormat:@"%@",TISGetInputSourceProperty(sourceForIn, kTISPropertyLocalizedName)];
            if([localizedName isEqualToString:@"한국어"])
                continue;
            [resultDic setObject:sourceIdName forKey:localizedName];
        }
    }
    
    return resultDic;
}
@end
