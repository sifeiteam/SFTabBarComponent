# SFTabBarComponent

标签管理器，提供协议由组件自己注入页面作为标签。

## 一、组件名

SFTabBarComponent

## 二、协议

### 1、获取SFTabBarController，SFAppEntry里使用，其他组件不可使用。

- **Page：**Page_SFTabBarController

```
UIViewController *rootViewController = [SFRoute getPage:@"Page_SFTabBarController" componentName:@"SFTabBarComponent" context:nil];
```

### 2、注入页面到Tab

调用[[SFInjection sharedInstance] injectWithIdentifier: params:];注入页面到Tab

- **identifier：** Injection_SFTab

- **params：**

  - **componentName：** tab页面所在的组件名

  - **Page：** tab页面Page唯一标识

  - **context：** 上下文，会传递到组件的getPage:componentName:context:方法

  - **tabTitle：** tab标题

  - **tabImage：** tab图片，必须是UIImage

```
//将个人中心注入到tabbar
NSString *componentName = [SFUserCenter componentName];
NSDictionary *params = @{
    @"componentName" : componentName,
    @"page" : k_Page_SFUserCenterViewController,
    @"context" : @{},
    @"tabTitle" : [SFLanguage localizedStringWithKey:@"TabTitle" componentName:componentName],
    @"tabImage" : [SFImages imageWithName:@"WX20190227-205248.png" componentName:componentName]
};
[[SFInjection sharedInstance] injectWithIdentifier:@"Injection_SFTab" params:params];
```


