; ModuleID = 'test_rules.bc'
source_filename = "test_rules.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.ipt_rule_t = type { i32, i32, i32, i16, i16, i32 }

@rules_count = dso_local global i32 0, align 4
@rules = dso_local global [128 x %struct.ipt_rule_t] zeroinitializer, align 16
@.str = private unnamed_addr constant [7 x i8] c"src_ip\00", align 1
@.str.1 = private unnamed_addr constant [7 x i8] c"dst_ip\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"src_port\00", align 1
@.str.3 = private unnamed_addr constant [9 x i8] c"dst_port\00", align 1
@.str.4 = private unnamed_addr constant [6 x i8] c"proto\00", align 1
@.str.5 = private unnamed_addr constant [7 x i8] c"ACCEPT\00", align 1
@.str.6 = private unnamed_addr constant [24 x i8] c"result == ACTION_ACCEPT\00", align 1
@.str.7 = private unnamed_addr constant [13 x i8] c"test_rules.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@.str.8 = private unnamed_addr constant [5 x i8] c"DROP\00", align 1
@.str.9 = private unnamed_addr constant [22 x i8] c"result == ACTION_DROP\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @init_rules() #0 {
entry:
  store i32 6, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 0, i32 0), align 16
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 0, i32 1), align 4
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 0, i32 2), align 8
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 0, i32 3), align 4
  store i16 22, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 0, i32 4), align 2
  store i32 1, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 0, i32 5), align 16
  store i32 6, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 1, i32 0), align 4
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 1, i32 1), align 4
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 1, i32 2), align 4
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 1, i32 3), align 4
  store i16 80, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 1, i32 4), align 2
  store i32 1, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 1, i32 5), align 4
  store i32 6, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 2, i32 0), align 8
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 2, i32 1), align 4
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 2, i32 2), align 8
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 2, i32 3), align 4
  store i16 443, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 2, i32 4), align 2
  store i32 1, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 2, i32 5), align 8
  store i32 6, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 3, i32 0), align 4
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 3, i32 1), align 4
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 3, i32 2), align 4
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 3, i32 3), align 4
  store i16 30033, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 3, i32 4), align 2
  store i32 1, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 3, i32 5), align 4
  store i32 17, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 4, i32 0), align 16
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 4, i32 1), align 4
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 4, i32 2), align 8
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 4, i32 3), align 4
  store i16 9987, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 4, i32 4), align 2
  store i32 1, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 4, i32 5), align 16
  store i32 6, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 5, i32 0), align 4
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 5, i32 1), align 4
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 5, i32 2), align 4
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 5, i32 3), align 4
  store i16 13001, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 5, i32 4), align 2
  store i32 1, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 5, i32 5), align 4
  store i32 6, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 6, i32 0), align 8
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 6, i32 1), align 4
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 6, i32 2), align 8
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 6, i32 3), align 4
  store i16 13001, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 6, i32 4), align 2
  store i32 1, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 6, i32 5), align 8
  store i32 -1, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 7, i32 0), align 4
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 7, i32 1), align 4
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 7, i32 2), align 4
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 7, i32 3), align 4
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 7, i32 4), align 2
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 7, i32 5), align 4
  store i32 -1, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 8, i32 0), align 16
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 8, i32 1), align 4
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 8, i32 2), align 8
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 8, i32 3), align 4
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 8, i32 4), align 2
  store i32 1, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 8, i32 5), align 16
  store i32 -1, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 9, i32 0), align 4
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 9, i32 1), align 4
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 9, i32 2), align 4
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 9, i32 3), align 4
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 9, i32 4), align 2
  store i32 1, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 9, i32 5), align 4
  store i32 -1, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 10, i32 0), align 8
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 10, i32 1), align 4
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 10, i32 2), align 8
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 10, i32 3), align 4
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 10, i32 4), align 2
  store i32 1, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 10, i32 5), align 8
  store i32 6, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 11, i32 0), align 4
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 11, i32 1), align 4
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 11, i32 2), align 4
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 11, i32 3), align 4
  store i16 8080, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 11, i32 4), align 2
  store i32 1, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 11, i32 5), align 4
  store i32 -1, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 12, i32 0), align 16
  store i32 -721298022, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 12, i32 1), align 4
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 12, i32 2), align 8
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 12, i32 3), align 4
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 12, i32 4), align 2
  store i32 1, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 12, i32 5), align 16
  store i32 17, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 13, i32 0), align 4
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 13, i32 1), align 4
  store i32 -1408172031, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 13, i32 2), align 4
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 13, i32 3), align 4
  store i16 4500, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 13, i32 4), align 2
  store i32 1, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 13, i32 5), align 4
  store i32 17, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 14, i32 0), align 8
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 14, i32 1), align 4
  store i32 -1408172031, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 14, i32 2), align 8
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 14, i32 3), align 4
  store i16 500, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 14, i32 4), align 2
  store i32 1, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 14, i32 5), align 8
  store i32 -1, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 15, i32 0), align 4
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 15, i32 1), align 4
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 15, i32 2), align 4
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 15, i32 3), align 4
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 15, i32 4), align 2
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 15, i32 5), align 4
  store i32 -1, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 16, i32 0), align 16
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 16, i32 1), align 4
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 16, i32 2), align 8
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 16, i32 3), align 4
  store i16 0, i16* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 16, i32 4), align 2
  store i32 0, i32* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 16, i32 5), align 16
  store i32 17, i32* @rules_count, align 4
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @check_packet(i32 %src_ip, i32 %dst_ip, i16 zeroext %src_port, i16 zeroext %dst_port, i32 %proto) #0 {
entry:
  %retval = alloca i32, align 4
  %src_ip.addr = alloca i32, align 4
  %dst_ip.addr = alloca i32, align 4
  %src_port.addr = alloca i16, align 2
  %dst_port.addr = alloca i16, align 2
  %proto.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %match = alloca i8, align 1
  store i32 %src_ip, i32* %src_ip.addr, align 4
  store i32 %dst_ip, i32* %dst_ip.addr, align 4
  store i16 %src_port, i16* %src_port.addr, align 2
  store i16 %dst_port, i16* %dst_port.addr, align 2
  store i32 %proto, i32* %proto.addr, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4
  %1 = load i32, i32* @rules_count, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  store i8 1, i8* %match, align 1
  %2 = load i32, i32* %i, align 4
  %idxprom = sext i32 %2 to i64
  %arrayidx = getelementptr inbounds [128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 %idxprom
  %proto1 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %arrayidx, i32 0, i32 0
  %3 = load i32, i32* %proto1, align 4
  %cmp2 = icmp ne i32 %3, -1
  br i1 %cmp2, label %land.lhs.true, label %if.end

land.lhs.true:                                    ; preds = %for.body
  %4 = load i32, i32* %i, align 4
  %idxprom3 = sext i32 %4 to i64
  %arrayidx4 = getelementptr inbounds [128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 %idxprom3
  %proto5 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %arrayidx4, i32 0, i32 0
  %5 = load i32, i32* %proto5, align 4
  %6 = load i32, i32* %proto.addr, align 4
  %cmp6 = icmp ne i32 %5, %6
  br i1 %cmp6, label %if.then, label %if.end

if.then:                                          ; preds = %land.lhs.true
  store i8 0, i8* %match, align 1
  br label %if.end

if.end:                                           ; preds = %if.then, %land.lhs.true, %for.body
  %7 = load i32, i32* %i, align 4
  %idxprom7 = sext i32 %7 to i64
  %arrayidx8 = getelementptr inbounds [128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 %idxprom7
  %src_ip9 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %arrayidx8, i32 0, i32 1
  %8 = load i32, i32* %src_ip9, align 4
  %cmp10 = icmp ne i32 %8, 0
  br i1 %cmp10, label %land.lhs.true11, label %if.end17

land.lhs.true11:                                  ; preds = %if.end
  %9 = load i32, i32* %i, align 4
  %idxprom12 = sext i32 %9 to i64
  %arrayidx13 = getelementptr inbounds [128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 %idxprom12
  %src_ip14 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %arrayidx13, i32 0, i32 1
  %10 = load i32, i32* %src_ip14, align 4
  %11 = load i32, i32* %src_ip.addr, align 4
  %cmp15 = icmp ne i32 %10, %11
  br i1 %cmp15, label %if.then16, label %if.end17

if.then16:                                        ; preds = %land.lhs.true11
  store i8 0, i8* %match, align 1
  br label %if.end17

if.end17:                                         ; preds = %if.then16, %land.lhs.true11, %if.end
  %12 = load i32, i32* %i, align 4
  %idxprom18 = sext i32 %12 to i64
  %arrayidx19 = getelementptr inbounds [128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 %idxprom18
  %dst_ip20 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %arrayidx19, i32 0, i32 2
  %13 = load i32, i32* %dst_ip20, align 4
  %cmp21 = icmp ne i32 %13, 0
  br i1 %cmp21, label %land.lhs.true22, label %if.end28

land.lhs.true22:                                  ; preds = %if.end17
  %14 = load i32, i32* %i, align 4
  %idxprom23 = sext i32 %14 to i64
  %arrayidx24 = getelementptr inbounds [128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 %idxprom23
  %dst_ip25 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %arrayidx24, i32 0, i32 2
  %15 = load i32, i32* %dst_ip25, align 4
  %16 = load i32, i32* %dst_ip.addr, align 4
  %cmp26 = icmp ne i32 %15, %16
  br i1 %cmp26, label %if.then27, label %if.end28

if.then27:                                        ; preds = %land.lhs.true22
  store i8 0, i8* %match, align 1
  br label %if.end28

if.end28:                                         ; preds = %if.then27, %land.lhs.true22, %if.end17
  %17 = load i32, i32* %i, align 4
  %idxprom29 = sext i32 %17 to i64
  %arrayidx30 = getelementptr inbounds [128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 %idxprom29
  %src_port31 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %arrayidx30, i32 0, i32 3
  %18 = load i16, i16* %src_port31, align 4
  %conv = zext i16 %18 to i32
  %cmp32 = icmp ne i32 %conv, 0
  br i1 %cmp32, label %land.lhs.true34, label %if.end43

land.lhs.true34:                                  ; preds = %if.end28
  %19 = load i32, i32* %i, align 4
  %idxprom35 = sext i32 %19 to i64
  %arrayidx36 = getelementptr inbounds [128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 %idxprom35
  %src_port37 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %arrayidx36, i32 0, i32 3
  %20 = load i16, i16* %src_port37, align 4
  %conv38 = zext i16 %20 to i32
  %21 = load i16, i16* %src_port.addr, align 2
  %conv39 = zext i16 %21 to i32
  %cmp40 = icmp ne i32 %conv38, %conv39
  br i1 %cmp40, label %if.then42, label %if.end43

if.then42:                                        ; preds = %land.lhs.true34
  store i8 0, i8* %match, align 1
  br label %if.end43

if.end43:                                         ; preds = %if.then42, %land.lhs.true34, %if.end28
  %22 = load i32, i32* %i, align 4
  %idxprom44 = sext i32 %22 to i64
  %arrayidx45 = getelementptr inbounds [128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 %idxprom44
  %dst_port46 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %arrayidx45, i32 0, i32 4
  %23 = load i16, i16* %dst_port46, align 2
  %conv47 = zext i16 %23 to i32
  %cmp48 = icmp ne i32 %conv47, 0
  br i1 %cmp48, label %land.lhs.true50, label %if.end59

land.lhs.true50:                                  ; preds = %if.end43
  %24 = load i32, i32* %i, align 4
  %idxprom51 = sext i32 %24 to i64
  %arrayidx52 = getelementptr inbounds [128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 %idxprom51
  %dst_port53 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %arrayidx52, i32 0, i32 4
  %25 = load i16, i16* %dst_port53, align 2
  %conv54 = zext i16 %25 to i32
  %26 = load i16, i16* %dst_port.addr, align 2
  %conv55 = zext i16 %26 to i32
  %cmp56 = icmp ne i32 %conv54, %conv55
  br i1 %cmp56, label %if.then58, label %if.end59

if.then58:                                        ; preds = %land.lhs.true50
  store i8 0, i8* %match, align 1
  br label %if.end59

if.end59:                                         ; preds = %if.then58, %land.lhs.true50, %if.end43
  %27 = load i8, i8* %match, align 1
  %tobool = trunc i8 %27 to i1
  br i1 %tobool, label %if.then60, label %if.end63

if.then60:                                        ; preds = %if.end59
  %28 = load i32, i32* %i, align 4
  %idxprom61 = sext i32 %28 to i64
  %arrayidx62 = getelementptr inbounds [128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 %idxprom61
  %action = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %arrayidx62, i32 0, i32 5
  %29 = load i32, i32* %action, align 4
  store i32 %29, i32* %retval, align 4
  br label %return

if.end63:                                         ; preds = %if.end59
  br label %for.inc

for.inc:                                          ; preds = %if.end63
  %30 = load i32, i32* %i, align 4
  %inc = add nsw i32 %30, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond, !llvm.loop !4

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %retval, align 4
  br label %return

return:                                           ; preds = %for.end, %if.then60
  %31 = load i32, i32* %retval, align 4
  ret i32 %31
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  %src_ip = alloca i32, align 4
  %dst_ip = alloca i32, align 4
  %src_port = alloca i16, align 2
  %dst_port = alloca i16, align 2
  %proto = alloca i32, align 4
  %result = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  %0 = bitcast i32* %src_ip to i8*
  call void @klee_make_symbolic(i8* %0, i64 4, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0))
  %1 = bitcast i32* %dst_ip to i8*
  call void @klee_make_symbolic(i8* %1, i64 4, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i64 0, i64 0))
  %2 = bitcast i16* %src_port to i8*
  call void @klee_make_symbolic(i8* %2, i64 2, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0))
  %3 = bitcast i16* %dst_port to i8*
  call void @klee_make_symbolic(i8* %3, i64 2, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.3, i64 0, i64 0))
  %4 = bitcast i32* %proto to i8*
  call void @klee_make_symbolic(i8* %4, i64 4, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.4, i64 0, i64 0))
  call void @init_rules()
  %5 = load i32, i32* %src_ip, align 4
  %6 = load i32, i32* %dst_ip, align 4
  %7 = load i16, i16* %src_port, align 2
  %8 = load i16, i16* %dst_port, align 2
  %9 = load i32, i32* %proto, align 4
  %call = call i32 @check_packet(i32 %5, i32 %6, i16 zeroext %7, i16 zeroext %8, i32 %9)
  store i32 %call, i32* %result, align 4
  %10 = load i32, i32* %result, align 4
  %cmp = icmp eq i32 %10, 1
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  call void @klee_warning(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.5, i64 0, i64 0))
  %11 = load i32, i32* %result, align 4
  %cmp1 = icmp eq i32 %11, 1
  br i1 %cmp1, label %cond.true, label %cond.false

cond.true:                                        ; preds = %if.then
  br label %cond.end

cond.false:                                       ; preds = %if.then
  %call2 = call i32 (i8*, i8*, i32, i8*, ...) bitcast (i32 (...)* @__assert_fail to i32 (i8*, i8*, i32, i8*, ...)*)(i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.6, i64 0, i64 0), i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.7, i64 0, i64 0), i32 214, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0))
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  br label %if.end

if.else:                                          ; preds = %entry
  call void @klee_warning(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.8, i64 0, i64 0))
  %12 = load i32, i32* %result, align 4
  %cmp3 = icmp eq i32 %12, 0
  br i1 %cmp3, label %cond.true4, label %cond.false5

cond.true4:                                       ; preds = %if.else
  br label %cond.end7

cond.false5:                                      ; preds = %if.else
  %call6 = call i32 (i8*, i8*, i32, i8*, ...) bitcast (i32 (...)* @__assert_fail to i32 (i8*, i8*, i32, i8*, ...)*)(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.9, i64 0, i64 0), i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.7, i64 0, i64 0), i32 217, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0))
  br label %cond.end7

cond.end7:                                        ; preds = %cond.false5, %cond.true4
  br label %if.end

if.end:                                           ; preds = %cond.end7, %cond.end
  %13 = load i32, i32* %result, align 4
  ret i32 %13
}

declare dso_local void @klee_make_symbolic(i8*, i64, i8*) #1

declare dso_local void @klee_warning(i8*) #1

; Function Attrs: noreturn
declare dso_local i32 @__assert_fail(...) #2

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"uwtable", i32 1}
!2 = !{i32 7, !"frame-pointer", i32 2}
!3 = !{!"clang version 13.0.1 (https://github.com/llvm/llvm-project.git 75e33f71c2dae584b13a7d1186ae0a038ba98838)"}
!4 = distinct !{!4, !5}
!5 = !{!"llvm.loop.mustprogress"}
