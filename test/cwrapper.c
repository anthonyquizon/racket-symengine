#include <symengine/cwrapper.h>

#define SYMENGINE_C_ASSERT(cond)                                               \
    {                                                                          \
        if (0 == (cond)) {                                                     \
            printf("SYMENGINE_C_ASSERT failed: %s \nfunction %s (), line "     \
                   "number %d at\n%s\n",                                       \
                   __FILE__, __func__, __LINE__, #cond);                       \
            abort();                                                           \
        }                                                                      \
    }

int main (int argc, char **argv) {
  char *s;

  basic_struct *x = basic_new_heap();

  /*basic x, y, z;*/
  /*basic f;*/
  /*basic_new_stack(x);*/
  /*basic_new_stack(y);*/
  /*basic_new_stack(z);*/
  /*symbol_set(x, "x");*/
  /*symbol_set(y, "y");*/
  /*symbol_set(z, "z");*/

  /*SYMENGINE_C_ASSERT(is_a_Number(x) == 0);*/
  /*SYMENGINE_C_ASSERT(is_a_Number(y) == 0);*/
  /*SYMENGINE_C_ASSERT(is_a_Number(z) == 0);*/

  return 0;
}
