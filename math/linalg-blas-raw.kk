/*----------------------------------------------------------------------------
   Copyright 2024, Koka-Community Authors

   Licensed under the MIT License ("The License"). You may not
   use this file except in compliance with the License. A copy of the License
   can be found in the LICENSE file at the root of this distribution.
----------------------------------------------------------------------------*/

// This a module that maps directly to BLAS calls
module math/linalg-blas-raw
import std/test
import std/num/float64
import math/matrix
import math/vector



extern import 
  c file "inline/linalg-blas"

// Computes the sum of magnitudes of the vector elements.
// Level 1 BLAS
pub extern blas/asum( v : blasvector ) : float64
  c "kk_asum"

// Computes a vector-scalar product and adds the result to a vector.
// Level 1 BLAS
// WARNING: This will mutate the `y` `blasvector`.
pub extern blas/axpy( x : blasvector, y : blasvector, scalar : float64 ) : blasvector
  c "kk_axpy"

// Computes the dot product of two real vectors.
// Level 1 BLAS
pub extern blas/dot( a : blasvector, b : blasvector ) : float64
  c "kk_dot"

// Computes the Euclidean norm of a vector.
// Level 1 BLAS
pub extern blas/nrm2( v : blasvector ) : float64
  c "kk_nrm2"

// Performs rotation of points in the plane.
// Level 1 BLAS
// WARNING: This will mutate the `a` and `b` `blasvector`s.
pub extern blas/rot( a : blasvector, b : blasvector, c : float64, s : float64 ) : (blasvector, blasvector)
  c "kk_rot"

// Computes the parameters for a Givens rotation.
// Level 1 BLAS
// Given the Cartesian coordinates `(a, b)` of a point, the `rotg` routines return the parameters `c`, `s`, `r`, and `z` associated with the Givens rotation. 
pub extern blas/rotg( a : float64, b: float64 ) : (float64, float64, float64, float64)
  c "kk_rotg"

// Performs modified Givens rotation of points in the plane.
// Note: `h` is a 2x2 blasmatrix
// Level 1 BLAS
// Returns (x, y)
// Flag options are: -1.0, 0.0, 1.0, -2.0
// WARNING: This will mutate the `x` and `y` `blasvector`s.
pub extern blas/rotm( x : blasvector, y : blasvector, flag : float64, h : blasmatrix ) : (blasvector, blasvector)
  c "kk_rotm"

// Computes the parameters for a modified Givens rotation.
// Level 1 BLAS
// Returns ((d1, d2, x1, x2), flag, h)
// Flag options are: -1.0, 0.0, 1.0, -2.0
pub extern blas/rotmg( d1 : float64, d2 : float64, x1 : float64, y1 : float64 ) : ((float64, float64, float64, float64), float64, blasmatrix)
  c "kk_rotmg"

// Computes the product of a vector by a scalar.
// Level 1 BLAS
// WARNING: This will mutate the `bv` `blasvector`
pub extern blas/scal( bv : blasvector, scalar : float64 ) : blasvector
  c "kk_scal"

// Finds the index of the element with the largest absolute value in a vector.
// Level 1 BLAS
pub extern blas/iamax( x : blasvector ) : int
  c "kk_iamax"

// Finds the index of the element with the smallest absolute value.
// Level 1 BLAS
pub extern blas/iamin( x : blasvector ) : int
  c "kk_iamin"

// These tests are not to check the correctness of the library but the implemenation of the wrappers.
// In other words, these are here to test to see if anything goes wrong.
fun level-one-blas-test()
  basic/test("asum implementation test")
    val bv = blasvector( 2 )
    bv.asum
    expect(True, { True }, details = "asum failed")
  basic/test("axpy implementation test")
    val bv1 = blasvector( 2 )
    val bv2 = blasvector( 2 )
    val scalar = 3.0
    bv1.axpy( bv2, scalar )
    expect(True, { True }, details = "axpy failed")
  basic/test("asum implementation test")
    val bv1 = blasvector( 2 )
    val bv2 = blasvector( 2 )
    bv1.dot( bv2 )
    expect(True, { True }, details = "dot failed")
  basic/test("nrm2 implementation test")
    val bv = blasvector( 2 )
    bv.nrm2
    expect(True, { True }, details = "nrm2 failed")
  basic/test("rot implementation test")
    val bv1 = blasvector( 2 )
    val bv2 = blasvector( 2 )
    val scalar1 = 3.0
    val scalar2 = 3.0
    bv1.rot( bv2, scalar1, scalar2 )
    expect(True, { True }, details = "rot failed")
  basic/test("rotg implementation test")
    val x = 1.0
    val y = 2.0
    rotg( x, y )
    expect(True, { True }, details = "rotg failed")
  basic/test("rotm implementation test")
    val bv1 = blasvector( 2 )
    val bv2 = blasvector( 2 )
    val flag = -1.0
    val bm = blasmatrix( 2, 2 )
    bv1.rotm( bv2, flag, bm )
    expect(True, { True }, details = "rotm failed")
  basic/test("rotmg implementation test")
    val x = 1.0
    val y = 2.0
    val a = 3.0
    val b = 4.0
    rotmg( x, y, a, b )
    expect(True, { True }, details = "rotmg failed")
  basic/test("scal implementation test")
    val bv = blasvector( 2 )
    val scalar = 3.0
    bv.scal( scalar )
    expect(True, { True }, details = "scal failed")
  basic/test("iamax implementation test")
    val bv = blasvector( 2 )
    bv.iamax
    expect(True, { True }, details = "iamax failed")
  basic/test("iamin implementation test")
    val bv = blasvector( 2 )
    bv.iamin
    expect(True, { True }, details = "iamin failed")
  

fun main()
  level-one-blas-test()