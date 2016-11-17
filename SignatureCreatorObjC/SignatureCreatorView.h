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
@property (nonatomic, strong) UIColor *_Nonnull signatureColor;

- (void)undo;
- (void)redo;

- (void)reset;

/**
 * The app's Info.plist must contain an NSPhotoLibraryUsageDescription key with a string value explaining to the user how the app uses this data.
 */
- (void)saveSignatureWithCompletionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler;

/**
 * The app's Info.plist must contain an NSPhotoLibraryUsageDescription key with a string value explaining to the user how the app uses this data.
 */
- (void)saveSignatureWithBlendMode:(CGBlendMode)blendMode completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler;

- (UIImage *__nullable)renderSignature;
- (UIImage *__nullable)renderSignatureWithBlendMode:(CGBlendMode)blendMode;


@end
