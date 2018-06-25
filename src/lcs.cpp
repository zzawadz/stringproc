#include <Rcpp.h>
#include <string>
using namespace Rcpp;

NumericMatrix longest_common_backtrack(std::string x, std::string y) {

  NumericMatrix res(x.size() + 1, y.size() + 1);
  NumericMatrix backtrack(x.size() + 1, y.size() + 1);

  for(size_t i = 0; i < x.size() + 1; i++) res[i,0] = 0;
  for(size_t j = 0; j < y.size() + 1; j++) res[0,j] = 0;

  for(size_t i = 1; i < x.size()   + 1; i++) {
    for(size_t j = 1; j < y.size() + 1; j++) {

      int match = x[i-1] == y[j-1] ? 1 : 0;

      res.at(i,j) = std::max(res.at(i-1,j),
             std::max(res.at(i,j-1), res.at(i-1,j-1) + match));

      if(res.at(i,j) == res.at(i-1,j-1)) {
        backtrack.at(i,j) = 4;
      } else if(res.at(i,j) == res.at(i-1,j)) {
        backtrack.at(i,j) = 1;
      } else if(res.at(i,j) == res.at(i, j-1)) {
        backtrack.at(i,j) = 2;
      } else if((res.at(i,j) == res.at(i-1,j-1) + 1) && x[i-1] == y[j-1]) {
        backtrack.at(i,j) = 3;
      }

    }
  }

  return backtrack;
}

std::pair<std::string, std::string> output_lcs(
    const NumericMatrix& backtrack,
    const std::string& x,
    const std::string& y,
    int i,
    int j) {

  std::pair<std::string, std::string> result;

  if(i == 0 && j == 0) return result;

  // some letters in y are still unused
  if(i > 0 && j == 0) {
    result =  output_lcs(backtrack, x, y, i - 1, j);
    result.first += x[i - 1];
    result.second += "-";
    return result;
  }

  // some letters in x are still unused
  if(i == 0 && j > 0) {
    result =  output_lcs(backtrack, x, y, i, j - 1);
    result.first += "-";
    result.second += y[j - 1];
    return result;
  }


  if(backtrack.at(i,j) == 1) {
   result =  output_lcs(backtrack, x, y, i - 1, j);
    result.first += x[i - 1];
    result.second += "-";
   return result;
  }
  if(backtrack.at(i,j) == 2) {
    result = output_lcs(backtrack, x, y, i, j - 1);
    result.first += "-";
    result.second += y[j - 1];
    return result;
  }
  if(backtrack.at(i,j) == 3) {
    result = output_lcs(backtrack, x, y, i - 1, j - 1);
    result.first  += x[i - 1];
    result.second += x[i - 1];
    return result;
  }
  if(backtrack.at(i,j) == 4) {
    result = output_lcs(backtrack, x, y, i - 1, j - 1);
    result.first  += x[i - 1];
    result.second += y[j - 1];
    return result;
  }

  return result;
}

// [[Rcpp::export]]
std::vector<std::string> longest_common_subseq(std::string x, std::string y) {

  NumericMatrix backtrack = longest_common_backtrack(x, y);

  std::pair<std::string, std::string> result = output_lcs(backtrack, x, y, x.size(), y.size());
  std::vector<std::string> res;
  res.push_back(result.first);
  res.push_back(result.second);
  return res;
}
