//
//  LuckyLandBaseWebViewController.h
//  NoaKit
//
//  Created by LuckyLand on 2026/9/20.
//

#import "LuckyLandBaseViewController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LuckyLandBaseWebViewController : LuckyLandBaseViewController

@property (nonatomic, copy) NSString* webViewTitle;
@property (nonatomic, copy) NSString* webViewUrl;
@property (nonatomic, strong) WKWebView* webView;
@property (nonatomic, copy) NSString *currentUrlStr;

@end

NS_ASSUME_NONNULL_END
