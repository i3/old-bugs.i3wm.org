*** ./i3-config-wizard/main.c.orig	2012-01-27 20:24:09.000000000 +0100
--- ./i3-config-wizard/main.c	2012-02-08 19:44:01.000000000 +0100
***************
*** 24,29 ****
--- 24,33 ----
  #include <sys/stat.h>
  #include <fcntl.h>
  #include <glob.h>
+ #if defined(__FreeBSD__)
+ #include <sys/param.h>
+ #endif
+ 
  
  #include <xcb/xcb.h>
  #include <xcb/xcb_aux.h>
***************
*** 283,289 ****
  
      char *line = NULL;
      size_t len = 0;
! #if !defined(__APPLE__)
      ssize_t read;
  #endif
      bool head_of_file = true;
--- 287,293 ----
  
      char *line = NULL;
      size_t len = 0;
! #if !(defined(__APPLE__) || (defined(__FreeBSD__) && __FreeBSD_version < 800000))
      ssize_t read;
  #endif
      bool head_of_file = true;
***************
*** 296,302 ****
      fputs("# this file and re-run i3-config-wizard(1).\n", ks_config);
      fputs("#\n", ks_config);
  
! #if defined(__APPLE__)
      while ((line = fgetln(kc_config, &len)) != NULL) {
  #else
      while ((read = getline(&line, &len, kc_config)) != -1) {
--- 300,306 ----
      fputs("# this file and re-run i3-config-wizard(1).\n", ks_config);
      fputs("#\n", ks_config);
  
! #if defined(__APPLE__) || (defined(__FreeBSD__) && __FreeBSD_version < 800000)
      while ((line = fgetln(kc_config, &len)) != NULL) {
  #else
      while ((read = getline(&line, &len, kc_config)) != -1) {
***************
*** 310,317 ****
  
          /* Skip leading whitespace */
          char *walk = line;
!         while (isspace(*walk) && walk < (line + len))
              walk++;
  
          /* Set the modifier the user chose */
          if (strncmp(walk, "set $mod ", strlen("set $mod ")) == 0) {
--- 314,324 ----
  
          /* Skip leading whitespace */
          char *walk = line;
!         while (isspace(*walk) && walk < (line + len)) {
!             /* Pre-output the skipped whitespaces to keep proper indentation */
!             fputc(*walk, ks_config);
              walk++;
+ 	}
  
          /* Set the modifier the user chose */
          if (strncmp(walk, "set $mod ", strlen("set $mod ")) == 0) {
***************
*** 324,330 ****
          /* Check for 'bindcode'. If it’s not a bindcode line, we
           * just copy it to the output file */
          if (strncmp(walk, "bindcode", strlen("bindcode")) != 0) {
!             fputs(line, ks_config);
              continue;
          }
          char *result = rewrite_binding(walk);
--- 331,337 ----
          /* Check for 'bindcode'. If it’s not a bindcode line, we
           * just copy it to the output file */
          if (strncmp(walk, "bindcode", strlen("bindcode")) != 0) {
!             fputs(walk, ks_config);
              continue;
          }
          char *result = rewrite_binding(walk);
