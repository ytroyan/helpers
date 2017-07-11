//
//  UIAlertController+Window.h
//  BlueKorner
//
//  Created by Troyan on 3/12/17.
//  Copyright © 2017 PNN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Window)


+ (void)showMessage:(NSString *)message withTitle:(NSString *)title type:(UIAlertControllerStyle)type buttonNames:(NSArray<NSString*> *)buttons cancelBtn:(NSString *)cancelBtn btnClicked:(void (^)(NSUInteger))success onCancel:(void (^)(bool))cancelDidClicked;

@end
