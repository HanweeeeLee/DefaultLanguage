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
    TISInputSourceRef originSource = TISCopyCurrentKeyboardInputSource();
    NSString *currentInputSourceName = [NSString stringWithFormat:@"%@",TISGetInputSourceProperty(originSource, kTISPropertyInputSourceID)];
    NSLog(@"현재 인풋소스 이름:%@",currentInputSourceName);
    
    if(![sourceID isEqualToString:currentInputSourceName]){
        NSLog(@"변경 바뀌어야하는 :%@ 원래 :%@",sourceID,currentInputSourceName);
        CFArrayRef sourceListCFref = TISCreateInputSourceList (NULL, false);
        NSArray *sourceList = (__bridge NSArray *)sourceListCFref;
        for(int i = 0 ; i < [sourceList count] ; i++){
            TISInputSourceRef sourceForIn = CFArrayGetValueAtIndex(sourceListCFref,i);
            NSString *currentInputSourceName = [NSString stringWithFormat:@"%@",TISGetInputSourceProperty(sourceForIn, kTISPropertyInputSourceID)];
            NSLog(@"current:%@",currentInputSourceName);
            if([currentInputSourceName isEqualToString:sourceID]){
                NSLog(@"변경 :%@",sourceID);
                TISDeselectInputSource(originSource);
                TISSelectInputSource(sourceForIn);
                
                break;
            }
            else {
                NSLog(@" **********currentInputSourceName: %@",currentInputSourceName);
                NSLog(@" ************sourceID :%@",sourceID);
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
