//
//  Jastor.h
//  Jastor
//
//  Created by Elad Ossadon on 12/14/11.
//  http://devign.me | http://elad.ossadon.com | http://twitter.com/elado
//
#import <UIKit/UIKit.h>

@interface Jastor : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy) NSString *objectId;
/**
 *  解析字典
 */
+ (id)objectFromDictionary:(NSDictionary*)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;
/**
 *  解析数组
 */
+ (id)objectFromArray:(NSArray*)array;
- (id)initWithArray:(NSArray *)array;


/**
 *  解析数组成一系列由对象组成的数组
 *
 *  @param array json数据的数组
 *
 *  @return 返回解析好的model数组
 */
+ (NSArray *)objectArrayFromDataArray:(NSArray *)array;

- (NSMutableDictionary *)toDictionary;
-(NSDictionary*)attrMapDict;

@end
