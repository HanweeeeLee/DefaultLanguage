//
//  CommonData.m
//  DefaultLanguage
//
//  Created by hanwe on 16/02/2019.
//  Copyright © 2019 hanwe. All rights reserved.
//

#import "CommonData.h"
#import "CommonDefine.h"

@implementation CommonData

- (instancetype)init {
    @throw [NSException exceptionWithName:@"object is singleton" reason:@"" userInfo:nil];
}

+(instancetype)getInstance{
    static CommonData *_instance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _instance = [[CommonData alloc] initPrivate];
        [_instance setCreateFlag:YES];
    });
    return _instance;
}

-(instancetype)initPrivate{
    self = [super init];
    if(self){
        NSLog(@"create CommonData object");
//        [self setIsShowWelcomeMSG:YES];
//        [self setIsAutoRunningWhenBooting:YES];
        _optionDataDic = [[NSMutableDictionary alloc] init];
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
//    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:[self userCustomDic]];
    //    result = [myData writeToFile:[NSString stringWithFormat:@"%@%@%@",myBundlePath,DEFAULT_SAVE_FILE_PATH,DEFAULT_SAVE_FILE_NAME] atomically:YES];
    result = [_optionDataDic writeToFile:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),DEFAULT_OPTION_FILE_NAME]
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
    NSLog(@"path :%@",[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),DEFAULT_OPTION_FILE_NAME]);
    //    if([fileMgr fileExistsAtPath:[NSString stringWithFormat:@"%@%@%@",myBundlePath,DEFAULT_SAVE_FILE_PATH,DEFAULT_SAVE_FILE_NAME]])
    if([fileMgr fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),DEFAULT_OPTION_FILE_NAME]]){
        //        NSLog(@"testSuccess");
        //        NSData *myData = [[NSData alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@%@%@",myBundlePath,DEFAULT_SAVE_FILE_PATH,DEFAULT_SAVE_FILE_NAME]];
//        NSData *myData = [[NSData alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),DEFAULT_OPTION_FILE_NAME]];
//        _dicForSave = (NSMutableDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:myData];
//        //        NSLog(@"_userCustomDic :%@",_userCustomDic);
//        [self setIsAutoRunningWhenBooting:[NSNumber numberWithBool:<#(BOOL)#>]];
//        [self setIsShowWelcomeMSG:[_dicForSave objectForKey:IS_SHOW_WELCOME_MSG_KEY]];
        _optionDataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),DEFAULT_OPTION_FILE_NAME]];
    }
    else{
        [_optionDataDic setObject:[NSNumber numberWithBool:YES] forKey:IS_SHOW_WELCOME_MSG_KEY];
        [_optionDataDic setObject:[NSNumber numberWithBool:NO] forKey:IN_AUTO_RUNNING_WHEN_BOOTING_KEY];
        [self dataSave];
    }
    
    return result;
}

@end
