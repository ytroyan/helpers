//
//  UIAlertController+Window.m
//
//  Created by Troyan on 3/12/17.
//  Copyright © 2017 PNN. All rights reserved.
//

#import "UIAlertController+Window.h"
#import <objc/runtime.h>

@interface UIAlertController (Private)

@property (nonatomic, strong) UIWindow *alertWindow;

@end

@implementation UIAlertController (Private)

@dynamic alertWindow;

+ (void)setAlertWindow:(UIWindow *)alertWindow {
    objc_setAssociatedObject(self, @selector(alertWindow), alertWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIWindow *)alertWindow {
    return objc_getAssociatedObject(self, @selector(alertWindow));
}

@end

@implementation UIAlertController (Window)

+ (void)setupAlertWindow
{
    self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alertWindow.rootViewController = [[UIViewController alloc] init];
    
    id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
    if ([delegate respondsToSelector:@selector(window)]) {
        self.alertWindow.tintColor = delegate.window.tintColor;
    }
    UIWindow *topWindow = [UIApplication sharedApplication].windows.lastObject;
    self.alertWindow.windowLevel = topWindow.windowLevel + 1;
    
    [self.alertWindow makeKeyAndVisible];
}



+ (void)clearAlertWindow {
    self.alertWindow.hidden = YES;
    self.alertWindow = nil;
}



+ (void)showMessage:(NSString *)message
          withTitle:(NSString *)title
               type:(UIAlertControllerStyle)type
        buttonNames:(NSArray<NSString*> *)buttons
          cancelBtn:(NSString *)cancelBtn
         btnClicked:(void (^)(NSUInteger))success
           onCancel:(void (^)(bool))cancelDidClicked
{
    [self setupAlertWindow];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:type];
    for (NSString * names in buttons ) {
        UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:names
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 if (success) {
                                                                   success([buttons indexOfObject:names]);
                                                                 }
                                                                 [self clearAlertWindow];
                                                             }];
         [alert addAction:acceptAction];
    }



    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtn
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             cancelDidClicked(YES);
                                                             [self clearAlertWindow];
                                                         }];


    [alert addAction:cancelAction];

    [self.alertWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
