#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#ifdef __MSDOS__
#define _WIN32
#endif

#ifdef HAVE_LIBGL
#ifdef HAVE_LIBOSMESA
#define GLEW_OSMESA
#endif

#include "GL/glew.c"
#endif /* HAVE_LIBGL */
