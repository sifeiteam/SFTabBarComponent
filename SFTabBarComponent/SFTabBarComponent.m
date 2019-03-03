//
//  SFTabBarComponent.m
//  SFTabBarComponent
//
//  Created by XJY on 2019/3/3.
//  Copyright © 2019 com.sf.ios. All rights reserved.
//

#import "SFTabBarComponent.h"
#import "SFTabBarController.h"

@implementation SFTabBarComponent

- (UIViewController *)getPage:(NSString *)page context:(NSDictionary *)context {
    if (!page || page.length == 0) {
        return nil;
    }
    if (![page isEqualToString:@"Page_SFTabBarController"]) {
        return nil;
    }
    SFTabBarController *tabBarController = [[SFTabBarController alloc] init];
    return tabBarController;
}

@end
