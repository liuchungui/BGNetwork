
#import <UIKit/UIKit.h>

@interface JastorRuntimeHelper : NSObject {
	
}
+ (BOOL)isPropertyReadOnly:(Class)klass propertyName:(NSString*)propertyName;
+ (Class)propertyClassForPropertyName:(NSString *)propertyName ofClass:(Class)klass;
+ (NSArray *)propertyNames:(Class)klass;

/** 属性修饰符是否是copy **/
+ (BOOL)isPropertyCopyOfClass:(Class)klass propertyName:(NSString *)propertyName;
@end
