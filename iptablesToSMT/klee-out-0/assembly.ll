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
  %.compoundliteral = alloca %struct.ipt_rule_t, align 4
  %.compoundliteral1 = alloca %struct.ipt_rule_t, align 4
  %.compoundliteral8 = alloca %struct.ipt_rule_t, align 4
  %proto = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %.compoundliteral, i32 0, i32 0
  store i32 17, i32* %proto, align 4
  %src_ip = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %.compoundliteral, i32 0, i32 1
  store i32 -1062731520, i32* %src_ip, align 4
  %dst_ip = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %.compoundliteral, i32 0, i32 2
  store i32 167772161, i32* %dst_ip, align 4
  %src_port = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %.compoundliteral, i32 0, i32 3
  store i16 53, i16* %src_port, align 4
  %dst_port = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %.compoundliteral, i32 0, i32 4
  store i16 53, i16* %dst_port, align 2
  %action = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %.compoundliteral, i32 0, i32 5
  store i32 1, i32* %action, align 4
  %0 = bitcast %struct.ipt_rule_t* %.compoundliteral to i8*
  %1 = call i8* @memcpy(i8* bitcast ([128 x %struct.ipt_rule_t]* @rules to i8*), i8* %0, i64 20)
  %proto2 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %.compoundliteral1, i32 0, i32 0
  store i32 6, i32* %proto2, align 4
  %src_ip3 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %.compoundliteral1, i32 0, i32 1
  store i32 -1062731420, i32* %src_ip3, align 4
  %dst_ip4 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %.compoundliteral1, i32 0, i32 2
  store i32 0, i32* %dst_ip4, align 4
  %src_port5 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %.compoundliteral1, i32 0, i32 3
  store i16 1024, i16* %src_port5, align 4
  %dst_port6 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %.compoundliteral1, i32 0, i32 4
  store i16 80, i16* %dst_port6, align 2
  %action7 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %.compoundliteral1, i32 0, i32 5
  store i32 1, i32* %action7, align 4
  %2 = bitcast %struct.ipt_rule_t* %.compoundliteral1 to i8*
  %3 = call i8* @memcpy(i8* bitcast (%struct.ipt_rule_t* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 1) to i8*), i8* %2, i64 20)
  %4 = bitcast %struct.ipt_rule_t* %.compoundliteral8 to i8*
  %5 = call i8* @memset(i8* %4, i32 0, i64 20)
  %proto9 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %.compoundliteral8, i32 0, i32 0
  store i32 -1, i32* %proto9, align 4
  %6 = bitcast %struct.ipt_rule_t* %.compoundliteral8 to i8*
  %7 = call i8* @memcpy(i8* bitcast (%struct.ipt_rule_t* getelementptr inbounds ([128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 2) to i8*), i8* %6, i64 20)
  store i32 3, i32* @rules_count, align 4
  ret void
}

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #1

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #2

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
  %r = alloca %struct.ipt_rule_t, align 4
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
  %2 = load i32, i32* %i, align 4
  %idxprom = sext i32 %2 to i64
  %arrayidx = getelementptr inbounds [128 x %struct.ipt_rule_t], [128 x %struct.ipt_rule_t]* @rules, i64 0, i64 %idxprom
  %3 = bitcast %struct.ipt_rule_t* %r to i8*
  %4 = bitcast %struct.ipt_rule_t* %arrayidx to i8*
  %5 = call i8* @memcpy(i8* %3, i8* %4, i64 20)
  %proto1 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %r, i32 0, i32 0
  %6 = load i32, i32* %proto1, align 4
  %cmp2 = icmp ne i32 %6, -1
  br i1 %cmp2, label %land.lhs.true, label %if.end

land.lhs.true:                                    ; preds = %for.body
  %proto3 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %r, i32 0, i32 0
  %7 = load i32, i32* %proto3, align 4
  %8 = load i32, i32* %proto.addr, align 4
  %cmp4 = icmp ne i32 %7, %8
  br i1 %cmp4, label %if.then, label %if.end

if.then:                                          ; preds = %land.lhs.true
  br label %for.inc

if.end:                                           ; preds = %land.lhs.true, %for.body
  %src_ip5 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %r, i32 0, i32 1
  %9 = load i32, i32* %src_ip5, align 4
  %cmp6 = icmp ne i32 %9, 0
  br i1 %cmp6, label %land.lhs.true7, label %if.end11

land.lhs.true7:                                   ; preds = %if.end
  %src_ip8 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %r, i32 0, i32 1
  %10 = load i32, i32* %src_ip8, align 4
  %11 = load i32, i32* %src_ip.addr, align 4
  %cmp9 = icmp ne i32 %10, %11
  br i1 %cmp9, label %if.then10, label %if.end11

if.then10:                                        ; preds = %land.lhs.true7
  br label %for.inc

if.end11:                                         ; preds = %land.lhs.true7, %if.end
  %dst_ip12 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %r, i32 0, i32 2
  %12 = load i32, i32* %dst_ip12, align 4
  %cmp13 = icmp ne i32 %12, 0
  br i1 %cmp13, label %land.lhs.true14, label %if.end18

land.lhs.true14:                                  ; preds = %if.end11
  %dst_ip15 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %r, i32 0, i32 2
  %13 = load i32, i32* %dst_ip15, align 4
  %14 = load i32, i32* %dst_ip.addr, align 4
  %cmp16 = icmp ne i32 %13, %14
  br i1 %cmp16, label %if.then17, label %if.end18

if.then17:                                        ; preds = %land.lhs.true14
  br label %for.inc

if.end18:                                         ; preds = %land.lhs.true14, %if.end11
  %src_port19 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %r, i32 0, i32 3
  %15 = load i16, i16* %src_port19, align 4
  %conv = zext i16 %15 to i32
  %cmp20 = icmp ne i32 %conv, 0
  br i1 %cmp20, label %land.lhs.true22, label %if.end29

land.lhs.true22:                                  ; preds = %if.end18
  %src_port23 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %r, i32 0, i32 3
  %16 = load i16, i16* %src_port23, align 4
  %conv24 = zext i16 %16 to i32
  %17 = load i16, i16* %src_port.addr, align 2
  %conv25 = zext i16 %17 to i32
  %cmp26 = icmp ne i32 %conv24, %conv25
  br i1 %cmp26, label %if.then28, label %if.end29

if.then28:                                        ; preds = %land.lhs.true22
  br label %for.inc

if.end29:                                         ; preds = %land.lhs.true22, %if.end18
  %dst_port30 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %r, i32 0, i32 4
  %18 = load i16, i16* %dst_port30, align 2
  %conv31 = zext i16 %18 to i32
  %cmp32 = icmp ne i32 %conv31, 0
  br i1 %cmp32, label %land.lhs.true34, label %if.end41

land.lhs.true34:                                  ; preds = %if.end29
  %dst_port35 = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %r, i32 0, i32 4
  %19 = load i16, i16* %dst_port35, align 2
  %conv36 = zext i16 %19 to i32
  %20 = load i16, i16* %dst_port.addr, align 2
  %conv37 = zext i16 %20 to i32
  %cmp38 = icmp ne i32 %conv36, %conv37
  br i1 %cmp38, label %if.then40, label %if.end41

if.then40:                                        ; preds = %land.lhs.true34
  br label %for.inc

if.end41:                                         ; preds = %land.lhs.true34, %if.end29
  %action = getelementptr inbounds %struct.ipt_rule_t, %struct.ipt_rule_t* %r, i32 0, i32 5
  %21 = load i32, i32* %action, align 4
  store i32 %21, i32* %retval, align 4
  br label %return

for.inc:                                          ; preds = %if.then40, %if.then28, %if.then17, %if.then10, %if.then
  %22 = load i32, i32* %i, align 4
  %inc = add nsw i32 %22, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond, !llvm.loop !11

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %retval, align 4
  br label %return

return:                                           ; preds = %for.end, %if.end41
  %23 = load i32, i32* %retval, align 4
  ret i32 %23
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
  %5 = load i32, i32* %proto, align 4
  %cmp = icmp eq i32 %5, 6
  br i1 %cmp, label %lor.end, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %entry
  %6 = load i32, i32* %proto, align 4
  %cmp1 = icmp eq i32 %6, 17
  br i1 %cmp1, label %lor.end, label %lor.rhs

lor.rhs:                                          ; preds = %lor.lhs.false
  %7 = load i32, i32* %proto, align 4
  %cmp2 = icmp eq i32 %7, 1
  br label %lor.end

lor.end:                                          ; preds = %lor.rhs, %lor.lhs.false, %entry
  %8 = phi i1 [ true, %lor.lhs.false ], [ true, %entry ], [ %cmp2, %lor.rhs ]
  %lor.ext = zext i1 %8 to i32
  %conv = sext i32 %lor.ext to i64
  call void @klee_assume(i64 %conv)
  call void @init_rules()
  %9 = load i32, i32* %src_ip, align 4
  %10 = load i32, i32* %dst_ip, align 4
  %11 = load i16, i16* %src_port, align 2
  %12 = load i16, i16* %dst_port, align 2
  %13 = load i32, i32* %proto, align 4
  %call = call i32 @check_packet(i32 %9, i32 %10, i16 zeroext %11, i16 zeroext %12, i32 %13)
  store i32 %call, i32* %result, align 4
  %14 = load i32, i32* %result, align 4
  %cmp3 = icmp eq i32 %14, 1
  br i1 %cmp3, label %if.then, label %if.else

if.then:                                          ; preds = %lor.end
  call void @klee_warning(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.5, i64 0, i64 0))
  %15 = load i32, i32* %result, align 4
  %cmp5 = icmp eq i32 %15, 1
  br i1 %cmp5, label %cond.true, label %cond.false

cond.true:                                        ; preds = %if.then
  br label %cond.end

cond.false:                                       ; preds = %if.then
  %call7 = call i32 (i8*, i8*, i32, i8*, ...) bitcast (i32 (...)* @__assert_fail to i32 (i8*, i8*, i32, i8*, ...)*)(i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.6, i64 0, i64 0), i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.7, i64 0, i64 0), i32 75, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0))
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  br label %if.end

if.else:                                          ; preds = %lor.end
  call void @klee_warning(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.8, i64 0, i64 0))
  %16 = load i32, i32* %result, align 4
  %cmp8 = icmp eq i32 %16, 0
  br i1 %cmp8, label %cond.true10, label %cond.false11

cond.true10:                                      ; preds = %if.else
  br label %cond.end13

cond.false11:                                     ; preds = %if.else
  %call12 = call i32 (i8*, i8*, i32, i8*, ...) bitcast (i32 (...)* @__assert_fail to i32 (i8*, i8*, i32, i8*, ...)*)(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.9, i64 0, i64 0), i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.7, i64 0, i64 0), i32 78, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0))
  br label %cond.end13

cond.end13:                                       ; preds = %cond.false11, %cond.true10
  br label %if.end

if.end:                                           ; preds = %cond.end13, %cond.end
  %17 = load i32, i32* %result, align 4
  ret i32 %17
}

declare dso_local void @klee_make_symbolic(i8*, i64, i8*) #3

declare dso_local void @klee_assume(i64) #3

declare dso_local void @klee_warning(i8*) #3

; Function Attrs: noreturn
declare dso_local i32 @__assert_fail(...) #4

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @memcpy(i8* %destaddr, i8* %srcaddr, i64 %len) #5 !dbg !13 {
entry:
  %destaddr.addr = alloca i8*, align 8
  %srcaddr.addr = alloca i8*, align 8
  %len.addr = alloca i64, align 8
  %dest = alloca i8*, align 8
  %src = alloca i8*, align 8
  store i8* %destaddr, i8** %destaddr.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %destaddr.addr, metadata !23, metadata !DIExpression()), !dbg !24
  store i8* %srcaddr, i8** %srcaddr.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %srcaddr.addr, metadata !25, metadata !DIExpression()), !dbg !26
  store i64 %len, i64* %len.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %len.addr, metadata !27, metadata !DIExpression()), !dbg !28
  call void @llvm.dbg.declare(metadata i8** %dest, metadata !29, metadata !DIExpression()), !dbg !32
  %0 = load i8*, i8** %destaddr.addr, align 8, !dbg !33
  store i8* %0, i8** %dest, align 8, !dbg !32
  call void @llvm.dbg.declare(metadata i8** %src, metadata !34, metadata !DIExpression()), !dbg !37
  %1 = load i8*, i8** %srcaddr.addr, align 8, !dbg !38
  store i8* %1, i8** %src, align 8, !dbg !37
  br label %while.cond, !dbg !39

while.cond:                                       ; preds = %while.body, %entry
  %2 = load i64, i64* %len.addr, align 8, !dbg !40
  %dec = add i64 %2, -1, !dbg !40
  store i64 %dec, i64* %len.addr, align 8, !dbg !40
  %cmp = icmp ugt i64 %2, 0, !dbg !41
  br i1 %cmp, label %while.body, label %while.end, !dbg !39

while.body:                                       ; preds = %while.cond
  %3 = load i8*, i8** %src, align 8, !dbg !42
  %incdec.ptr = getelementptr inbounds i8, i8* %3, i32 1, !dbg !42
  store i8* %incdec.ptr, i8** %src, align 8, !dbg !42
  %4 = load i8, i8* %3, align 1, !dbg !43
  %5 = load i8*, i8** %dest, align 8, !dbg !44
  %incdec.ptr1 = getelementptr inbounds i8, i8* %5, i32 1, !dbg !44
  store i8* %incdec.ptr1, i8** %dest, align 8, !dbg !44
  store i8 %4, i8* %5, align 1, !dbg !45
  br label %while.cond, !dbg !39, !llvm.loop !46

while.end:                                        ; preds = %while.cond
  %6 = load i8*, i8** %destaddr.addr, align 8, !dbg !47
  ret i8* %6, !dbg !48
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #6

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @memset(i8* %dst, i32 %s, i64 %count) #5 !dbg !49 {
entry:
  %dst.addr = alloca i8*, align 8
  %s.addr = alloca i32, align 4
  %count.addr = alloca i64, align 8
  %a = alloca i8*, align 8
  store i8* %dst, i8** %dst.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %dst.addr, metadata !54, metadata !DIExpression()), !dbg !55
  store i32 %s, i32* %s.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %s.addr, metadata !56, metadata !DIExpression()), !dbg !57
  store i64 %count, i64* %count.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %count.addr, metadata !58, metadata !DIExpression()), !dbg !59
  call void @llvm.dbg.declare(metadata i8** %a, metadata !60, metadata !DIExpression()), !dbg !61
  %0 = load i8*, i8** %dst.addr, align 8, !dbg !62
  store i8* %0, i8** %a, align 8, !dbg !61
  br label %while.cond, !dbg !63

while.cond:                                       ; preds = %while.body, %entry
  %1 = load i64, i64* %count.addr, align 8, !dbg !64
  %dec = add i64 %1, -1, !dbg !64
  store i64 %dec, i64* %count.addr, align 8, !dbg !64
  %cmp = icmp ugt i64 %1, 0, !dbg !65
  br i1 %cmp, label %while.body, label %while.end, !dbg !63

while.body:                                       ; preds = %while.cond
  %2 = load i32, i32* %s.addr, align 4, !dbg !66
  %conv = trunc i32 %2 to i8, !dbg !66
  %3 = load i8*, i8** %a, align 8, !dbg !67
  %incdec.ptr = getelementptr inbounds i8, i8* %3, i32 1, !dbg !67
  store i8* %incdec.ptr, i8** %a, align 8, !dbg !67
  store i8 %conv, i8* %3, align 1, !dbg !68
  br label %while.cond, !dbg !63, !llvm.loop !69

while.end:                                        ; preds = %while.cond
  %4 = load i8*, i8** %dst.addr, align 8, !dbg !70
  ret i8* %4, !dbg !71
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly nofree nounwind willreturn }
attributes #2 = { argmemonly nofree nounwind willreturn writeonly }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nofree nosync nounwind readnone speculatable willreturn }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5, !5, !5}
!llvm.dbg.cu = !{!6, !9}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"uwtable", i32 1}
!2 = !{i32 7, !"frame-pointer", i32 2}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{!"clang version 13.0.1 (https://github.com/llvm/llvm-project.git 75e33f71c2dae584b13a7d1186ae0a038ba98838)"}
!6 = distinct !DICompileUnit(language: DW_LANG_C99, file: !7, producer: "clang version 13.0.1 (https://github.com/llvm/llvm-project.git 75e33f71c2dae584b13a7d1186ae0a038ba98838)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !8, splitDebugInlining: false, nameTableKind: None)
!7 = !DIFile(filename: "/tmp/klee_src/runtime/Freestanding/memcpy.c", directory: "/tmp/klee_build130stp_z3/runtime/Freestanding")
!8 = !{}
!9 = distinct !DICompileUnit(language: DW_LANG_C99, file: !10, producer: "clang version 13.0.1 (https://github.com/llvm/llvm-project.git 75e33f71c2dae584b13a7d1186ae0a038ba98838)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !8, splitDebugInlining: false, nameTableKind: None)
!10 = !DIFile(filename: "/tmp/klee_src/runtime/Freestanding/memset.c", directory: "/tmp/klee_build130stp_z3/runtime/Freestanding")
!11 = distinct !{!11, !12}
!12 = !{!"llvm.loop.mustprogress"}
!13 = distinct !DISubprogram(name: "memcpy", scope: !14, file: !14, line: 12, type: !15, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !6, retainedNodes: !8)
!14 = !DIFile(filename: "klee_src/runtime/Freestanding/memcpy.c", directory: "/tmp")
!15 = !DISubroutineType(types: !16)
!16 = !{!17, !17, !18, !20}
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!19 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !21, line: 46, baseType: !22)
!21 = !DIFile(filename: "llvm-130-install_O_D_A/lib/clang/13.0.1/include/stddef.h", directory: "/tmp")
!22 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!23 = !DILocalVariable(name: "destaddr", arg: 1, scope: !13, file: !14, line: 12, type: !17)
!24 = !DILocation(line: 12, column: 20, scope: !13)
!25 = !DILocalVariable(name: "srcaddr", arg: 2, scope: !13, file: !14, line: 12, type: !18)
!26 = !DILocation(line: 12, column: 42, scope: !13)
!27 = !DILocalVariable(name: "len", arg: 3, scope: !13, file: !14, line: 12, type: !20)
!28 = !DILocation(line: 12, column: 58, scope: !13)
!29 = !DILocalVariable(name: "dest", scope: !13, file: !14, line: 13, type: !30)
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!31 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!32 = !DILocation(line: 13, column: 9, scope: !13)
!33 = !DILocation(line: 13, column: 16, scope: !13)
!34 = !DILocalVariable(name: "src", scope: !13, file: !14, line: 14, type: !35)
!35 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !36, size: 64)
!36 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !31)
!37 = !DILocation(line: 14, column: 15, scope: !13)
!38 = !DILocation(line: 14, column: 21, scope: !13)
!39 = !DILocation(line: 16, column: 3, scope: !13)
!40 = !DILocation(line: 16, column: 13, scope: !13)
!41 = !DILocation(line: 16, column: 16, scope: !13)
!42 = !DILocation(line: 17, column: 19, scope: !13)
!43 = !DILocation(line: 17, column: 15, scope: !13)
!44 = !DILocation(line: 17, column: 10, scope: !13)
!45 = !DILocation(line: 17, column: 13, scope: !13)
!46 = distinct !{!46, !39, !42, !12}
!47 = !DILocation(line: 18, column: 10, scope: !13)
!48 = !DILocation(line: 18, column: 3, scope: !13)
!49 = distinct !DISubprogram(name: "memset", scope: !50, file: !50, line: 12, type: !51, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !9, retainedNodes: !8)
!50 = !DIFile(filename: "klee_src/runtime/Freestanding/memset.c", directory: "/tmp")
!51 = !DISubroutineType(types: !52)
!52 = !{!17, !17, !53, !20}
!53 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!54 = !DILocalVariable(name: "dst", arg: 1, scope: !49, file: !50, line: 12, type: !17)
!55 = !DILocation(line: 12, column: 20, scope: !49)
!56 = !DILocalVariable(name: "s", arg: 2, scope: !49, file: !50, line: 12, type: !53)
!57 = !DILocation(line: 12, column: 29, scope: !49)
!58 = !DILocalVariable(name: "count", arg: 3, scope: !49, file: !50, line: 12, type: !20)
!59 = !DILocation(line: 12, column: 39, scope: !49)
!60 = !DILocalVariable(name: "a", scope: !49, file: !50, line: 13, type: !30)
!61 = !DILocation(line: 13, column: 9, scope: !49)
!62 = !DILocation(line: 13, column: 13, scope: !49)
!63 = !DILocation(line: 14, column: 3, scope: !49)
!64 = !DILocation(line: 14, column: 15, scope: !49)
!65 = !DILocation(line: 14, column: 18, scope: !49)
!66 = !DILocation(line: 15, column: 12, scope: !49)
!67 = !DILocation(line: 15, column: 7, scope: !49)
!68 = !DILocation(line: 15, column: 10, scope: !49)
!69 = distinct !{!69, !63, !66, !12}
!70 = !DILocation(line: 16, column: 10, scope: !49)
!71 = !DILocation(line: 16, column: 3, scope: !49)
