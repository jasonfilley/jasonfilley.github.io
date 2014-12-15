---
layout: post
title: C - Assignment vs. Equality
permalink: /2012/03/11/c-assignment-vs-equality/
---

I routinely browse the openbsd-cvs mailing list, and I saw this easy openbsd-cvs bug fix [Fix a stupid bug in tcpdump print-bgp.c](http://marc.info/?l=openbsd-tech&m=132966574603292&w=2) the other night when doing some really late-night, partial-involvement sysadmin work.  So I decided to pass the time ("stay awake") by doing a regex exercise to find similar patterns in the OpenBSD source tree.

In C:

* "a = b" (single equals sign) is the assignment operator.  Take the value of "b" and put it in "a."
* "a == b" (double equals signs) is an equality test.  If "a" equals "b" then the expression evaluates true.

It's an [easy bug to introduce](http://www.andromeda.com/people/ddyer/topten.html), using a single = when you want two, so I tried to find more.  Mainly, it was regex practice.

{% highlight perl %}
#!/usr/bin/perl -w

use strict;

if ( $#ARGV < 0 ) {
    die 'Specify a file.\n';
}

my $file = $ARGV[0];

open( SOURCEFILE, '<$file' ) || die 'Can't open file $file.\n';

while (<SOURCEFILE>) {

    my $line = $_;
    chomp($line);

    if ( $line =~ /^\s*if\s.*\s=\s(-)?\d/ ) {

        $line =~ s/^\s*//;s/\s*$//;

        unless ( $line =~ /^(\*|\/\*)/ ) {
            unless ( $line =~ /(\(.*\).*\s=\s)/ ) {
                print '/*$file: $. */\n$line\n\n';
            }
        }
    }
}

close(SOURCEFILE);
{% endhighlight %}

It includes lines that are part of a multi-line comment, but my time and interest are exhausted, and I could have sworn there were compiler options to test for this anyway ...?  And I don't do C.

In the whole tree, I ended up with only a few cases where an assignment occurs in the condition of an if statement:

{% highlight ksh %}
$ find /usr/src -type f -name \*.c -exec ./assigntest.pl '{}' \;
{% endhighlight %}

{% highlight perl %}
/*/usr/src/sys/arch/alpha/alpha/in_cksum.c: 101 */
if ((offset = 3 & (long) lw) != 0) {

/*/usr/src/sys/dev/gpio/gpiodcf.c: 466 */
if ((ymdhm.dt_year = 2000 + FROMBCD(year_bits)) > 2037) {

/*/usr/src/sys/dev/usb/udcf.c: 669 */
if ((ymdhm.dt_year = 2000 + FROMBCD(year_bits)) > 2037) {

/*/usr/src/sys/net/zlib.c: 3830 */
if ((f = 1 << (j = k - w)) > a + 1)     /* try a k-w bit table */

/*/usr/src/bin/ed/main.c: 603 */
if ((garrulous = 1 - garrulous) && *errmsg)

/*/usr/src/bin/rmail/rmail.c: 188 */
if ((from_path = malloc(fptlen = 256)) == NULL)

/*/usr/src/gnu/egcs/libio/floatconv.c: 1878 */
if (j = 11 - hi0bits(word0(d2) & Frac_mask))

/*/usr/src/gnu/usr.bin/binutils/gas/config/tc-i860.c: 606 */
if ((c = 10 * (c - '0') + (*s++ - '0')) >= 32)

/*/usr/src/gnu/usr.bin/binutils/gas/config/tc-sparc.c: 2052 */
if ((c = 10 * (c - '0') + (*s++ - '0')) >= 32)

/*/usr/src/gnu/usr.bin/binutils/gas/config/tc-tic4x.c: 464 */
if (flonum.low > flonum.leader  /* = 0.0e0 */

/*/usr/src/gnu/usr.bin/binutils/gdb/ns32knbsd-nat.c: 297 */
if (enter_addr = 0)

/*/usr/src/gnu/usr.bin/cvs/zlib/inftrees.c: 218 */
if ((f = 1 << (j = k - w)) > a + 1)     /* try a k-w bit table */

/*/usr/src/gnu/usr.bin/gas/config/tc-i860.c: 499 */
if ((c = 10 * (c - '0') + (*s++ - '0')) >= 32) {

/*/usr/src/gnu/usr.bin/gas/config/tc-sparc.c: 745 */
if ((c = 10 * (c - '0') + (*s++ - '0')) >= 32) {

/*/usr/src/gnu/usr.bin/gcc/gcc/testsuite/gcc.c-torture/execute/20001221-1.c: 4 */
if (! (a = 0xfedcba9876543210ULL))

/*/usr/src/gnu/usr.bin/gcc/gcc/testsuite/gcc.dg/20020426-2.c: 103 */
if ((f = 1 << (j = k - w)) > a + 1)

/*/usr/src/gnu/usr.bin/gcc/gcc/testsuite/gcc.dg/c99-bool-1.c: 207 */
if ((u = 2) != 1)

/*/usr/src/gnu/usr.bin/gcc/gcc/testsuite/gcc.dg/compare4.c: 36 */
if (u < (x = -1)) /* { dg-warning 'signed and unsigned' 'MODIFY_EXPR' } */

/*/usr/src/gnu/usr.bin/gcc/gcc/testsuite/gcc.dg/compare4.c: 38 */
if (u < (x = 10))

/*/usr/src/gnu/usr.bin/gcc/gcc/testsuite/gcc.dg/compare4.c: 40 */
if ((x = 10) < u)

/*/usr/src/gnu/usr.bin/binutils-2.17/gas/config/tc-i860.c: 606 */
if ((c = 10 * (c - '0') + (*s++ - '0')) >= 32)

/*/usr/src/gnu/usr.bin/binutils-2.17/gas/config/tc-sparc.c: 2102 */
if ((c = 10 * (c - '0') + (*s++ - '0')) >= 32)

/*/usr/src/gnu/usr.bin/binutils-2.17/gas/config/tc-tic4x.c: 463 */
if (flonum.low > flonum.leader  /* = 0.0e0 */

/*/usr/src/gnu/usr.sbin/sendmail/rmail/rmail.c: 228 */
if ((from_path = malloc(fptlen = 256)) == NULL)

/*/usr/src/lib/libc/gdtoa/dtoa.c: 212 */
if (( j = 11 - hi0bits(word0(&d2) & Frac_mask) )!=0)

/*/usr/src/lib/libc/gdtoa/gdtoa.c: 211 */
if ( (j = 11 - hi0bits(word0(&d) & Frac_mask)) !=0)

/*/usr/src/lib/libc/gdtoa/gdtoa.c: 344 */
if ( (j = 11 - hi0bits(word0(&d) & Frac_mask)) !=0)

/*/usr/src/lib/libc/gdtoa/strtod.c: 74 */
if (!scale || (i = 2*P + 1 - ((word0(x) & Exp_mask) >> Exp_shift)) <= 0)

/*/usr/src/lib/libc/gdtoa/strtod.c: 532 */
if (scale && (j = 2*P + 1 - ((word0(&rv) & Exp_mask)

/*/usr/src/lib/libedit/common.c: 909 */
if (tmplen < 0 || (tmpbuf[tmplen] = 0, parse_line(el, tmpbuf)) == -1)

/*/usr/src/usr.bin/apply/apply.c: 146 */
if ((c = malloc(clen = 1024)) == NULL)

/*/usr/src/usr.bin/xlint/lint1/decl.c: 1913 */
if (!redec && !isredec(dsym, (warn = 0, &warn))) {

/*/usr/src/usr.bin/xlint/lint1/func.c: 306 */
if (!isredec(fsym, (warn = 0, &warn))) {

/*/usr/src/usr.bin/xlint/lint1/tree.c: 3284 */
if (!eqtype(tp, tn->tn_type, 1, 0, (warn = 0, &warn)) || warn)
{% endhighlight %}

They look fine to me, but all the same, it's still a curious idiom to occur so few times.

{% highlight c %}
#toy test
#include <stdio.h>

int main(){
    int     a;
    if ((a = 2000 + 50) > 2037) {
        printf('TRUE - a is %d\n',a);
    }
    else {
        printf('FALSE - a is %d\n',a);
    }
return 0;
}
/* TRUE - a is 2050 */
{% endhighlight %}



