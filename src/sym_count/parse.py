# supported llvm ir instructions:
# BLOCK_NAME:    ; comments
#   br i1 %700, label %228, label %._crit_edge.loopexit, !dbg !35
#   br type var, label LABEL1, label LABEL2, debug_info
#
#   %700 = icmp slt i32 %699, %34, !dbg !35
#   var = icmp compare_type var_type var1, var2, debug_info
#  
#   %699 = add nuw nsw i32 %261, 1, !dbg !35
#   var = add nuw nsw var_type var1, var2, debug_info
#
#   %261 = phi i32 [ 0, %.lr.ph ], [ %699, %228 ]
#   var = phi type [ val1, label1 ], [ val2, label2 ]
#
#   %34 = sdiv i32 %33, 32, !dbg !33
#   var = sdiv type var1, var2, debug_info
#
#   %33 = add i32 %5, 31, !dbg !31
#   var = add type var1, var2, debug_info
#
#   define void @matmul_kernel(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, i32 %3, i32 %4, i32 %5, i32 %6, i32 %7, i32 %8) local_unnamed_addr !dbg !7 {
#   define return_type @function_name(arg1_type arg1, arg2_type arg2) local_unnamed_addr !dbg !7 {
