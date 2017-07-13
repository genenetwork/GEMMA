
#ifndef __SUPPORT_H__
#define __SUPPORT_H__

/* This prints an "Assertion failed" message and aborts.  */
//extern "C" void __assert_fail (const char *__assertion, const char *__file,
//                           unsigned int __line, const char *__function)
//     __THROW __attribute__ ((__noreturn__));

// enforce works like assert but also when NDEBUG is set (i.e., it
// always works)

# define enforce(expr)                                                   \
  ((expr)                                                               \
   ? __ASSERT_VOID_CAST (0)                                             \
   : __assert_fail (__STRING(expr), __FILE__, __LINE__, __ASSERT_FUNCTION))

#endif
