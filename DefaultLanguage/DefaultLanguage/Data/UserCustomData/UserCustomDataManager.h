//
//  UserCustomData.h
//  DefaultLanguage
//
//  Created by hanwe on 16/02/2019.
//  Copyright © 2019 hanwe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserCustomDataManager : NSObject

@property BOOL createFlag;
@property (nonatomic) NSMutableDictionary *userCustomDic;

+(instancetype)getInstance;

-(BOOL)dataSave;
-(BOOL)dataLoad;

@end

NS_ASSUME_NONNULL_END
