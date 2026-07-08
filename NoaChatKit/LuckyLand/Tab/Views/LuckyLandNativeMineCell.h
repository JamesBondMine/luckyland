//
//  LuckyLandNativeMineCell.h
//  LuckyLand
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LuckyLandNativeMineCell : UIControl

@property (nonatomic, copy) NSString *actionTag;

- (void)configureWithTitle:(NSString *)title iconName:(NSString *)iconName;
- (void)configureDestructiveWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
