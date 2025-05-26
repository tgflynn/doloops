# doloops
A Common Lisp nested loop macro

This is a very simple project to illustrate a method for writing a
Common Lisp macro for nested loops.  It works in a similar manner to
dotimes but accepts multiple variable/count specifications and
implements a loop that nests them all.

It seems to me that this technique could be useful in reducing
cyclomatic complexity in software, since nested loops are probably
quite common.

The reason for doing this example implementation in CL is that the
macro system allows it to be done without modifying the language
itself. 

The name of the main function is doloops with associated test function
dotestloops. 

Also included is a version called doexp that doesn't use macros but
calls a lambda function with a variable counter instead.  This version
can be implemented in any language that supports arrays and
higher-order functions.

I have only tested this code with sbcl on Linux.

I'm very interested in all comments on the this idea.

The simplest way to test the macro is with:

```
$ sbcl --script test1.lisp

Expected Output:

i=0 j=0
i=0 j=1
i=0 j=2
i=0 j=3
i=0 j=4
i=1 j=0
i=1 j=1
i=1 j=2
i=1 j=3
i=1 j=4
i=2 j=0
i=2 j=1
i=2 j=2
i=2 j=3
i=2 j=4
i=3 j=0
i=3 j=1
i=3 j=2
i=3 j=3
i=3 j=4
i=4 j=0
i=4 j=1
i=4 j=2
i=4 j=3
i=4 j=4


