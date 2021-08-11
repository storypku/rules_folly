#define FOLLY_HAVE_EXTRANDOM_SFMT19937
#include "folly/Random.h"

#include "gtest/gtest.h"

TEST(RandomTest, TestFollyRand32) {
  uint32_t kMaxNum = 5;
  uint32_t val = folly::Random::secureRand32(kMaxNum);
  EXPECT_GT(kMaxNum, val);
}
