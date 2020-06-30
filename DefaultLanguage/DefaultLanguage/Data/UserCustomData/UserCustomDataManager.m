//
//  UserCustomData.m
//  DefaultLanguage
//
//  Created by hanwe on 16/02/2019.
//  Copyright © 2019 hanwe. All rights reserved.
//

#import "UserCustomDataManager.h"
#import "CommonDefine.h"

@implementation UserCustomDataManager

- (instancetype)init {
    @throw [NSException exceptionWithName:@"object is singleton" reason:@"" userInfo:nil];
}

+(instancetype)getInstance{
    static UserCustomDataManager *_instance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _instance = [[UserCustomDataManager alloc] initPrivate];
        [_instance setCreateFlag:YES];
    });
    return _instance;
}

-(instancetype)initPrivate{
    self = [super init];
    if(self){
        NSLog(@"create UserCustomDataManager object");
        _userCustomDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(BOOL)dataSave
{
    BOOL result = YES;
//    NSString *myBundlePath = [[NSBundle mainBundle] bundlePath];
//    NSHomeDirectory()
//    /Library/Containers/
    NSString *myBundleId = [[NSBundle mainBundle] bundleIdentifier];
//    /Documents
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:[self userCustomDic]];
//    result = [myData writeToFile:[NSString stringWithFormat:@"%@%@%@",myBundlePath,DEFAULT_SAVE_FILE_PATH,DEFAULT_SAVE_FILE_NAME] atomically:YES];
    result = [myData writeToFile:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),DEFAULT_SAVE_FILE_NAME]
                      atomically:YES];
//    NSLog(@"test :%@",[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),DEFAULT_SAVE_FILE_NAME]);
    
    if(!result){
        NSLog(@"뭐지..");
    }
    return result;
}


-(BOOL)dataLoad
{
    BOOL result = YES;
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *myBundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *myBundleId = [[NSBundle mainBundle] bundleIdentifier];
//    if([fileMgr fileExistsAtPath:[NSString stringWithFormat:@"%@%@%@",myBundlePath,DEFAULT_SAVE_FILE_PATH,DEFAULT_SAVE_FILE_NAME]])
    if([fileMgr fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),DEFAULT_SAVE_FILE_NAME]]){
//        NSLog(@"testSuccess");
//        NSData *myData = [[NSData alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@%@%@",myBundlePath,DEFAULT_SAVE_FILE_PATH,DEFAULT_SAVE_FILE_NAME]];
        NSData *myData = [[NSData alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),DEFAULT_SAVE_FILE_NAME]];
        _userCustomDic = (NSMutableDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:myData];
//        NSLog(@"_userCustomDic :%@",_userCustomDic);
    }
    
    return result;
}

@end
