package End;

use 5.006;

use strict;
use warnings;
no  warnings 'syntax';

use Exporter;

our @ISA     = qw /Exporter/;
our @EXPORT  = qw /end/;

our $VERSION = '2015020701';

sub end (&) {
    my    $code =  shift;
    bless { code => $code } => __PACKAGE__;
}

sub clear { $_[0]->{'code'} = undef }

DESTROY { $_[0]->{'code'}->() if $_[0]->{'code'} }

1;

__END__

=pod

=head1 NAME 

End - generalized END {}.

=head1 SYNOPSIS

    use End;

    {  my $foo = end {print "Leaving the block\n"};
       ...
       last;    # prints "Leaving the block\n".
       ...
    }

    { my $bar = end {print "Leaving the second block\n"};
      ...
      $bar->clear;   # End block is no longer needed.  Turn it off.
      last;          # nothing printed
      ...
    }


=head1 DESCRIPTION

The module C<End> exports a single subroutine C<end>, which allows
you to set up some code that is run whenever the current block is exited,
regardless whether that is due to a C<return>, C<next>, C<last>, C<redo>,
C<exit>, C<die>, C<goto> or just reaching the end of the block.

To be more precise, C<end> returns an object, that will execute the
code when the object is destroyed; that is, when the variable assigned
to goes out of scope. If the variable is lexical to the current block,
the code will be executed when leaving the block. 

One can force premature execution of the code by undefining the variable
assigned to, or assigning another value to the variable. 

C<end> only takes one argument, a code reference. If one wishes the code
reference to take arguments, wrapping the code reference in a closure
suffices.

The object returned by C<end> provides a method disabling your end
of block code.  Calling C<clear> on the returned C<end> object will
wipe out the end block.

=head1 BUGS

Due to a bug in Perl 5.6.0 (and perhaps before), anonymous subroutines
that are not a closure will not go out of scope, not even on program
termination. That is why C<end> wraps the code fragment in a closure.

There is a second bug in Perl 5.6.0 (and perhaps before) why this is
necessary. If the code fragment isn't wrapped in another code reference,
the original subroutine will be blessed in the package, making that C<ref>
on that code no longer returns the right value.

=head1 DEVELOPMENT

The current sources of this module are found on github,
L<< git://github.com/Abigail/end.git >>.

=head1 SEE ALSO

L<Manip::END>, L<Perl::AtEndOfScope>, L<B::Hooks::EndOfScope>.

=head1 AUTHOR

This package was written by Abigail, L<< mailto:cpan@abigail.be >>

=head1 COPYRIGHT & LICENSE

Copyright (C) 2000 - 2009, Abigail

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHOR BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

=cut
