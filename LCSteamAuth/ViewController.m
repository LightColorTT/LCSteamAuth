//
//  ViewController.m
//  LCSteamAuth
//
//  Created by light_color on 11.07.17.
//  Copyright © 2017 LightColor. All rights reserved.
//

#import "ViewController.h"
#import "LCSteamAuth.h"

static NSString* const API_KEY = @"YOUR_STEAM_API_KEY";

@interface ViewController ()

@property (nonatomic, strong) LCSteamAuth *steamAuth;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)actionAuth:(id)sender {
    [self.steamAuth authorizationViaSteam];
}

- (IBAction)actionShowInformation:(id)sender {
    NSLog(@"STEAM_ID : %@ , STEAM_ID64 : %@", self.steamAuth.steamID, self.steamAuth.steamID64);
}

#pragma mark - Lazy init

- (LCSteamAuth *)steamAuth {
    if (!_steamAuth) {
        _steamAuth = [LCSteamAuth createSessionWithSteamApiKey:API_KEY];
    }
    return _steamAuth;
}
@end
