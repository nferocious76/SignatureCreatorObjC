//
//  SignatureCreatorView.h
//  SignatureCreatorObjC
//
//  Created by Neil Francis Hipona on 11/17/16.
//  Copyright © 2016 Neil Francis Hipona. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignatureCreatorView : UIView

@property (nonatomic) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *signatureColor;

- (void)reset;

- (UIImage *)save;

- (void)undo;
- (void)redo;


@end
