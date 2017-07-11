//
//  LCSteamAuth.h
//  LCSteamAuth
//
//  Created by light_color on 11.07.17.
//  Copyright © 2017 LightColor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LCSteamAuth : NSObject <UIWebViewDelegate, NSURLSessionDelegate>

@property (nonatomic, strong) NSString* steamID;
@property (nonatomic, strong) NSString* steamID64;

+ (instancetype)createSessionWithSteamApiKey:(NSString *)key;

- (void)authorizationViaSteam;

- (NSString *)convertSteamIDToSteamID64:(NSString *)steamID;
- (NSString *)convertSteamID64ToSteamID:(NSString *)steamID64;

@end
