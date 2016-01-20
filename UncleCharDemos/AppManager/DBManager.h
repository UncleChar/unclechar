//
//  DBManager.h
//  UncleCharDemos
//
//  Created by LingLi on 15/12/28.
//  Copyright © 2015年 hailong.xie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserTestModel;

@interface DBManager : NSObject

+ (instancetype)sharedDBManager;

/**
 *  创建数据库的存储目录
 *
 *  @param path 数据库的路径
 *
 */
- (instancetype)initDBDirectoryWithPath:(NSString *)path;




/**
 *  创建数据库表
 *
 *  @param tableName 根据给的参数(tableName)创建数据库
 */
- (void)createDBTableWithTableName:(NSString *)tableName;


/**
 *  判断数据库表是否存在
 *
 *  @param tableName 数据库表名
 *
 *  @return
 */
- (BOOL)isExistTableWithTableName:(NSString *)tableName;



//插入new数据
/**
 *  插入整条新的数据
 *
 *  @param data      这个data不是数据类型，只是id类型的变量
 *  @param tableName 数据库表名
 */
- (void)insertDBWithData:(id)data forTableName:(NSString *)tableName;


/**
 *  查询数据（以模型的方式返回数据）
 *
 *  @param identifier 模型的ID即数据库表中得主键
 *  @param tableName  表名
 *
 *  @return 返回的是模型
 */
- (UserTestModel *)searchDBDataWithModelID:(NSString *)identifier withTableName:(NSString *)tableName;


/**
 *  返回数据库所有的数据
 *
 *  @param tableName 表名
 *
 *  @return 返回的是模型数组
 */
- (NSArray *)allDataWithTableName:(NSString *)tableName;



/**
 *  更新已经存在的数据
 *
 *  @param model      需要更新的对象，根据自身的id
 *  @param tableNamel 表名
 */
- (void)updateDBDataWithModel:(UserTestModel *)model forTableName:(NSString *)tableNamel;


/**
 *  根据模型的ID删除指定的模型
 *
 *  @param identifier model的id
 *  @param tableName  表名
 */
- (void)deleteDBDataWithModelId:(NSString *)identifier forTableName:(NSString *)tableName;


/**
 *  清空数据库所有的数据，此方法慎用!!，一般可以清空cache表的缓存数据
 *
 *  @param tableName <#tableName description#>
 */
- (void)clearAllDataWithTableName:(NSString *)tableName;









@end
