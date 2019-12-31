//
//  USERUSERDataHandle.m
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/6/26.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERDataHandle.h"
#import "USERModel.h"

static USERDataHandle *_defaulthandle = nil;

@interface USERDataHandle ()
@property(nonatomic,strong)FMDatabase *fMDB;

@end

@implementation USERDataHandle


+(USERDataHandle *)sharedDataHandle
{
    if (_defaulthandle == nil) {
        _defaulthandle = [[USERDataHandle alloc] init];
        
    }
    return _defaulthandle;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (_defaulthandle == nil) {
        _defaulthandle = [super allocWithZone:zone];
    }
    return _defaulthandle;
}




-(FMDatabase *)fMDB
{
    if (!_fMDB) {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"user.sqlite"];
        
        _fMDB = [FMDatabase databaseWithPath:path];
        [self initTable];
    }
    return _fMDB;
}


// 初始化数据表
-(void)initTable
{
    [_fMDB open];
    
    [_fMDB executeUpdate:@"CREATE TABLE user (id INTEGER PRIMARY KEY AUTOINCREMENT,status TEXT,name TEXT,subTle TEXT,title TEXT,phoneNum TEXT,elseName TEXT,elsePhone TEXT,price TEXT,time TEXT,address TEXT)"];
    
    [_fMDB close];
}



-(void)addOneData:(USERModel *)user
{
    [self.fMDB open];
    
    [self.fMDB executeUpdateWithFormat:@"insert into user (status,name,subTle,title,phoneNum,elseName,elsePhone,price,time,address) values(%ld,%@,%@,%@,%@,%@,%@,%@,%@,%@)",user.status,user.name,user.subTle,user.title,user.phoneNum,user.elseName,user.elsePhone,user.price,user.time,user.address];
    
    [self.fMDB close];
}

-(void)deleteDataByID:(int)delID
{
    [self.fMDB open];
    
    [self.fMDB executeUpdateWithFormat:@"DELETE FROM user WHERE id = %d",delID];
    
    [self.fMDB close];
}

-(NSArray *)getAllDatas
{
    [self.fMDB open];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    FMResultSet *result = [self.fMDB executeQuery:@"SELECT * FROM user"];
    while ([result next])
    {
        USERModel *model = [[USERModel alloc] init];
        [arr addObject:model];
        
        model.ID = [result intForColumnIndex:0];
        model.status = [result intForColumnIndex:1];
        model.name = [result stringForColumnIndex:2];
        model.subTle = [result stringForColumnIndex:3];
        model.title = [result stringForColumnIndex:4];
        model.phoneNum = [result stringForColumnIndex:5];
        model.elseName = [result stringForColumnIndex:6];
        model.elsePhone = [result stringForColumnIndex:7];
        model.price = [result stringForColumnIndex:8];
        model.time = [result stringForColumnIndex:9];
        model.address = [result stringForColumnIndex:10];

    }
    [self.fMDB close];
    
    return [arr copy];
}

-(void)deleteTable{
    [self.fMDB open];
    //如果表格存在 则销毁
    BOOL result1 = [self.fMDB executeUpdate:@"drop table if exists user"];
    
    if (result1 ) {
//        NSLog(@"--------------------删除表1成功");
    } else {
//        NSLog(@"--------------------删除表1失败");
    }
    [self.fMDB close];
}

@end

