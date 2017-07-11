//
//  LCSteamAuth.m
//  LCSteamAuth
//
//  Created by light_color on 11.07.17.
//  Copyright © 2017 LightColor. All rights reserved.
//

#import "LCSteamAuth.h"

static NSString* const STEAM_MOBILE_LOGIN_URL = @"https://steamcommunity.com/mobilelogin";
static NSInteger const DEFAULT_STEAMID64_IDENTIFIER = 76561197960265728;
static NSString* const ABSOLUTE_STRING_STEAMID = @"http://steamcommunity.com/profiles/";

@interface LCSteamAuth ()

@property (strong, nonatomic) UIWebView* steamLoginWebView;
@property (strong, nonatomic) NSString* steamApiKey;

@end

@implementation LCSteamAuth

#pragma mark - Init

- (instancetype)initWithSteamApiKey:(NSString *)apiKey {
    if (self = [super init]) {
        self.steamID64 = nil;
        self.steamID = nil;
        self.steamApiKey = apiKey;
    }
    return self;
}

+ (instancetype)createSessionWithSteamApiKey:(NSString *)key {
    return [[self alloc] initWithSteamApiKey:key];
}

#pragma mark - Auth scope

- (void)authorizationViaSteam {
    [self authViaWebView];
}

- (void)authViaWebView {
    [self.rootViewController.view addSubview:self.steamLoginWebView];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([request.URL.absoluteString rangeOfString:ABSOLUTE_STRING_STEAMID].location != NSNotFound) {
        
        NSArray *urlComponents = [request.URL.absoluteString componentsSeparatedByString:@"/"];
        NSString *potentialID = urlComponents[4];
        
        self.steamID64 = potentialID;
        self.steamID = [self convertSteamID64ToSteamID:self.steamID64];
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3f
                         animations:^{weakSelf.steamLoginWebView.alpha = 0.f;}
                         completion:^(BOOL finished){
                             [weakSelf.steamLoginWebView removeFromSuperview];
                             weakSelf.steamLoginWebView = nil;
                         }];
        return NO;
    }
    return YES;
}

#pragma mark - Converters

- (NSString *)convertSteamIDToSteamID64:(NSString *)steamID {
        
    NSArray *components = [steamID componentsSeparatedByString:@":"];
    NSInteger z = [components[2] intValue];
    NSInteger y = [components[1] intValue];
    NSInteger v = DEFAULT_STEAMID64_IDENTIFIER;
    
    return [NSString stringWithFormat:@"%ld", z * 2 + v + y];
}

- (NSString *)convertSteamID64ToSteamID:(NSString *)steamID64  {
    
    NSMutableString *steamID = [@"STEAM_0" mutableCopy];
    
    NSInteger w = [steamID64 longLongValue];
    NSInteger v = DEFAULT_STEAMID64_IDENTIFIER;
    NSInteger y = w % (long)2;
    
    NSInteger sid = w - y - v;
    sid = sid / 2;
    
    [steamID appendString:@":"];
    [steamID appendString:[NSString stringWithFormat:@"%ld", y]];
    [steamID appendString:@":"];
    [steamID appendString:[NSString stringWithFormat:@"%ld", sid]];
    
    return steamID;
}

#pragma mark - Lazy init

- (UIViewController *)rootViewController {
    return [[[UIApplication sharedApplication] keyWindow] rootViewController];
}

- (UIWebView *)steamLoginWebView {
    if (!_steamLoginWebView) {
        _steamLoginWebView = [[UIWebView alloc] initWithFrame:self.rootViewController.view.bounds];
        _steamLoginWebView.delegate = self;
        [_steamLoginWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:STEAM_MOBILE_LOGIN_URL]]];
    }
    return _steamLoginWebView;
}
@end
