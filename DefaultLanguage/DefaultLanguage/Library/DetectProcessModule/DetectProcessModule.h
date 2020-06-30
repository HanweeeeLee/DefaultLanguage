//
//  DetectProcessModule.h
//  ProcessDetectTest
//
//  Created by HanWe Lee on 15/01/2019.
//  Copyright © 2019 HanWe Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DetectProcessModuleDelegate <NSObject>

-(void)launchProcessWithProcessName:(NSString *)processName;

-(void)terminatedProcessWithProcessname:(NSString *)processName;

-(void)appFrontSwitchWithProcessNmae:(NSString *)processName;

@end

@interface DetectProcessModule : NSObject
{
    NSMutableDictionary *_detectProcessDic;
}
-(void)detectStart;
-(void)addDetectProcessWithProcessName:(NSString *)localizedpName;
-(void)removeDetectProcessWithProcessName:(NSString *)localizedpName;
+(instancetype)getInstance;

@property (weak,nonatomic) id<DetectProcessModuleDelegate> detectProcessModuleDelegate;

@end

@interface ProcessInfoData : NSObject
{
    
}
@property (nonatomic,assign) NSString *pid;
@property (nonatomic,assign) NSString *processName;
@property (nonatomic,assign) ProcessSerialNumber psn;

@end

NS_ASSUME_NONNULL_END
