#define CATCH_CONFIG_MAIN  // This tells Catch to provide a main() - only do this in one cpp file

#include <catch.hpp>
#include "gsl/gsl_matrix.h"
#include "mathfunc.h"

TEST_CASE( "Math functions", "[math]" ) {
  double data[] = {2,-1,0, -1,2,-1, 0,-1,2};
  gsl_matrix *m = gsl_matrix_alloc(3,3);
  copy(data, data+9, m->data);
  REQUIRE( isMatrixPositiveDefinite(m) );

  double data1[] = {1.0,0,0, 0,3.0,0, 0,0,2.0};
  copy(data1, data1+9, m->data);
  REQUIRE( isMatrixPositiveDefinite(m) );

  double data2[] = {1,1,1, 1,1,1, 1,1,0.5};
  copy(data2, data2+9, m->data);
  REQUIRE( !isMatrixPositiveDefinite(m));
}
