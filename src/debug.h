#ifndef __DEBUG_H__
#define __DEBUG_H__

// enforce works like assert but also when NDEBUG is set (i.e., it
// always works). enforce_msg prints message instead of expr

# define enforce(expr)							\
  ((expr)                                                               \
   ? __ASSERT_VOID_CAST (0)                                             \
   : __assert_fail (__STRING(expr), __FILE__, __LINE__, __ASSERT_FUNCTION))

# define enforce_msg(expr, msg)						\
  ((expr)                                                               \
   ? __ASSERT_VOID_CAST (0)                                             \
   : __assert_fail (msg, __FILE__, __LINE__, __ASSERT_FUNCTION))

#endif
