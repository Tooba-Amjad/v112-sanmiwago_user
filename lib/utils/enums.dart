enum PageType {
  to,
  off,
  offAll,
}

enum EnvType {
  dev,
  ddev,
  merge,
  prod1,
  prod1old,
  prod1new,
  prod2,
  prodaws,
  prodbackup,
  prod,
}

enum DT {
  coupon,
  gift,
  spdiscount,
  msdiscount,
}

/// Which post-placement waiting flow [WaitingPage] is handling.
enum OrderWaitFlow {
  cart,
  subscription,
}
