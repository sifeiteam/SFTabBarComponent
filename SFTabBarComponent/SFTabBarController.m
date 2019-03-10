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
#import <SFComponent/SFFont.h>
#import <SFComponent/SFColors.h>
#import <SFComponent/SFConfiguration.h>
#import <SFComponent/SFComponentManager.h>
#import "SFTabBarComponent.h"

@interface SFTabBarController () <SFInjectionProtocol>

@end

@implementation SFTabBarController

#define Injection_SFTab_Identifier @"Injection_SFTab"

- (instancetype)init {
    self = [super init];
    if (self) {
        //启动tab列表中的组件
        [self startupTabComponents];
        [self addTabs];
        [self addObservers];
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

- (void)startupTabComponents {
    NSDictionary *tabs = [SFConfiguration configDictionaryWithFileName:@"Tab.plist" componentName:[SFTabBarComponent componentName]];
    NSArray *keys = [tabs allKeys];
    for (NSNumber *key in keys) {
        NSString *componentName = [tabs objectForKey:key];
        [[SFComponentManager sharedInstance] startupComponentWithName:componentName];
    }
}

- (void)addTabs {
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    NSArray *params = [[SFInjection sharedInstance] fetchInjectionParamsWithIdentifier:Injection_SFTab_Identifier];
    for (NSDictionary *param in params) {
        UIViewController *viewController = [self getViewControllerWithParam:param];
        if (viewController) {
            [viewControllers addObject:viewController];
        }
    }
    
    [self setViewControllers:viewControllers animated:NO];
}

- (void)addObservers {
    [[SFInjection sharedInstance] addDelegate:self identifier:Injection_SFTab_Identifier];
}

- (UIViewController *)getViewControllerWithParam:(NSDictionary *)param {
    NSString *componentName = [param objectForKey:@"componentName"];
    NSString *page = [param objectForKey:@"page"];
    NSDictionary *context = [param objectForKey:@"context"];
    NSString *tabTitle = [param objectForKey:@"tabTitle"];
    UIImage *tabImage = [param objectForKey:@"tabImage"];
    
    UIViewController *viewController = [SFRoute getPage:page componentName:componentName context:context];
    if (!viewController) {
        return nil;
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navigationController.tabBarItem.title = tabTitle;
    navigationController.tabBarItem.image = tabImage;
    
    // 普通状态下的文字属性
    NSDictionary *normalAttributes = @{NSFontAttributeName : SFFontWithNumber(14),
                                       NSForegroundColorAttributeName : SFColorWithNumber(1)
                                       };
    // 选中状态下的文字属性
    NSDictionary *selectedAttributes = @{NSFontAttributeName : SFFontWithNumber(14),
                                       NSForegroundColorAttributeName : SFColorWithNumber(2)
                                       };
    
    [navigationController.tabBarItem setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    [navigationController.tabBarItem setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    
    return navigationController;
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
    [viewControllers addObject:viewController];
    
    [self setViewControllers:viewControllers animated:NO];
}

@end
