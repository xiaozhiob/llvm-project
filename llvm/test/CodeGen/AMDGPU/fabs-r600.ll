; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 5
; RUN: llc -march=r600 -mcpu=redwood < %s | FileCheck -check-prefix=R600 %s


; DAGCombiner will transform:
; (fabsf (f32 bitcast (i32 a))) => (f32 bitcast (and (i32 a), 0x7FFFFFFF))
; unless isFabsFree returns true
define amdgpu_kernel void @s_fabsf_fn_free(ptr addrspace(1) %out, i32 %in) {
; R600-LABEL: s_fabsf_fn_free:
; R600:       ; %bb.0:
; R600-NEXT:    ALU 3, @4, KC0[CB0:0-32], KC1[]
; R600-NEXT:    MEM_RAT_CACHELESS STORE_RAW T0.X, T1.X, 1
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
; R600-NEXT:    ALU clause starting at 4:
; R600-NEXT:     MOV * T0.W, KC0[2].Z,
; R600-NEXT:     MOV T0.X, |PV.W|,
; R600-NEXT:     LSHR * T1.X, KC0[2].Y, literal.x,
; R600-NEXT:    2(2.802597e-45), 0(0.000000e+00)
  %bc= bitcast i32 %in to float
  %fabs = call float @fabsf(float %bc)
  store float %fabs, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @s_fabsf_free(ptr addrspace(1) %out, i32 %in) {
; R600-LABEL: s_fabsf_free:
; R600:       ; %bb.0:
; R600-NEXT:    ALU 3, @4, KC0[CB0:0-32], KC1[]
; R600-NEXT:    MEM_RAT_CACHELESS STORE_RAW T0.X, T1.X, 1
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
; R600-NEXT:    ALU clause starting at 4:
; R600-NEXT:     MOV * T0.W, KC0[2].Z,
; R600-NEXT:     MOV T0.X, |PV.W|,
; R600-NEXT:     LSHR * T1.X, KC0[2].Y, literal.x,
; R600-NEXT:    2(2.802597e-45), 0(0.000000e+00)
  %bc= bitcast i32 %in to float
  %fabs = call float @llvm.fabs.f32(float %bc)
  store float %fabs, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @s_fabsf_f32(ptr addrspace(1) %out, float %in) {
; R600-LABEL: s_fabsf_f32:
; R600:       ; %bb.0:
; R600-NEXT:    ALU 3, @4, KC0[CB0:0-32], KC1[]
; R600-NEXT:    MEM_RAT_CACHELESS STORE_RAW T0.X, T1.X, 1
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
; R600-NEXT:    ALU clause starting at 4:
; R600-NEXT:     MOV * T0.W, KC0[2].Z,
; R600-NEXT:     MOV T0.X, |PV.W|,
; R600-NEXT:     LSHR * T1.X, KC0[2].Y, literal.x,
; R600-NEXT:    2(2.802597e-45), 0(0.000000e+00)
  %fabs = call float @llvm.fabs.f32(float %in)
  store float %fabs, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @fabs_v2f32(ptr addrspace(1) %out, <2 x float> %in) {
; R600-LABEL: fabs_v2f32:
; R600:       ; %bb.0:
; R600-NEXT:    ALU 5, @4, KC0[CB0:0-32], KC1[]
; R600-NEXT:    MEM_RAT_CACHELESS STORE_RAW T0.XY, T1.X, 1
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
; R600-NEXT:    ALU clause starting at 4:
; R600-NEXT:     MOV * T0.W, KC0[3].X,
; R600-NEXT:     MOV T0.Y, |PV.W|,
; R600-NEXT:     MOV * T0.W, KC0[2].W,
; R600-NEXT:     MOV T0.X, |PV.W|,
; R600-NEXT:     LSHR * T1.X, KC0[2].Y, literal.x,
; R600-NEXT:    2(2.802597e-45), 0(0.000000e+00)
  %fabs = call <2 x float> @llvm.fabs.v2f32(<2 x float> %in)
  store <2 x float> %fabs, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @fabsf_v4f32(ptr addrspace(1) %out, <4 x float> %in) {
; R600-LABEL: fabsf_v4f32:
; R600:       ; %bb.0:
; R600-NEXT:    ALU 9, @4, KC0[CB0:0-32], KC1[]
; R600-NEXT:    MEM_RAT_CACHELESS STORE_RAW T0.XYZW, T1.X, 1
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
; R600-NEXT:    ALU clause starting at 4:
; R600-NEXT:     MOV T0.W, KC0[4].X,
; R600-NEXT:     MOV * T1.W, KC0[3].W,
; R600-NEXT:     MOV * T0.W, |PV.W|,
; R600-NEXT:     MOV T0.Z, |T1.W|,
; R600-NEXT:     MOV * T1.W, KC0[3].Z,
; R600-NEXT:     MOV T0.Y, |PV.W|,
; R600-NEXT:     MOV * T1.W, KC0[3].Y,
; R600-NEXT:     MOV T0.X, |PV.W|,
; R600-NEXT:     LSHR * T1.X, KC0[2].Y, literal.x,
; R600-NEXT:    2(2.802597e-45), 0(0.000000e+00)
  %fabs = call <4 x float> @llvm.fabs.v4f32(<4 x float> %in)
  store <4 x float> %fabs, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @fabsf_fn_fold(ptr addrspace(1) %out, float %in0, float %in1) {
; R600-LABEL: fabsf_fn_fold:
; R600:       ; %bb.0:
; R600-NEXT:    ALU 2, @4, KC0[CB0:0-32], KC1[]
; R600-NEXT:    MEM_RAT_CACHELESS STORE_RAW T1.X, T0.X, 1
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
; R600-NEXT:    ALU clause starting at 4:
; R600-NEXT:     LSHR T0.X, KC0[2].Y, literal.x,
; R600-NEXT:     MUL_IEEE * T1.X, |KC0[2].Z|, KC0[2].W,
; R600-NEXT:    2(2.802597e-45), 0(0.000000e+00)
  %fabs = call float @fabsf(float %in0)
  %fmul = fmul float %fabs, %in1
  store float %fmul, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @fabs_fold(ptr addrspace(1) %out, float %in0, float %in1) {
; R600-LABEL: fabs_fold:
; R600:       ; %bb.0:
; R600-NEXT:    ALU 2, @4, KC0[CB0:0-32], KC1[]
; R600-NEXT:    MEM_RAT_CACHELESS STORE_RAW T1.X, T0.X, 1
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
; R600-NEXT:    ALU clause starting at 4:
; R600-NEXT:     LSHR T0.X, KC0[2].Y, literal.x,
; R600-NEXT:     MUL_IEEE * T1.X, |KC0[2].Z|, KC0[2].W,
; R600-NEXT:    2(2.802597e-45), 0(0.000000e+00)
  %fabs = call float @llvm.fabs.f32(float %in0)
  %fmul = fmul float %fabs, %in1
  store float %fmul, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @bitpreserve_fabsf_f32(ptr addrspace(1) %out, float %in) {
; R600-LABEL: bitpreserve_fabsf_f32:
; R600:       ; %bb.0:
; R600-NEXT:    ALU 2, @4, KC0[CB0:0-32], KC1[]
; R600-NEXT:    MEM_RAT_CACHELESS STORE_RAW T1.X, T0.X, 1
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
; R600-NEXT:    ALU clause starting at 4:
; R600-NEXT:     LSHR T0.X, KC0[2].Y, literal.x,
; R600-NEXT:     ADD * T1.X, |KC0[2].Z|, 1.0,
; R600-NEXT:    2(2.802597e-45), 0(0.000000e+00)
  %in.bc = bitcast float %in to i32
  %int.abs = and i32 %in.bc, 2147483647
  %bc = bitcast i32 %int.abs to float
  %fadd = fadd float %bc, 1.0
  store float %fadd, ptr addrspace(1) %out
  ret void
}

declare float @fabsf(float) readnone
declare float @llvm.fabs.f32(float) readnone
declare <2 x float> @llvm.fabs.v2f32(<2 x float>) readnone
declare <4 x float> @llvm.fabs.v4f32(<4 x float>) readnone
