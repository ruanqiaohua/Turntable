//
//  UIViewController+HUD.m
//  Meelan
//
//  Created by kensou on 2018/11/8.
//

#import "UIViewController+HUD.h"
#import <MBProgressHUD/MBProgressHUD.h>

#define TAG 0xABCD

@implementation UIViewController (HUD)
- (MBProgressHUD *)getHUD {
    MBProgressHUD *hud = [self.view viewWithTag:TAG];
    if (hud == nil) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.tag = TAG;
        hud.removeFromSuperViewOnHide = YES;
        [self.view addSubview:hud];
    }
    return hud;
}

- (void)showBlockedHUD {
    MBProgressHUD *hud = [self getHUD];
    hud.userInteractionEnabled = YES;
    [hud showAnimated:YES];
}

- (void)showUnblockedHUD {
    MBProgressHUD *hud = [self getHUD];
    hud.userInteractionEnabled = NO;
    [hud showAnimated:YES];
}

- (void)hideHUD {
    MBProgressHUD *hud = [self.view viewWithTag:TAG];
    if (hud != nil) {
        [hud hideAnimated:YES];
    }
}

- (void)HUDToastWithString:(NSString *)string {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = string;
    hud.label.numberOfLines = 0;
    hud.label.lineBreakMode = NSLineBreakByWordWrapping;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [hud hideAnimated:YES];
    });
}

@end
