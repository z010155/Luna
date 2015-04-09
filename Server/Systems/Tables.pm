package Tables;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       $obj->{boardMap} = [[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
       return $obj;
}

method handleJoinTable($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intTable = $arrData[5];
       return if(!int($intTable) || !exists($self->{child}->{tables}->{$intTable}));
       if (scalar (keys %{$self->{child}->{tables}->{$intTable}->{clients}}) >= $self->{child}->{tables}->{$intTable}->{max} || $objClient->{tableID} ne 0) {
           return $objClient->sendError(211);
       }
       $objClient->{tableID} = $intTable;
       $self->{child}->{tables}->{$intTable}->{clients}->{$objClient->{username}} = $objClient;
       $self->{child}->{tables}->{$intTable}->{boardMap} = $self->{boardMap};
       $objClient->{seatID} = scalar(keys %{$self->{child}->{tables}->{$intTable}->{clients}});
       $objClient->sendXT(['jt', '-1', $objClient->{tableID}, $objClient->{seatID}]);
}

method handleGetTable($strData, $objClient) {
       my @arrData = split('%', $strData);
       splice(@arrData, 0, 5);
       my $tablePopulation = '';
       foreach (@arrData) {
                if (exists($self->{child}->{tables}->{$_})) {
                    $tablePopulation .= $_ . '|' . scalar(keys %{$self->{child}->{tables}->{$_}->{clients}}) . '%';
                }
       }
       $objClient->sendXT(['gt', '-1', substr($tablePopulation, 0, -1)]);
}

method handleUpdateTable($strData, $objClient) {
       my @arrData = split('%', $strData);
       $objClient->sendRoom('%xt%ut%' . $arrData[5] . '%' . $arrData[6] . '%');
}

method handleLeaveTable($strData, $objClient) {
       if ($objClient->{room} eq 220 || $objClient->{room} eq 221) {
           if ($objClient->{tableID} ne 0 && $objClient->{seatID} ne 999) {
               foreach (values (%{$self->{child}->{tables}->{$objClient->{tableID}}->{clients}})) {
                        if ($_->{ID} ne $objClient->{ID}) {
                            $_->sendXT(['cz', '-1', $objClient->{username}]);
                            $_->{tableID} = 0;
                            $_->{seatID} = 999;
                        }
               }
               $self->{child}->{tables}->{$objClient->{tableID}} = {clients => {}, max => 2};
               $objClient->{tableID} = 0;
               $objClient->{seatID} = 999;
          }
      }
}

1;
