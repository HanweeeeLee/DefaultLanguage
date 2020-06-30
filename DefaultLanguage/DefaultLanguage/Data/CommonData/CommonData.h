//
//  CommonData.h
//  DefaultLanguage
//
//  Created by hanwe on 16/02/2019.
//  Copyright © 2019 hanwe. All rights reserved.
//

#import <Foundation/Foundation.h>

/**********keys***********/
#define IS_SHOW_WELCOME_MSG_KEY @"IS_SHOW_WELCOME_MSG_KEY"
#define IN_AUTO_RUNNING_WHEN_BOOTING_KEY @"IN_AUTO_RUNNING_WHEN_BOOTING_KEY"
/*************************/

NS_ASSUME_NONNULL_BEGIN

@interface CommonData : NSObject

@property (atomic) NSMutableDictionary *optionDataDic;

@property BOOL createFlag;

+(instancetype)getInstance;

-(BOOL)dataSave;
-(BOOL)dataLoad;

@end

NS_ASSUME_NONNULL_END
