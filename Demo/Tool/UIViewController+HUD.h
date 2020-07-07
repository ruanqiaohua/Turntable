//
//  UIViewController+HUD.h
//  Meelan
//
//  Created by kensou on 2018/11/8.
//

#import <UIKit/UIKit.h>


@interface UIViewController (HUD)
- (void)showBlockedHUD;
- (void)showUnblockedHUD;
- (void)hideHUD;
- (void)HUDToastWithString:(NSString *)string;
@end

