package Gaming;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       return $obj;
}

method handleGaming($strData, $objClient) {}

1;
