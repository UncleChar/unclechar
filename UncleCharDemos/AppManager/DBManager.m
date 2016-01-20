//
//  DBManager.m
//  UncleCharDemos
//
//  Created by LingLi on 15/12/28.
//  Copyright © 2015年 hailong.xie. All rights reserved.
//

#import "DBManager.h"
#import "FMDB.h"
#import "UserTestModel.h"

@interface DBManager ()

@property (nonatomic, strong) FMDatabase      *fmdb;//数据库成员变量
@property (nonatomic, strong) NSLock          *lock;
@property (nonatomic, strong) NSMutableArray  *modelDataArray;

@end

static DBManager *_db = nil;
@implementation DBManager

+ (instancetype)sharedDBManager {

    static dispatch_once_t predicate;//谓词
    dispatch_once(&predicate, ^{
        
        _db = [[DBManager alloc]init];
        
    });
    
    return _db;
    
}

- (instancetype)initDBDirectoryWithPath:(NSString *)path {

    if (self = [super init]) {
        
        _lock = [[NSLock alloc]init];
        _fmdb = [FMDatabase databaseWithPath:path];
        
        BOOL isOpen = [_fmdb open];
        if (isOpen) {
            
            NSLog(@"Database open");
            
        }else {
        
           NSLog(@"Database not open");
            
        }
        
    }
    return self;
}


- (BOOL)isExistTableWithTableName:(NSString *)tableName {

    return [_fmdb tableExists:tableName];
    
}

- (void)createDBTableWithTableName:(NSString *)tableName {
    //这里封装一个属性，方便同一个方法创建多个表
    
    BOOL isExist = [self isExistTableWithTableName:tableName];
    
    if (!isExist) {
        //不存在那就去创建这个
            if ([tableName isEqualToString:@"UserInfo"]) {//这里之定义一张表暂时
                
            NSString *sqlStr = [NSString stringWithFormat:@"create table if not exists %@(userName text ,userID text primary key,country text ,sex text ,userMusic blod ,biggerData blod,telephone text )",tableName];
            
            BOOL isSuccess = [_fmdb executeUpdate:sqlStr];
            if (isSuccess) {
                
                NSLog(@"create succeed");
                
            }else {
            
                NSLog(@"create falied");
                
            }
            }else {
            
                NSString *sqlStr = [NSString stringWithFormat:@"create table if not exists %@(fileName text ,userID text primary key,biggerData blod )",tableName];
                
                BOOL isSuccess = [_fmdb executeUpdate:sqlStr];
                if (isSuccess) {
                    
                    NSLog(@"create succeed");
                    
                }else {
                    
                    NSLog(@"create falied");
                    
                }
            
            }
        
    }else {  // 如果存在就要先判断字段是否变动  用于数据库的升级（字段里可能有增减），比如我给一个表名为userInfo增加一个字段 telephone
    
        if ([_fmdb columnExists:@"telephone" inTableWithName:@"UserInfo"] == YES) {
            
            NSLog(@"UserInfo表中存在 telephone 这个字段");
        }else {
        
             NSLog(@"UserInfo表中不存在 telephone 这个字段 需要追加");
            NSString *addStr =@"ALTER TABLE UserInfo ADD COLUMN telephone text";
            [_fmdb executeUpdate:addStr];
        }
    
        
    }
    
    [_fmdb setShouldCacheStatements:YES];
    
}

- (void)insertDBWithData:(id)data forTableName:(NSString *)tableName {

    [_lock lock];
    
    if ([tableName isEqualToString:@"UserInfo"]) {
        
        UserTestModel *model = (UserTestModel *)data;
        
        NSString *insertSqlStr = [NSString stringWithFormat:@"insert into %@ values (?,?,?,?,?,?,?)",tableName];
        BOOL isSuccess = [_fmdb executeUpdate:insertSqlStr,model.userName,model.userID,model.country,model.sex,model.userMusic,model.biggerData,model.telephone];
        
        if (isSuccess) {
            
            NSLog(@"insert succeed");
        }else {
        
            NSLog(@"insert falied");
        }
    }
    
    [_lock unlock];
    
}


- (UserTestModel *)searchDBDataWithModelID:(NSString *)identifier withTableName:(NSString *)tableName {

    NSString *searchSqlString = [NSString stringWithFormat:@"select * from %@ where userID = ?",tableName];
    
    FMResultSet *set = [_fmdb executeQuery:searchSqlString,identifier];
    
    while ( [set next]) {
        
        UserTestModel *userModel = [[UserTestModel alloc]init];
        
        userModel.userName   = [set stringForColumn:@"userName"];
        userModel.userID     = [set stringForColumn:@"userID"];
        userModel.country    = [set stringForColumn:@"country"];
        userModel.sex        = [set stringForColumn:@"sex"];
        userModel.userMusic  = [set dataForColumn:@"userMusic"];
        userModel.biggerData = [set dataForColumn:@"biggerData"];
        userModel.telephone  = [set stringForColumn:@"telephone"];
        
        return userModel;
    }
    return nil;
}

- (NSArray *)allDataWithTableName:(NSString *)tableName {

    if (!_modelDataArray) {
        
        _modelDataArray = [NSMutableArray arrayWithCapacity:0];
    }else {
    
        [_modelDataArray removeAllObjects];
    }
    
    NSString *allDataSqlString = [NSString stringWithFormat:@"select * from %@",tableName];
    FMResultSet *set = [_fmdb executeQuery:allDataSqlString];
    
    while ([set next]) {
        
        UserTestModel *userModel = [[UserTestModel alloc]init];
        
        userModel.userName   = [set stringForColumn:@"userName"];
        userModel.userID     = [set stringForColumn:@"userID"];
        userModel.country    = [set stringForColumn:@"country"];
        userModel.sex        = [set stringForColumn:@"sex"];
        userModel.userMusic  = [set dataForColumn:@"userMusic"];
        userModel.biggerData = [set dataForColumn:@"biggerData"];
        userModel.telephone  = [set stringForColumn:@"telephone"];

        [_modelDataArray addObject:userModel];
        
    }
    
    return _modelDataArray;
    
    
}


- (void)updateDBDataWithModel:(UserTestModel *)model forTableName:(NSString *)tableNamel {

    [_lock lock];
    
    NSString *sqlString = [NSString stringWithFormat:@"update %@ set userName = ? where userID = ?",tableNamel];
    
    BOOL isSuccess = [_fmdb executeUpdate:sqlString,@"Fuck",model.userID];
    NSLog(@"%@",isSuccess ? @"succeed":@"falied");
    
    [_lock unlock];
    
}


- (void)deleteDBDataWithModelId:(NSString *)identifier forTableName:(NSString *)tableName {

    [_lock lock];
    
    NSString *deleSingleSqlStr = [NSString stringWithFormat:@"delete  from %@ where userID = ?",tableName];
    
    BOOL isSuccess = [_fmdb executeUpdate:deleSingleSqlStr,identifier];
    
    NSLog(@"%@",isSuccess ? @"delete成功":@"delete失败");
    
    [_lock unlock];
}


- (void)clearAllDataWithTableName:(NSString *)tableName {

    [_lock lock];
    
    NSString *clearAllSqlStr = [NSString stringWithFormat:@"delete from %@",tableName];
    
    BOOL isSuccess = [_fmdb executeUpdate:clearAllSqlStr];
    
    NSLog(@"%@",isSuccess ? @"celar成功":@"clear失败");
    
    [_lock unlock];
}























@end
