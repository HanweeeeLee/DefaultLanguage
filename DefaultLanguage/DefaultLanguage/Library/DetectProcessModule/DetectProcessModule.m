//
//  DetectProcessModule.m
//  ProcessDetectTest
//
//  Created by HanWe Lee on 15/01/2019.
//  Copyright © 2019 HanWe Lee. All rights reserved.
//

#import "DetectProcessModule.h"
#import <Carbon/Carbon.h>
#import <Cocoa/Cocoa.h>

DetectProcessModule *detectProcessModulePtr;

@implementation DetectProcessModule

//-(id)init
//{
//    self = [super init];
//    if(self){
//
//    }
//    return self;
//}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"object is singleton" reason:@"" userInfo:nil];
}

+(instancetype)getInstance{
    static DetectProcessModule *_instance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _instance = [[DetectProcessModule alloc] initPrivate];
    });
    return _instance;
}

-(instancetype)initPrivate{
    self = [super init];
    if(self){
        NSLog(@"create DetectProcessModule object");
        detectProcessModulePtr = self;
        _detectProcessDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)addDetectProcessWithProcessName:(NSString *)localizedpName//같은이름 여러개떠있는건 생각 안해봄
{
    [_detectProcessDic setObject:[[ProcessInfoData alloc] init] forKey:localizedpName];
    [[_detectProcessDic objectForKey:localizedpName] setProcessName:localizedpName];
    
    NSArray *runningProcessArr = [[NSWorkspace sharedWorkspace] runningApplications];
    for(int i = 0 ; i < [runningProcessArr count] ; i++){
        NSRunningApplication *runningApp = [runningProcessArr objectAtIndex:i];
        if([[runningApp localizedName] isEqualToString:localizedpName]){
            [[_detectProcessDic objectForKey:localizedpName] setPid:[NSString stringWithFormat:@"%d",[runningApp processIdentifier]]];
            ProcessSerialNumber psn;
            GetProcessForPID([runningApp processIdentifier], &psn);
            [[_detectProcessDic objectForKey:localizedpName] setPsn:psn];
            break;
        }
    }
}

-(void)removeDetectProcessWithProcessName:(NSString *)localizedpName
{
    [_detectProcessDic removeObjectForKey:localizedpName];
}


-(void)detectStart
{
    static EventHandlerRef sCarbonEventsRef = NULL;
    static const EventTypeSpec kEvents[] = {
        { kEventClassApplication, kEventAppLaunched },
        { kEventClassApplication, kEventAppTerminated },
        { kEventClassApplication, kEventAppFrontSwitched}
    };
    
    if (sCarbonEventsRef == NULL) {
        (void) InstallEventHandler(
                                   GetApplicationEventTarget(),
                                   (EventHandlerUPP) CarbonEventHandler,
                                   GetEventTypeCount(kEvents),
                                   kEvents,
                                   (__bridge void *)(self),
                                   &sCarbonEventsRef
                                   );
    }
    NSLog(@"process detectStart");
}

static OSStatus CarbonEventHandler(EventHandlerCallRef inHandlerCallRef,
                                   EventRef            inEvent,
                                   void *              inUserData
                                   )
{
    ProcessSerialNumber psn;
    
    (void) GetEventParameter(
                             inEvent,
                             kEventParamProcessID,
                             typeProcessSerialNumber,
                             NULL,
                             sizeof(psn),
                             NULL,
                             &psn
                             );
    NSString *launchName;
    CFStringRef cfsLaunchName = ((__bridge CFStringRef)launchName);
    NSMutableDictionary *detectDic;
    NSArray * detectProcessNameArr;
    switch ( GetEventKind(inEvent) ) {
        case kEventAppLaunched:
//            NSLog(
//                  @"launched %u.%u",
//                  (unsigned int) psn.highLongOfPSN,
//                  (unsigned int) psn.lowLongOfPSN
//                  );
            
            CopyProcessName(&psn, &cfsLaunchName);
            launchName = ((__bridge NSString *)cfsLaunchName);
//            NSLog(@"name :%@",launchName);
            detectDic = detectProcessModulePtr->_detectProcessDic;
            detectProcessNameArr = [detectDic allKeys];
            for(int i = 0 ; i < [detectProcessNameArr count] ; i++){
                if([launchName isEqualToString:[detectProcessNameArr objectAtIndex:i]]){
//                    NSLog(@"start %@",launchName);
                    [detectProcessModulePtr->_detectProcessModuleDelegate launchProcessWithProcessName:launchName];
                    [[detectDic objectForKey:launchName] setPsn:psn];
                    break;
                }
            }
            break;
        case kEventAppTerminated:
//            NSLog(
//                  @"terminated %u.%u",
//                  (unsigned int) psn.highLongOfPSN,
//                  (unsigned int) psn.lowLongOfPSN
//                  );
            detectDic = detectProcessModulePtr->_detectProcessDic;
            detectProcessNameArr = [detectDic allKeys];
            for(int i = 0 ; i < [detectProcessNameArr count] ; i++){
                ProcessInfoData *infoData = [detectDic objectForKey:[detectProcessNameArr objectAtIndex:i]];
                if((psn.highLongOfPSN == [infoData psn].highLongOfPSN) && (psn.lowLongOfPSN == [infoData psn].lowLongOfPSN)){
//                    NSLog(@"terminated %@",[infoData processName]);
                    [detectProcessModulePtr->_detectProcessModuleDelegate terminatedProcessWithProcessname:[infoData processName]];
                }
            }
            break;
        case kEventAppFrontSwitched:
            CopyProcessName(&psn, &cfsLaunchName);
            launchName = ((__bridge NSString *)cfsLaunchName);
//            NSLog(@"launchName :%@",launchName);
            detectDic = detectProcessModulePtr->_detectProcessDic;
            detectProcessNameArr = [detectDic allKeys];
            for(int i = 0 ; i < [detectProcessNameArr count] ; i++){
                if([[launchName uppercaseString] isEqualToString:[[detectProcessNameArr objectAtIndex:i] uppercaseString]]){
//                    NSLog(@"FrontSwitched %@",launchName);
                    [detectProcessModulePtr->_detectProcessModuleDelegate appFrontSwitchWithProcessNmae:launchName];
                    [[detectDic objectForKey:launchName] setPsn:psn];
                    break;
                }
            }
            break;
        case kEventAppHidden:
            NSLog(@"test");
            break;
        default:
            assert(false);
            
    }
    return noErr;
}

@end

@implementation ProcessInfoData

@end
