#include <catch.hpp>
#include <iostream>
#include "gsl/gsl_matrix.h"
#include "mathfunc.h"
#include <algorithm>
#include <limits>
#include <numeric>

using namespace std;

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

  vector<double> v = {1.0, 2.0};
  REQUIRE (!std::isnan(std::accumulate(v.begin(), v.end(), 0)));
  vector<double> v2 = {1.0, 2.0, std::numeric_limits<double>::quiet_NaN()};
  REQUIRE (std::isnan(v2[2]));
  // REQUIRE (std::isnan(std::accumulate(v2.begin(), v2.end(), 0)));
  for (auto i = v2.begin(); i != v2.end(); ++i)
    cout << *i << ' ';
  double multi = 1.0;
  for (const auto& e: v2) {
    REQUIRE( multi );
    cout << multi << "," << e << ":";
    multi *= e;
  }
  cout << multi;
  REQUIRE(std::isnan(multi));
  // REQUIRE (std::isnan(std::accumulate(v2.begin(), v2.end(), 1, std::multiplies<double>())));
}
