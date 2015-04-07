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
       return if(!int($arrData[5]) || !exists($self->{child}->{tables}->{$arrData[5]}));
       if (keys (%{$self->{child}->{tables}->{$arrData[5]}{clients}}) >= $self->{child}->{tables}->{$arrData[5]}->{max} || $objClient->{tableID} ne 0) {
           return $objClient->sendError(211);
       }
       $objClient->{tableID} = $arrData[5];
       $self->{child}->{tables}->{$arrData[5]}->{clients}->{$objClient->{username}} = $objClient;
       $self->{child}->{tables}->{$arrData[5]}->{boardMap} = $self->{boardMap};
       $objClient->{seatID} = keys (%{$self->{child}->{tables}->{$arrData[5]}{clients}});
       $objClient->sendXT(['jt', '-1', $objClient->{tableID}, $objClient->{seatID}]); #TableID%SeatID
}

method handleGetTable($strData, $objClient) {
       my @arrData = split('%', $strData);
       splice(@arrData, 0, 5);
       my $tablePopulation = '';
       foreach (@arrData) {
                if (exists($self->{child}->{tables}{$_})) {
                    $tablePopulation .= $_ . '|' . keys (%{$self->{child}->{tables}{$_}{clients}}) . '%';
                }
       }
       $objClient->sendXT(['gt', '-1', substr($tablePopulation, 0, -1)]);
}

method handleUpdateTable($strData, $objClient) {
       my @arrData = split('%', $strData);
       $objClient->sendRoom('%xt%ut%' . $arrData[5] . '%' . $arrData[6] . '%'); # TableID%Players
}

method handleLeaveTable($strData, $objClient) {
       if ($objClient->{room} eq 220 || $objClient->{room} eq 221) { # find four
           if ($objClient->{tableID} ne 0 && $objClient->{seatID} ne 999) {
               foreach (values (%{$self->{child}->{tables}->{$objClient->{tableID}}->{clients}})) {
                        if ($_->{ID} ne $objClient->{ID}) {
                            $_->sendXT(['cz', '-1', $objClient->{username}]);
                            $_->{tableID} = 0;
                            $_->{seatID} = 999;
                        }
               }
               $self->{child}->{tables}->{$objClient->{tableID}} = {'clients' => {}, 'max' => 2};
               $objClient->{tableID} = 0;
               $objClient->{seatID} = 999;
          }
      }
}

1;
