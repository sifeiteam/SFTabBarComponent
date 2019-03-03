//
//  SFTabBarController.m
//  SFTabBarComponent
//
//  Created by XJY on 2019/3/3.
//  Copyright © 2019 com.sf.ios. All rights reserved.
//

#import "SFTabBarController.h"
#import <SFComponent/SFInjection.h>
#import <SFComponent/SFRoute.h>

@interface SFTabBarController () <SFInjectionProtocol>

@end

@implementation SFTabBarController

#define Injection_SFTab_Identifier @"Injection_SFTab"

- (instancetype)init {
    self = [super init];
    if (self) {
        [[SFInjection sharedInstance] addDelegate:self identifier:Injection_SFTab_Identifier];
        
        [self addTabs];
    }
    return self;
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    [super setViewControllers:viewControllers];
    self.tabBar.hidden = (!viewControllers || viewControllers.count < 2);
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated {
    [super setViewControllers:viewControllers animated:animated];
    self.tabBar.hidden = (!viewControllers || viewControllers.count < 2);
}

- (void)addTabs {
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    NSArray *params = [[SFInjection sharedInstance] fetchInjectionParamsWithIdentifier:Injection_SFTab_Identifier];
    for (NSDictionary *param in params) {
        UIViewController *viewController = [self getViewControllerWithParam:param];
        if (viewController) {
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
            [viewControllers addObject:navigationController];
        }
    }
    
    [self setViewControllers:viewControllers animated:NO];
}

- (UIViewController *)getViewControllerWithParam:(NSDictionary *)param {
    NSString *componentName = [param objectForKey:@"componentName"];
    NSString *page = [param objectForKey:@"page"];
    NSDictionary *context = [param objectForKey:@"context"];
    
    return [SFRoute getPage:page componentName:componentName context:context];
}

#pragma mark - SFInjectionProtocol

- (void)observeInjectionWithIdentifier:(NSString *)identifier params:(NSDictionary *)params {
    UIViewController *viewController = [self getViewControllerWithParam:params];
    if (!viewController) {
        return;
    }
    NSMutableArray *viewControllers = [self.viewControllers mutableCopy];
    if (!viewControllers) {
        viewControllers = [[NSMutableArray alloc] init];
    }
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [viewControllers addObject:navigationController];
    
    [self setViewControllers:viewControllers animated:NO];
}

@end
