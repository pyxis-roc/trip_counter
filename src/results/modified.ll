; ModuleID = '../../kernel_examples/matmul/matmul_kernel.llir'
source_filename = "LLVMDialectModule"

@global_smem = external local_unnamed_addr addrspace(3) global [0 x i8], align 16
@_bbCounter = common global i64 0
@.._crit_edge_crit_edge_bbCounter = common global i64 0
@.lr.ph_bbCounter = common global i64 0
@_bbCounter.1 = common global i64 0
@._crit_edge.loopexit_bbCounter = common global i64 0
@._crit_edge_bbCounter = common global i64 0

define void @matmul_kernel(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, i32 %3, i32 %4, i32 %5, i32 %6, i32 %7, i32 %8) local_unnamed_addr !dbg !7 {
  %10 = tail call i32 asm "mov.u32 $0, %ctaid.x;", "=r"() #2, !dbg !10
  %11 = add i32 %3, 31, !dbg !11
  %12 = sdiv i32 %11, 32, !dbg !15
  %13 = add i32 %4, 63, !dbg !16
  %14 = sdiv i32 %13, 64, !dbg !18
  %15 = shl nsw i32 %14, 3, !dbg !19
  %.frozen = freeze i32 %10
  %.frozen230 = freeze i32 %15
  %16 = sdiv i32 %.frozen, %.frozen230, !dbg !20
  %17 = shl i32 %16, 3, !dbg !21
  %18 = sub i32 %12, %17, !dbg !22
  %19 = tail call i32 @llvm.smin.i32(i32 %18, i32 8), !dbg !23
  %20 = mul i32 %16, %.frozen230
  %.decomposed = sub i32 %.frozen, %20
  %.frozen231 = freeze i32 %19
  %21 = sdiv i32 %.decomposed, %.frozen231, !dbg !24
  %22 = mul i32 %21, %.frozen231
  %.decomposed232 = sub i32 %.decomposed, %22
  %23 = add i32 %.decomposed232, %17, !dbg !25
  %24 = shl i32 %23, 5, !dbg !26
  %25 = tail call i32 @llvm.nvvm.read.ptx.sreg.tid.x(), !dbg !27
  %26 = lshr i32 %25, 5, !dbg !27
  %27 = and i32 %25, 4, !dbg !27
  %28 = lshr i32 %25, 1, !dbg !27
  %29 = and i32 %28, 8, !dbg !27
  %30 = shl i32 %21, 6, !dbg !28
  %31 = and i32 %25, 1, !dbg !29
  %32 = shl nuw nsw i32 %31, 4, !dbg !30
  %33 = add i32 %5, 31, !dbg !31
  %34 = sdiv i32 %33, 32, !dbg !33
  %35 = tail call half asm "cvt.rz.f16.f32 $0, $1;", "=h,r"(float 0.000000e+00) #2, !dbg !34
  %36 = insertelement <2 x half> poison, half %35, i64 0, !dbg !34
  %37 = shufflevector <2 x half> %36, <2 x half> poison, <2 x i32> zeroinitializer, !dbg !34
  %38 = bitcast <2 x half> %37 to i32, !dbg !34
  %39 = tail call <4 x i8> asm "{                            \0A.reg .b32 a<2>;              \0Aand.b32 a0, $1, 0xfffefffe;  \0Aand.b32 a1, $2, 0xfffefffe;  \0Aadd.u32 a0, a0, 0x00800080;  \0Aadd.u32 a1, a1, 0x00800080;  \0Aprmt.b32 $0, a0, a1, 0x7531; \0A\09}", "=r,r,r"(i32 %38, i32 %38) #2, !dbg !34
  %40 = icmp sgt i32 %33, 31, !dbg !35
  %old.bb.count = load i64, ptr @_bbCounter, align 4
  %new.bb.count = add i64 %old.bb.count, 1
  store i64 %new.bb.count, ptr @_bbCounter, align 4
  br i1 %40, label %.lr.ph, label %.._crit_edge_crit_edge, !dbg !35

.._crit_edge_crit_edge:                           ; preds = %9
  %.pre = and i32 %28, 4, !dbg !36
  %old.bb.count1 = load i64, ptr @.._crit_edge_crit_edge_bbCounter, align 4
  %new.bb.count2 = add i64 %old.bb.count1, 1
  store i64 %new.bb.count2, ptr @.._crit_edge_crit_edge_bbCounter, align 4
  br label %._crit_edge, !dbg !35

.lr.ph:                                           ; preds = %9
  %41 = and i32 %28, 31, !dbg !29
  %42 = or disjoint i32 %41, 32, !dbg !29
  %43 = or disjoint i32 %30, %42, !dbg !37
  %44 = srem i32 %43, %4, !dbg !38
  %45 = mul i32 %44, %7, !dbg !39
  %46 = add i32 %45, %32, !dbg !40
  %47 = sext i32 %46 to i64, !dbg !41
  %48 = getelementptr i8, ptr addrspace(1) %1, i64 %47, !dbg !41
  %49 = or disjoint i32 %30, %41, !dbg !37
  %50 = srem i32 %49, %4, !dbg !38
  %51 = mul i32 %50, %7, !dbg !39
  %52 = add i32 %51, %32, !dbg !40
  %53 = sext i32 %52 to i64, !dbg !41
  %54 = getelementptr i8, ptr addrspace(1) %1, i64 %53, !dbg !41
  %55 = or disjoint i32 %24, %41, !dbg !42
  %56 = srem i32 %55, %3, !dbg !43
  %57 = mul i32 %56, %6, !dbg !44
  %58 = add i32 %57, %32, !dbg !45
  %59 = sext i32 %58 to i64, !dbg !46
  %60 = getelementptr i8, ptr addrspace(1) %0, i64 %59, !dbg !46
  %61 = or disjoint i32 %32, 12, !dbg !30
  %62 = or disjoint i32 %32, 4, !dbg !30
  %63 = and i32 %25, 8, !dbg !27
  %64 = bitcast <4 x i8> %39 to i32
  %trunc = trunc i32 %25 to i5
  %65 = and i5 %trunc, 5
  %mask = tail call i5 @llvm.bitreverse.i5(i5 %65)
  %66 = zext i5 %mask to i32
  %67 = or disjoint i32 %63, %66
  %68 = shl nuw nsw i32 %41, 5
  %69 = or disjoint i32 %67, %68
  %70 = zext nneg i32 %69 to i64
  %71 = getelementptr inbounds half, ptr addrspace(3) @global_smem, i64 %70
  %72 = xor i32 %62, %27
  %73 = or disjoint i32 %72, %63
  %74 = or disjoint i32 %73, %68
  %75 = zext nneg i32 %74 to i64
  %76 = getelementptr inbounds half, ptr addrspace(3) @global_smem, i64 %75
  %77 = or disjoint i5 %65, 2
  %78 = tail call i5 @llvm.bitreverse.i5(i5 %77)
  %79 = zext i5 %78 to i32
  %80 = xor i32 %63, %79
  %81 = or disjoint i32 %80, %68
  %82 = zext nneg i32 %81 to i64
  %83 = getelementptr inbounds half, ptr addrspace(3) @global_smem, i64 %82
  %and.ra = and i32 %25, 12
  %84 = xor i32 %61, %and.ra
  %85 = or disjoint i32 %68, %84
  %86 = zext nneg i32 %85 to i64
  %87 = getelementptr inbounds half, ptr addrspace(3) @global_smem, i64 %86
  %88 = shl nuw nsw i32 %26, 4
  %89 = and i32 %88, 16
  %90 = and i32 %25, 3
  %91 = and i32 %25, 7
  %92 = or disjoint i32 %91, %89
  %93 = or disjoint i32 %92, %29
  %94 = shl nuw nsw i32 %91, 1
  %95 = and i32 %94, 12
  %96 = shl nuw nsw i32 %93, 5
  %97 = or disjoint i32 %95, %96
  %98 = xor i32 %97, 4
  %99 = xor i32 %97, 8
  %100 = xor i32 %97, 12
  %101 = or disjoint i32 %97, 16
  %102 = xor i32 %97, 20
  %103 = xor i32 %97, 24
  %104 = xor i32 %97, 28
  %105 = zext nneg i32 %97 to i64
  %106 = getelementptr half, ptr addrspace(3) @global_smem, i64 %105
  %107 = zext nneg i32 %98 to i64
  %108 = getelementptr half, ptr addrspace(3) @global_smem, i64 %107
  %109 = zext nneg i32 %99 to i64
  %110 = getelementptr half, ptr addrspace(3) @global_smem, i64 %109
  %111 = zext nneg i32 %100 to i64
  %112 = getelementptr half, ptr addrspace(3) @global_smem, i64 %111
  %113 = zext nneg i32 %101 to i64
  %114 = getelementptr half, ptr addrspace(3) @global_smem, i64 %113
  %115 = zext nneg i32 %102 to i64
  %116 = getelementptr half, ptr addrspace(3) @global_smem, i64 %115
  %117 = zext nneg i32 %103 to i64
  %118 = getelementptr half, ptr addrspace(3) @global_smem, i64 %117
  %119 = zext nneg i32 %104 to i64
  %120 = getelementptr half, ptr addrspace(3) @global_smem, i64 %119
  %121 = shl nuw nsw i32 %42, 5
  %122 = or disjoint i32 %121, %67
  %123 = zext nneg i32 %122 to i64
  %124 = getelementptr inbounds half, ptr addrspace(3) @global_smem, i64 %123
  %125 = or disjoint i32 %121, %73
  %126 = zext nneg i32 %125 to i64
  %127 = getelementptr inbounds half, ptr addrspace(3) @global_smem, i64 %126
  %128 = or disjoint i32 %80, %121
  %129 = zext nneg i32 %128 to i64
  %130 = getelementptr inbounds half, ptr addrspace(3) @global_smem, i64 %129
  %131 = or disjoint i32 %121, %84
  %132 = zext nneg i32 %131 to i64
  %133 = getelementptr inbounds half, ptr addrspace(3) @global_smem, i64 %132
  %134 = and i32 %28, 4
  %135 = or disjoint i32 %90, %134
  %136 = or disjoint i32 %135, %29
  %137 = shl nuw nsw i32 %135, 1
  %138 = and i32 %137, 12
  %139 = shl nuw nsw i32 %136, 5
  %140 = or disjoint i32 %138, %139
  %141 = xor i32 %140, 4
  %142 = xor i32 %140, 8
  %143 = xor i32 %140, 12
  %144 = or disjoint i32 %140, 16
  %145 = xor i32 %140, 20
  %146 = xor i32 %140, 24
  %147 = xor i32 %140, 28
  %148 = zext nneg i32 %140 to i64
  %149 = getelementptr half, ptr addrspace(3) @global_smem, i64 %148
  %150 = zext nneg i32 %141 to i64
  %151 = getelementptr half, ptr addrspace(3) @global_smem, i64 %150
  %152 = zext nneg i32 %142 to i64
  %153 = getelementptr half, ptr addrspace(3) @global_smem, i64 %152
  %154 = zext nneg i32 %143 to i64
  %155 = getelementptr half, ptr addrspace(3) @global_smem, i64 %154
  %156 = zext nneg i32 %144 to i64
  %157 = getelementptr half, ptr addrspace(3) @global_smem, i64 %156
  %158 = zext nneg i32 %145 to i64
  %159 = getelementptr half, ptr addrspace(3) @global_smem, i64 %158
  %160 = zext nneg i32 %146 to i64
  %161 = getelementptr half, ptr addrspace(3) @global_smem, i64 %160
  %162 = zext nneg i32 %147 to i64
  %163 = getelementptr half, ptr addrspace(3) @global_smem, i64 %162
  %164 = getelementptr i8, ptr addrspace(3) %149, i64 1024
  %165 = getelementptr i8, ptr addrspace(3) %149, i64 2048
  %166 = getelementptr i8, ptr addrspace(3) %149, i64 3072
  %167 = getelementptr i8, ptr addrspace(3) %151, i64 1024
  %168 = getelementptr i8, ptr addrspace(3) %151, i64 2048
  %169 = getelementptr i8, ptr addrspace(3) %151, i64 3072
  %170 = getelementptr i8, ptr addrspace(3) %153, i64 1024
  %171 = getelementptr i8, ptr addrspace(3) %153, i64 2048
  %172 = getelementptr i8, ptr addrspace(3) %153, i64 3072
  %173 = getelementptr i8, ptr addrspace(3) %155, i64 1024
  %174 = getelementptr i8, ptr addrspace(3) %155, i64 2048
  %175 = getelementptr i8, ptr addrspace(3) %155, i64 3072
  %176 = getelementptr i8, ptr addrspace(3) %157, i64 1024
  %177 = getelementptr i8, ptr addrspace(3) %157, i64 2048
  %178 = getelementptr i8, ptr addrspace(3) %157, i64 3072
  %179 = getelementptr i8, ptr addrspace(3) %159, i64 1024
  %180 = getelementptr i8, ptr addrspace(3) %159, i64 2048
  %181 = getelementptr i8, ptr addrspace(3) %159, i64 3072
  %182 = getelementptr i8, ptr addrspace(3) %161, i64 1024
  %183 = getelementptr i8, ptr addrspace(3) %161, i64 2048
  %184 = getelementptr i8, ptr addrspace(3) %161, i64 3072
  %185 = getelementptr i8, ptr addrspace(3) %163, i64 1024
  %186 = getelementptr i8, ptr addrspace(3) %163, i64 2048
  %187 = getelementptr i8, ptr addrspace(3) %163, i64 3072
  %188 = getelementptr inbounds i8, ptr addrspace(3) %106, i64 4
  %189 = getelementptr inbounds i8, ptr addrspace(3) %108, i64 4
  %190 = getelementptr inbounds i8, ptr addrspace(3) %110, i64 4
  %191 = getelementptr inbounds i8, ptr addrspace(3) %112, i64 4
  %192 = getelementptr inbounds i8, ptr addrspace(3) %114, i64 4
  %193 = getelementptr inbounds i8, ptr addrspace(3) %116, i64 4
  %194 = getelementptr inbounds i8, ptr addrspace(3) %118, i64 4
  %195 = getelementptr inbounds i8, ptr addrspace(3) %120, i64 4
  %196 = getelementptr inbounds i8, ptr addrspace(3) %149, i64 4
  %197 = getelementptr i8, ptr addrspace(3) %149, i64 1028
  %198 = getelementptr i8, ptr addrspace(3) %149, i64 2052
  %199 = getelementptr i8, ptr addrspace(3) %149, i64 3076
  %200 = getelementptr inbounds i8, ptr addrspace(3) %151, i64 4
  %201 = getelementptr i8, ptr addrspace(3) %151, i64 1028
  %202 = getelementptr i8, ptr addrspace(3) %151, i64 2052
  %203 = getelementptr i8, ptr addrspace(3) %151, i64 3076
  %204 = getelementptr inbounds i8, ptr addrspace(3) %153, i64 4
  %205 = getelementptr i8, ptr addrspace(3) %153, i64 1028
  %206 = getelementptr i8, ptr addrspace(3) %153, i64 2052
  %207 = getelementptr i8, ptr addrspace(3) %153, i64 3076
  %208 = getelementptr inbounds i8, ptr addrspace(3) %155, i64 4
  %209 = getelementptr i8, ptr addrspace(3) %155, i64 1028
  %210 = getelementptr i8, ptr addrspace(3) %155, i64 2052
  %211 = getelementptr i8, ptr addrspace(3) %155, i64 3076
  %212 = getelementptr inbounds i8, ptr addrspace(3) %157, i64 4
  %213 = getelementptr i8, ptr addrspace(3) %157, i64 1028
  %214 = getelementptr i8, ptr addrspace(3) %157, i64 2052
  %215 = getelementptr i8, ptr addrspace(3) %157, i64 3076
  %216 = getelementptr inbounds i8, ptr addrspace(3) %159, i64 4
  %217 = getelementptr i8, ptr addrspace(3) %159, i64 1028
  %218 = getelementptr i8, ptr addrspace(3) %159, i64 2052
  %219 = getelementptr i8, ptr addrspace(3) %159, i64 3076
  %220 = getelementptr inbounds i8, ptr addrspace(3) %161, i64 4
  %221 = getelementptr i8, ptr addrspace(3) %161, i64 1028
  %222 = getelementptr i8, ptr addrspace(3) %161, i64 2052
  %223 = getelementptr i8, ptr addrspace(3) %161, i64 3076
  %224 = getelementptr inbounds i8, ptr addrspace(3) %163, i64 4
  %225 = getelementptr i8, ptr addrspace(3) %163, i64 1028
  %226 = getelementptr i8, ptr addrspace(3) %163, i64 2052
  %227 = getelementptr i8, ptr addrspace(3) %163, i64 3076
  %old.bb.count3 = load i64, ptr @.lr.ph_bbCounter, align 4
  %new.bb.count4 = add i64 %old.bb.count3, 1
  store i64 %new.bb.count4, ptr @.lr.ph_bbCounter, align 4
  br label %228, !dbg !35

228:                                              ; preds = %.lr.ph
  %old.bb.count5 = load i64, ptr @_bbCounter.1, align 4
  %new.bb.count6 = add i64 %old.bb.count5, 1
  store i64 %new.bb.count6, ptr @_bbCounter.1, align 4
  br label %._crit_edge.loopexit

._crit_edge.loopexit:                             ; preds = %228
  %229 = insertelement <32 x float> poison, float undef, i64 0, !dbg !47
  %230 = insertelement <32 x float> %229, float undef, i64 1, !dbg !47
  %231 = insertelement <32 x float> %230, float undef, i64 2, !dbg !47
  %232 = insertelement <32 x float> %231, float undef, i64 3, !dbg !47
  %233 = insertelement <32 x float> %232, float undef, i64 4, !dbg !47
  %234 = insertelement <32 x float> %233, float undef, i64 5, !dbg !47
  %235 = insertelement <32 x float> %234, float undef, i64 6, !dbg !47
  %236 = insertelement <32 x float> %235, float undef, i64 7, !dbg !47
  %237 = insertelement <32 x float> %236, float undef, i64 8, !dbg !47
  %238 = insertelement <32 x float> %237, float undef, i64 9, !dbg !47
  %239 = insertelement <32 x float> %238, float undef, i64 10, !dbg !47
  %240 = insertelement <32 x float> %239, float undef, i64 11, !dbg !47
  %241 = insertelement <32 x float> %240, float undef, i64 12, !dbg !47
  %242 = insertelement <32 x float> %241, float undef, i64 13, !dbg !47
  %243 = insertelement <32 x float> %242, float undef, i64 14, !dbg !47
  %244 = insertelement <32 x float> %243, float undef, i64 15, !dbg !47
  %245 = insertelement <32 x float> %244, float undef, i64 16, !dbg !47
  %246 = insertelement <32 x float> %245, float undef, i64 17, !dbg !47
  %247 = insertelement <32 x float> %246, float undef, i64 18, !dbg !47
  %248 = insertelement <32 x float> %247, float undef, i64 19, !dbg !47
  %249 = insertelement <32 x float> %248, float undef, i64 20, !dbg !47
  %250 = insertelement <32 x float> %249, float undef, i64 21, !dbg !47
  %251 = insertelement <32 x float> %250, float undef, i64 22, !dbg !47
  %252 = insertelement <32 x float> %251, float undef, i64 23, !dbg !47
  %253 = insertelement <32 x float> %252, float undef, i64 24, !dbg !47
  %254 = insertelement <32 x float> %253, float undef, i64 25, !dbg !47
  %255 = insertelement <32 x float> %254, float undef, i64 26, !dbg !47
  %256 = insertelement <32 x float> %255, float undef, i64 27, !dbg !47
  %257 = insertelement <32 x float> %256, float undef, i64 28, !dbg !47
  %258 = insertelement <32 x float> %257, float undef, i64 29, !dbg !47
  %259 = insertelement <32 x float> %258, float undef, i64 30, !dbg !47
  %260 = insertelement <32 x float> %259, float undef, i64 31, !dbg !47
  %261 = fptrunc <32 x float> %260 to <32 x half>, !dbg !47
  %old.bb.count7 = load i64, ptr @._crit_edge.loopexit_bbCounter, align 4
  %new.bb.count8 = add i64 %old.bb.count7, 1
  store i64 %new.bb.count8, ptr @._crit_edge.loopexit_bbCounter, align 4
  br label %._crit_edge, !dbg !27

._crit_edge:                                      ; preds = %._crit_edge.loopexit, %.._crit_edge_crit_edge
  %.pre-phi = phi i32 [ %.pre, %.._crit_edge_crit_edge ], [ %134, %._crit_edge.loopexit ], !dbg !36
  %262 = phi <32 x half> [ zeroinitializer, %.._crit_edge_crit_edge ], [ %261, %._crit_edge.loopexit ]
  %263 = and i32 %25, 2, !dbg !27
  %264 = shl i32 %25, 3, !dbg !29
  %265 = and i32 %264, 56, !dbg !29
  %266 = or disjoint i32 %30, %265, !dbg !37
  %267 = lshr i32 %25, 3, !dbg !27
  %268 = and i32 %267, 7, !dbg !27
  %269 = or disjoint i32 %268, %24, !dbg !42
  %270 = or disjoint i32 %269, 24, !dbg !42
  %271 = or disjoint i32 %269, 16, !dbg !42
  %272 = or disjoint i32 %269, 8, !dbg !42
  %273 = mul i32 %269, %8, !dbg !48
  %274 = mul i32 %272, %8, !dbg !48
  %275 = mul i32 %271, %8, !dbg !48
  %276 = mul i32 %270, %8, !dbg !48
  %277 = sext i32 %273 to i64, !dbg !49
  %278 = getelementptr half, ptr addrspace(1) %2, i64 %277, !dbg !49
  %279 = sext i32 %274 to i64, !dbg !49
  %280 = getelementptr half, ptr addrspace(1) %2, i64 %279, !dbg !49
  %281 = sext i32 %275 to i64, !dbg !49
  %282 = getelementptr half, ptr addrspace(1) %2, i64 %281, !dbg !49
  %283 = sext i32 %276 to i64, !dbg !49
  %284 = getelementptr half, ptr addrspace(1) %2, i64 %283, !dbg !49
  %285 = sext i32 %266 to i64, !dbg !50
  %286 = getelementptr half, ptr addrspace(1) %278, i64 %285, !dbg !50
  %287 = getelementptr half, ptr addrspace(1) %280, i64 %285, !dbg !50
  %288 = getelementptr half, ptr addrspace(1) %282, i64 %285, !dbg !50
  %289 = getelementptr half, ptr addrspace(1) %284, i64 %285, !dbg !50
  %290 = icmp slt i32 %269, %3, !dbg !51
  %291 = icmp slt i32 %272, %3, !dbg !51
  %292 = icmp slt i32 %271, %3, !dbg !51
  %293 = icmp slt i32 %270, %3, !dbg !51
  %294 = icmp slt i32 %266, %4, !dbg !52
  %295 = and i1 %290, %294, !dbg !53
  %296 = and i1 %291, %294, !dbg !53
  %297 = and i1 %292, %294, !dbg !53
  %298 = and i1 %293, %294, !dbg !53
  tail call void @llvm.nvvm.barrier0(), !dbg !36
  %299 = and i32 %26, 1, !dbg !36
  %300 = shl nuw nsw i32 %299, 4, !dbg !36
  %301 = or disjoint i32 %300, %29, !dbg !36
  %302 = or disjoint i32 %301, %27, !dbg !36
  %303 = or disjoint i32 %302, %31, !dbg !36
  %304 = or disjoint i32 %.pre-phi, %263, !dbg !36
  %305 = or disjoint i32 %304, 8, !dbg !36
  %306 = or disjoint i32 %304, 16, !dbg !36
  %307 = or disjoint i32 %304, 24, !dbg !36
  %308 = or disjoint i32 %304, 32, !dbg !36
  %309 = or disjoint i32 %304, 40, !dbg !36
  %310 = or disjoint i32 %304, 48, !dbg !36
  %311 = or disjoint i32 %304, 56, !dbg !36
  %312 = mul nuw nsw i32 %303, 72, !dbg !36
  %313 = or disjoint i32 %312, %304, !dbg !36
  %314 = zext nneg i32 %313 to i64, !dbg !36
  %315 = getelementptr half, ptr addrspace(3) @global_smem, i64 %314, !dbg !36
  %316 = shufflevector <32 x half> %262, <32 x half> poison, <2 x i32> <i32 0, i32 2>, !dbg !36
  store <2 x half> %316, ptr addrspace(3) %315, align 4, !dbg !36
  %317 = add nuw nsw i32 %312, %305, !dbg !36
  %318 = zext nneg i32 %317 to i64, !dbg !36
  %319 = getelementptr half, ptr addrspace(3) @global_smem, i64 %318, !dbg !36
  %320 = shufflevector <32 x half> %262, <32 x half> poison, <2 x i32> <i32 4, i32 6>, !dbg !36
  store <2 x half> %320, ptr addrspace(3) %319, align 4, !dbg !36
  %321 = add nuw nsw i32 %312, %306, !dbg !36
  %322 = zext nneg i32 %321 to i64, !dbg !36
  %323 = getelementptr half, ptr addrspace(3) @global_smem, i64 %322, !dbg !36
  %324 = shufflevector <32 x half> %262, <32 x half> poison, <2 x i32> <i32 8, i32 10>, !dbg !36
  store <2 x half> %324, ptr addrspace(3) %323, align 4, !dbg !36
  %325 = add nuw nsw i32 %312, %307, !dbg !36
  %326 = zext nneg i32 %325 to i64, !dbg !36
  %327 = getelementptr half, ptr addrspace(3) @global_smem, i64 %326, !dbg !36
  %328 = shufflevector <32 x half> %262, <32 x half> poison, <2 x i32> <i32 12, i32 14>, !dbg !36
  store <2 x half> %328, ptr addrspace(3) %327, align 4, !dbg !36
  %329 = add nuw nsw i32 %312, %308, !dbg !36
  %330 = zext nneg i32 %329 to i64, !dbg !36
  %331 = getelementptr half, ptr addrspace(3) @global_smem, i64 %330, !dbg !36
  %332 = shufflevector <32 x half> %262, <32 x half> poison, <2 x i32> <i32 16, i32 18>, !dbg !36
  store <2 x half> %332, ptr addrspace(3) %331, align 4, !dbg !36
  %333 = add nuw nsw i32 %312, %309, !dbg !36
  %334 = zext nneg i32 %333 to i64, !dbg !36
  %335 = getelementptr half, ptr addrspace(3) @global_smem, i64 %334, !dbg !36
  %336 = shufflevector <32 x half> %262, <32 x half> poison, <2 x i32> <i32 20, i32 22>, !dbg !36
  store <2 x half> %336, ptr addrspace(3) %335, align 4, !dbg !36
  %337 = add nuw nsw i32 %312, %310, !dbg !36
  %338 = zext nneg i32 %337 to i64, !dbg !36
  %339 = getelementptr half, ptr addrspace(3) @global_smem, i64 %338, !dbg !36
  %340 = shufflevector <32 x half> %262, <32 x half> poison, <2 x i32> <i32 24, i32 26>, !dbg !36
  store <2 x half> %340, ptr addrspace(3) %339, align 4, !dbg !36
  %341 = add nuw nsw i32 %312, %311, !dbg !36
  %342 = zext nneg i32 %341 to i64, !dbg !36
  %343 = getelementptr half, ptr addrspace(3) @global_smem, i64 %342, !dbg !36
  %344 = shufflevector <32 x half> %262, <32 x half> poison, <2 x i32> <i32 28, i32 30>, !dbg !36
  store <2 x half> %344, ptr addrspace(3) %343, align 4, !dbg !36
  %345 = add nuw nsw i32 %312, 144, !dbg !36
  %346 = or disjoint i32 %345, %304, !dbg !36
  %347 = zext nneg i32 %346 to i64
  %348 = getelementptr half, ptr addrspace(3) @global_smem, i64 %347, !dbg !36
  %349 = shufflevector <32 x half> %262, <32 x half> poison, <2 x i32> <i32 1, i32 3>, !dbg !36
  store <2 x half> %349, ptr addrspace(3) %348, align 4, !dbg !36
  %350 = add nuw nsw i32 %345, %305, !dbg !36
  %351 = zext nneg i32 %350 to i64
  %352 = getelementptr half, ptr addrspace(3) @global_smem, i64 %351, !dbg !36
  %353 = shufflevector <32 x half> %262, <32 x half> poison, <2 x i32> <i32 5, i32 7>, !dbg !36
  store <2 x half> %353, ptr addrspace(3) %352, align 4, !dbg !36
  %354 = add nuw nsw i32 %345, %306, !dbg !36
  %355 = zext nneg i32 %354 to i64
  %356 = getelementptr half, ptr addrspace(3) @global_smem, i64 %355, !dbg !36
  %357 = shufflevector <32 x half> %262, <32 x half> poison, <2 x i32> <i32 9, i32 11>, !dbg !36
  store <2 x half> %357, ptr addrspace(3) %356, align 4, !dbg !36
  %358 = add nuw nsw i32 %345, %307, !dbg !36
  %359 = zext nneg i32 %358 to i64
  %360 = getelementptr half, ptr addrspace(3) @global_smem, i64 %359, !dbg !36
  %361 = shufflevector <32 x half> %262, <32 x half> poison, <2 x i32> <i32 13, i32 15>, !dbg !36
  store <2 x half> %361, ptr addrspace(3) %360, align 4, !dbg !36
  %362 = add nuw nsw i32 %345, %308, !dbg !36
  %363 = zext nneg i32 %362 to i64
  %364 = getelementptr half, ptr addrspace(3) @global_smem, i64 %363, !dbg !36
  %365 = shufflevector <32 x half> %262, <32 x half> poison, <2 x i32> <i32 17, i32 19>, !dbg !36
  store <2 x half> %365, ptr addrspace(3) %364, align 4, !dbg !36
  %366 = add nuw nsw i32 %345, %309, !dbg !36
  %367 = zext nneg i32 %366 to i64
  %368 = getelementptr half, ptr addrspace(3) @global_smem, i64 %367, !dbg !36
  %369 = shufflevector <32 x half> %262, <32 x half> poison, <2 x i32> <i32 21, i32 23>, !dbg !36
  store <2 x half> %369, ptr addrspace(3) %368, align 4, !dbg !36
  %370 = add nuw nsw i32 %345, %310, !dbg !36
  %371 = zext nneg i32 %370 to i64
  %372 = getelementptr half, ptr addrspace(3) @global_smem, i64 %371, !dbg !36
  %373 = shufflevector <32 x half> %262, <32 x half> poison, <2 x i32> <i32 25, i32 27>, !dbg !36
  store <2 x half> %373, ptr addrspace(3) %372, align 4, !dbg !36
  %374 = add nuw nsw i32 %345, %311, !dbg !36
  %375 = zext nneg i32 %374 to i64
  %376 = getelementptr half, ptr addrspace(3) @global_smem, i64 %375, !dbg !36
  %377 = shufflevector <32 x half> %262, <32 x half> poison, <2 x i32> <i32 29, i32 31>, !dbg !36
  store <2 x half> %377, ptr addrspace(3) %376, align 4, !dbg !36
  tail call void @llvm.nvvm.barrier0(), !dbg !36
  %378 = and i32 %267, 3, !dbg !36
  %379 = shl nuw nsw i32 %299, 2, !dbg !36
  %380 = or disjoint i32 %379, %378, !dbg !36
  %381 = mul nuw nsw i32 %380, 72, !dbg !36
  %382 = add nuw nsw i32 %381, %265, !dbg !36
  %383 = zext nneg i32 %382 to i64, !dbg !36
  %384 = getelementptr half, ptr addrspace(3) @global_smem, i64 %383, !dbg !36
  %385 = getelementptr i8, ptr addrspace(3) %384, i64 1152, !dbg !36
  %386 = load <4 x i32>, ptr addrspace(3) %385, align 16, !dbg !36
  %387 = getelementptr i8, ptr addrspace(3) %384, i64 2304, !dbg !36
  %388 = load <4 x i32>, ptr addrspace(3) %387, align 16, !dbg !36
  %389 = getelementptr i8, ptr addrspace(3) %384, i64 3456, !dbg !36
  %390 = load <4 x i32>, ptr addrspace(3) %389, align 16, !dbg !36
  %.extract = load i32, ptr addrspace(3) %384, align 16, !dbg !36
  %391 = getelementptr inbounds i8, ptr addrspace(3) %384, i64 4, !dbg !36
  %.extract99 = load i32, ptr addrspace(3) %391, align 4, !dbg !36
  %392 = getelementptr inbounds i8, ptr addrspace(3) %384, i64 8, !dbg !36
  %.extract101 = load i32, ptr addrspace(3) %392, align 8, !dbg !36
  %393 = getelementptr inbounds i8, ptr addrspace(3) %384, i64 12, !dbg !36
  %.extract103 = load i32, ptr addrspace(3) %393, align 4, !dbg !36
  tail call void asm sideeffect "@$5 st.global.v4.b32 [ $4 + 0 ], { $0, $1, $2, $3 };", "r,r,r,r,l,b"(i32 %.extract, i32 %.extract99, i32 %.extract101, i32 %.extract103, ptr addrspace(1) %286, i1 %295) #2, !dbg !36
  %.extract105 = extractelement <4 x i32> %386, i64 0, !dbg !36
  %.extract107 = extractelement <4 x i32> %386, i64 1, !dbg !36
  %.extract109 = extractelement <4 x i32> %386, i64 2, !dbg !36
  %.extract111 = extractelement <4 x i32> %386, i64 3, !dbg !36
  tail call void asm sideeffect "@$5 st.global.v4.b32 [ $4 + 0 ], { $0, $1, $2, $3 };", "r,r,r,r,l,b"(i32 %.extract105, i32 %.extract107, i32 %.extract109, i32 %.extract111, ptr addrspace(1) %287, i1 %296) #2, !dbg !36
  %.extract113 = extractelement <4 x i32> %388, i64 0, !dbg !36
  %.extract115 = extractelement <4 x i32> %388, i64 1, !dbg !36
  %.extract117 = extractelement <4 x i32> %388, i64 2, !dbg !36
  %.extract119 = extractelement <4 x i32> %388, i64 3, !dbg !36
  tail call void asm sideeffect "@$5 st.global.v4.b32 [ $4 + 0 ], { $0, $1, $2, $3 };", "r,r,r,r,l,b"(i32 %.extract113, i32 %.extract115, i32 %.extract117, i32 %.extract119, ptr addrspace(1) %288, i1 %297) #2, !dbg !36
  %.extract121 = extractelement <4 x i32> %390, i64 0, !dbg !36
  %.extract123 = extractelement <4 x i32> %390, i64 1, !dbg !36
  %.extract125 = extractelement <4 x i32> %390, i64 2, !dbg !36
  %.extract127 = extractelement <4 x i32> %390, i64 3, !dbg !36
  tail call void asm sideeffect "@$5 st.global.v4.b32 [ $4 + 0 ], { $0, $1, $2, $3 };", "r,r,r,r,l,b"(i32 %.extract121, i32 %.extract123, i32 %.extract125, i32 %.extract127, ptr addrspace(1) %289, i1 %298) #2, !dbg !36
  %old.bb.count9 = load i64, ptr @._crit_edge_bbCounter, align 4
  %new.bb.count10 = add i64 %old.bb.count9, 1
  store i64 %new.bb.count10, ptr @._crit_edge_bbCounter, align 4
  ret void, !dbg !54
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32 %0, i32 %1) #0

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef i32 @llvm.nvvm.read.ptx.sreg.tid.x() #0

; Function Attrs: convergent nocallback nounwind
declare void @llvm.nvvm.barrier0() #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i5 @llvm.bitreverse.i5(i5 %0) #0

define void @print_bb_count() {
entry:
  %bb.count = load i64, ptr @.._crit_edge_crit_edge_bbCounter, align 4
  call void @_Z5printl(i64 %bb.count)
  %bb.count1 = load i64, ptr @._crit_edge.loopexit_bbCounter, align 4
  call void @_Z5printl(i64 %bb.count1)
  %bb.count2 = load i64, ptr @._crit_edge_bbCounter, align 4
  call void @_Z5printl(i64 %bb.count2)
  %bb.count3 = load i64, ptr @.lr.ph_bbCounter, align 4
  call void @_Z5printl(i64 %bb.count3)
  %bb.count4 = load i64, ptr @_bbCounter, align 4
  call void @_Z5printl(i64 %bb.count4)
  ret void
}

declare void @_Z5printl(i64 %0)

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #1 = { convergent nocallback nounwind }
attributes #2 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.dbg.cu = !{!2}
!nvvm.annotations = !{!4, !5}
!llvm.ident = !{!6}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{i32 4, !"nvvm-reflect-ftz", i32 1}
!2 = distinct !DICompileUnit(language: DW_LANG_C, file: !3, producer: "triton", isOptimized: true, runtimeVersion: 0, emissionKind: LineTablesOnly)
!3 = !DIFile(filename: "03-matrix-multiplication.py", directory: "/localdisk/lwsim/triton-tutorial/.")
!4 = !{ptr @matmul_kernel, !"kernel", i32 1}
!5 = !{ptr @matmul_kernel, !"maxntidx", i32 64}
!6 = !{!"clang version 3.8.0 (tags/RELEASE_380/final)"}
!7 = distinct !DISubprogram(name: "matmul_kernel", linkageName: "matmul_kernel", scope: !3, file: !3, line: 242, type: !8, scopeLine: 242, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2)
!8 = !DISubroutineType(cc: DW_CC_normal, types: !9)
!9 = !{}
!10 = !DILocation(line: 265, column: 24, scope: !7)
!11 = !DILocation(line: 40, column: 22, scope: !12, inlinedAt: !14)
!12 = distinct !DILexicalBlockFile(scope: !7, file: !13, discriminator: 0)
!13 = !DIFile(filename: "standard.py", directory: "/localdisk/lwsim/triton/python/triton/language")
!14 = !DILocation(line: 266, column: 27, scope: !7)
!15 = !DILocation(line: 40, column: 28, scope: !12, inlinedAt: !14)
!16 = !DILocation(line: 40, column: 22, scope: !12, inlinedAt: !17)
!17 = !DILocation(line: 267, column: 27, scope: !7)
!18 = !DILocation(line: 40, column: 28, scope: !12, inlinedAt: !17)
!19 = !DILocation(line: 268, column: 38, scope: !7)
!20 = !DILocation(line: 269, column: 22, scope: !7)
!21 = !DILocation(line: 270, column: 29, scope: !7)
!22 = !DILocation(line: 271, column: 35, scope: !7)
!23 = !DILocation(line: 271, column: 48, scope: !7)
!24 = !DILocation(line: 273, column: 40, scope: !7)
!25 = !DILocation(line: 272, column: 27, scope: !7)
!26 = !DILocation(line: 282, column: 23, scope: !7)
!27 = !DILocation(line: 282, column: 51, scope: !7)
!28 = !DILocation(line: 283, column: 23, scope: !7)
!29 = !DILocation(line: 283, column: 51, scope: !7)
!30 = !DILocation(line: 285, column: 60, scope: !7)
!31 = !DILocation(line: 40, column: 22, scope: !12, inlinedAt: !32)
!32 = !DILocation(line: 294, column: 33, scope: !7)
!33 = !DILocation(line: 40, column: 28, scope: !12, inlinedAt: !32)
!34 = !DILocation(line: 297, column: 20, scope: !7)
!35 = !DILocation(line: 294, column: 22, scope: !7)
!36 = !DILocation(line: 316, column: 21, scope: !7)
!37 = !DILocation(line: 283, column: 38, scope: !7)
!38 = !DILocation(line: 283, column: 68, scope: !7)
!39 = !DILocation(line: 286, column: 71, scope: !7)
!40 = !DILocation(line: 286, column: 52, scope: !7)
!41 = !DILocation(line: 286, column: 22, scope: !7)
!42 = !DILocation(line: 282, column: 38, scope: !7)
!43 = !DILocation(line: 282, column: 68, scope: !7)
!44 = !DILocation(line: 285, column: 41, scope: !7)
!45 = !DILocation(line: 285, column: 53, scope: !7)
!46 = !DILocation(line: 285, column: 22, scope: !7)
!47 = !DILocation(line: 308, column: 23, scope: !7)
!48 = !DILocation(line: 314, column: 33, scope: !7)
!49 = !DILocation(line: 314, column: 21, scope: !7)
!50 = !DILocation(line: 314, column: 52, scope: !7)
!51 = !DILocation(line: 315, column: 33, scope: !7)
!52 = !DILocation(line: 315, column: 58, scope: !7)
!53 = !DILocation(line: 315, column: 39, scope: !7)
!54 = !DILocation(line: 316, column: 4, scope: !7)
